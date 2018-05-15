;-- Process task queue --------------------------------------
ProcessTaskQueue:
	LDS	R16, TaskIndexIn
	LDS	R17, TaskIndexOut
	CP	R17, R16
	BRNE	PTQ2
	RET				; Queue empty
PTQ2:	LDI	ZL, low(TaskQueue)
	LDI	ZH, high(TaskQueue)
	INC	R17
	ANDI	R17, TaskQueueSize-1
	ADD	ZL, R17
	ADC	ZH, c00
	LD	R16, Z			; R16 = Task id
	STS	(TaskIndexOut), R17
	LSL	R16			; calculate vector address
	LDI	ZL, low(TaskTable * 2)
	LDI	ZH, high(TaskTable * 2)
	ADD	ZL, R16
	ADC	ZH, c00		; const
	LPM			; read task address: read flash to R0
	MOV	R16, R0		; save to R16
	LD	R0, Z+		; Z++
	LPM			; read flash to R0
	MOV	ZH, R0
	MOV	ZL, R16	
	IJMP			; go to task (Z=task address, in stack return to mainloop address)
;-- Set task to queue ---------------------------------------
SetTaskInQueue:
	PUSH	R17
	PUSH	R18
	LDS	R17, TaskIndexIn
	LDS	R18, TaskIndexOut
	INC	R17
	ANDI	R17, TaskQueueSize-1
	CP	R17, R18
	BRNE	STQ2
	MOV	R16, cFF		; queue full !!
	POP	R18
	POP	R17
	RET
STQ2:	PUSH	ZL
	PUSH	ZH
	LDI	ZL, low(TaskQueue)
	LDI	ZH, high(TaskQueue)
	ADD	ZL, R17
	ADC	ZH, c00			; const
	ST	Z, R16	
	STS	(TaskIndexIn), R17
	MOV	R16, c00
	POP	ZH
	POP	ZL
	POP	R18
	POP	R17
	RET
;-- Init RTOS -----------------------------------------------
InitRTOS:
	CLR	R16			; init queue
	STS	(TaskIndexIn), R16
	STS	(TaskIndexOut), R16
	LDI	R16, Tmr_Prescaler	; init timer
	OUT	TCCR0, R16
	LDI	R16, Tmr_Counter
	OUT	TCNT0, R16
	IN	R16, TIMSK
	ORI	R16, 0x01
	OUT	TIMSK, R16
	RCALL	ClearTimers		; init queue
	CLR	R16			; reset SREG
	OUT	SREG, R16
;	SEI				; enable interrupts
	RET
ClearTimers:
	PUSH	R17
	PUSH	ZL
	PUSH	ZH
	LDI	ZL, low(TimersPool)
	LDI	ZH, high(TimersPool)
	LDI	R17, TimersPoolSize
CT01:	ST	Z+, cFF
	ST	Z+, c00
	ST	Z+, c00
	DEC	R17
	BRNE	CT01
	POP	ZH
	POP	ZL
	POP	R17
	RET
;-- Time service - Interrupt --------------------------------
TimerService:
	PUSH	R16		; save registers
	IN	R16, SREG
	PUSH	R16		; save SREG
	LDI	R16, Tmr_Counter	; restore countdown
	OUT	TCNT0, R16
	IN	R16, TIMSK		; reenable Int
	ORI	R16, 0x01
	OUT	TIMSK, R16
	PUSH	R17		; save registers
	PUSH	ZL
	PUSH	ZH
	LDI	ZL, low(TimersPool)	; load addr
	LDI	ZH, high(TimersPool)
	LDI	R17, TimersPoolSize	; max timers number
TimSrvc01:
	LD	R16, Z			; Get task id
	CPI	R16, 0xFF		; Empty if 'FF'
	BREQ	TimSrvc03		; next timer if empty
	CLT				; clear T flag
	LDD	R16, Z+1		; get low(counter)
	SUBI	R16, 1			; counter--
	STD	Z+1, R16		; put low(counter)
	BREQ	TimSrvc02		; if counter == 0 skip setting T
	SET
TimSrvc02:
	LDD	R16, Z+2		; get high(counter)
	SBCI	R16, 0			; counter - C flag
	STD	Z+2, R16		; put high(counter)
	BRNE	TimSrvc03		; high(counter) not 0 - next timer
	BRTS	TimSrvc03		; low(counter) not 0 (T flag) - next timer
	LD	R16, Z			; get task id
	RCALL	SetTaskInQueue		; Push in task queue
	ST	Z, cFF			; Save in id 'FF' - timer empty
TimSrvc03:
	SUBI	ZL, Low(-3)		; next timer - Z += 3
	SBCI	ZH, High(-3)
	DEC	R17			; if counter not 0
	BRNE	TimSrvc01		; next timer
	POP	ZH			; restore registers
	POP	ZL
	POP	R17
	POP	R16
	OUT	SREG, R16
	POP	R16
	RETI
;-- Set timer -----------------------------------------------
SetTimer:	; R16 = task id, X = timer
	PUSH	R17	; save registers
	PUSH	R18
	PUSH	ZL
	PUSH	ZH
	LDI	ZL, low(TimersPool)
	LDI	ZH, high(TimersPool)
	LDI	R18, TimersPoolSize
SetTim01:
 	LD	R17, Z			; get id
	CP	R17, R16		; if task exists
	BREQ	SetTim02		; update timer
	SUBI	ZL, Low(-3)		; next timer
	SBCI	ZH, High(-3)
	DEC	R18
	BREQ	SetTim03		; next part if no found 
	RJMP	SetTim01		; check next timer
SetTim02:
	CLI
	ST	Z, R16			; Atomic
	STD	Z+1, XL			; Update timer
	STD	Z+2, XH
	SEI				; End atomic
	MOV	R16, c00		; timer sets.
	RJMP	SetTim05		; Exit
SetTim03:
	LDI	ZL, low(TimersPool)
	LDI	ZH, high(TimersPool)
	LDI	R18, TimersPoolSize
SetTim04:
	LD	R17, Z			; get id
	CP	R17, cFF		; empty ?
	BREQ	SetTim02		; set timer
	SUBI	ZL, Low(-3)
	SBCI	ZH, High(-3)
	DEC	R18
	BRNE	SetTim04		; next
	MOV	R16, cFF		; set timer fail. exit
SetTim05:
	POP	ZH
	POP	ZL
	POP	R18
	POP	R17
	RET
;------------------------------------------------------------
