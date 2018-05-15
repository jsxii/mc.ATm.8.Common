;------------------------------------------------------------
; Time service - Interrupt
;------------------------------------------------------------
TimerService:
; save registers
	PUSH	R16
	IN	R16, SREG
	PUSH 	R16
	PUSH	ZL
	PUSH	ZH
	PUSH	R17
; load addr
	LDI	ZL, low(TimersPool)
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
	SBCI	R16, 1			; counter - 1 - C flag
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
; restore registers
	POP	R17
	POP	ZH
	POP	ZL
	POP	R16
	OUT	SREG, R16
	POP	R16
	RETI
;------------------------------------------------------------
; Set timer
;------------------------------------------------------------
SetTimer:				; R16 = task id, X = timer
; save registers
	PUSH	R17
	PUSH	R18
	PUSH	ZL
	PUSH	ZH
;
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
	CLI				; Atomic
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
