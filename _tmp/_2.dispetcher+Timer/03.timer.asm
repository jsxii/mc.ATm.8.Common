;============================================================
; TaskTimerInit ; void ; void ; [ R16,Z ] ; Init & start timer0
; TimerQueueInt ; void ; void ; [--] ; ISR
; SetTaskOnTimer ; R17=status ; R17=TaskId,R18=Param,R19=CounterLow,R20=CounterHigh ; [ R16,Z ] ; Set task to TimerQueue ; 0x00 -Success, 0x01 - no slot.
;------------------------------------------------------------
; TCCR0 - |0|0|0|0||0|cs2|cs1|cs0| - 0=stop, 1=f, 2=f/8, 3=f/64, 4=f/256, 5=f/1024, 6,7=Ext clk on T0 pin (6-falling edge,7-rising edge)
; TIMSK - |OCIE2|TOIE2|TICIE1|OCIE1A|OCIE1B|TOIE1|-|TOIE0|
;------------------------------------------------------------
;	~1ms	| 16MHz	12MHz	8MHz	4MHz	2MHz	1MHz
;------------------------------------------------------------
; TQ_Counter	| 0x06	0x44	0x83	0xC1	0x06	0x83
; TQ_Prescaler	| 0x03	0x03	0x03	0x03	0x02	0x02
;============================================================
TaskTimerInit:	; void ; void ; [ R16,Z ]
.equ	TQ_Counter =	0x83	; 8MHz
.equ	TQ_Prescaler =	0x03
;-- Set Timer0
LDI	R16,TQ_Prescaler
OUT	TCCR0,R16
LDI	R16,TQ_Counter
OUT	TCNT0,R16
IN	R16,TIMSK
ORI	R16,0x01		; Set TOIE0 - Enable timer0 overflow interrupt
OUT	TIMSK,r16
;-- Clear queue
CLR	R16
LDI	ZL,low(TimerQueue)
LDI	ZH,high(TimerQueue)
LDI	R17,MaxTimerQueueLen * 4
TaskTimerInit1:
ST	Z+,R16
DEC	R17
BRNE	TaskTimerInit1
RET 
;============================================================
SetTaskOnTimer:
;------------------------------------------------------------
PUSH	R17			; Save data
PUSH	R18
PUSH	R19
;------------------------------------------------------------
LDI	R19,MaxTimerQueueLen	; Counter
;------------------------------------------------------------
TQ_Loop2:
LDI	ZL,low(TimerQueue)	; Set 'Z' = Timer Queue addr
LDI	ZH,high(TimerQueue)
MOV	R17,R19			; Counter
CLR	R18
CLC
ROL	R17			; Counter*4
ROL	R18
ROL	R17
ROL	R18
ADD	ZL,R17			; 'Z' + Counter*4
ADC	ZH,R18
LD	R16,Z			; R16 <- TaskId
CPI	R16,0x00		; Check TaskId
BRNE	TQ_Next2		; If TaskId <> 0 then next
;-- Set Timer
POP	R19			; Restore data
POP	R18
POP	R17
ST	Z+,R17			; Set Task to Queue
ST	Z+,R19
ST	Z+,R20
ST	Z,R18
LDI	R17,0x00		; 0x00 - Success.
RET				; Return
;------------------------------------------------------------
TQ_Next2:
DEC	R19			; Dec Counter
BRNE	TQ_Loop2		; Next Cycle
;------------------------------------------------------------
TQ_Exit2:
LDI	R17,0x01		; 0x01 - No slot for task
RET
;============================================================
TimerQueueInt:
;------------------------------------------------------------
PUSH	R16			; Save regs
IN	R16,SREG
PUSH	R16
PUSH	R17
PUSH	R18
PUSH	R19
PUSH	ZL
PUSH	ZH
;------------------------------------------------------------
LDI	R16,TQ_Counter		; Set Counter to next interrupt
OUT	TCNT0,R16
;------------------------------------------------------------
LDI	R19,MaxTimerQueueLen	; Counter
;------------------------------------------------------------
TQ_Loop:
LDI	ZL,low(TimerQueue)	; Set 'Z' = Timer Queue addr
LDI	ZH,high(TimerQueue)
MOV	R17,R19			; Counter
CLR	R18
CLC
ROL	R17			; Counter*4
ROL	R18
ROL	R17
ROL	R18
ADD	ZL,R17			; 'Z' + Counter*4
ADC	ZH,R18
LD	R16,Z			; R16 <- TaskId
CPI	R16,0x00		; Check TaskId
BRNE	TQ_Count1		; If TaskId <> 0 then check
ST	Z+,R16			; TaskId <- 0
ST	Z+,R16			; CounterLow <- 0
ST	Z+,R16			; CounterHigh <- 0
ST	Z,R16			; TaskParam <- 0
;------------------------------------------------------------
TQ_Next:
DEC	R19			; Dec Counter
BRNE	TQ_Loop			; Next Cycle
;------------------------------------------------------------
TQ_Exit:
POP	ZH			; Restore regs
POP	ZL
POP	R19
POP	R18
POP	R17
POP	R16
OUT	SREG,R16
POP	R16
RETI
;------------------------------------------------------------
TQ_Count1:			;-- Decrease & Check CounterLow
ADIW	Z,0x01			; Z++ (CounterLow)
LD	R17,Z			; R17 <- CounterLow
DEC	R17			; CounterLow--
BREQ	TQ_Count2			; If '0' then check again
ST	Z,R17			; Save CounterLow
RJMP	TQ_Next			; Next  Cycle
TQ_Count2:				; Check again
ADIW	Z,0x01			; Z++ (CounterHigh)
LD	R17,Z			; R17 <- CounterHigh
CPI	R17,0x00		; Check
BREQ	TQ_SetTask		; If '0' then SetTask
DEC	R17			; CounterHigh--
ST	Z,R17			; Save
RJMP	TQ_Next			; Next Cycle
;------------------------------------------------------------
TQ_SetTask:
ADIW	Z,0x01			; Z++ (TaskParam)
LD	R18,Z			; R18 <- TaskParam
MOV	R17,R16			; R17 <- TaskId
CLR	R16			; R16 <- '0'
ST	Z,R16			; Clear TaskParam
ST	-Z,R16			; Clear CounterHigh
ST	-Z,R16			; Clear CounterLow
ST	-Z,R16			; Clear TaskId
RCALL	SetTask		; SetTask
;---
; TODO: check TD_SetTask successfully
;---
RJMP	TQ_next			; Next Cycle
;============================================================
