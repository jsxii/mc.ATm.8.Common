;------------------------------------------------------------
;------------------------------------------------------------
Idle:
; Empty cycle task, background
	RET
;------------------------------------------------------------
TaskTable:
;	.dw	<Task Label> (=task addr)
	.dw	Idle	; [00] Idle
	.dw	OnLed0	; [01] TS_OnLed0
	.dw	OffLed0	; [02] TS_OffLed0
	.dw	OnLed1	; [03] TS_OnLed1
	.dw	OffLed1	; [04] TS_OffLed1
	.dw	OnLed2	; [05] TS_OnLed2
	.dw	OffLed2	; [06] TS_OffLed2
	.dw	OnLed3	; [07] TS_OnLed3
	.dw	OffLed3	; [08] TS_OffLed3
	.dw	OnLed4	; [09] TS_OnLed4
	.dw	OffLed4	; [0A] TS_OffLed4
	.dw	OnLed5	; [0B] TS_OnLed5
	.dw	OffLed5	; [0C] TS_OffLed5
	.dw	OnLed6	; [0D] TS_OnLed6
	.dw	OffLed6	; [0E] TS_OffLed6
	.dw	OnLed7	; [0F] TS_OnLed7
	.dw	OffLed7	; [10] TS_OffLed7
; etc...
;------------------------------------------------------------

;------------------------------------------------------------
.equ	TS_Idle = 0	; Task alias (const)
;.equ	TS_<Name> = <Index>
.equ	TS_OnLed0 = 1
.equ	TS_OffLed0 = 2
.equ	TS_OnLed1 = 3
.equ	TS_OffLed1 = 4
.equ	TS_OnLed2 = 5
.equ	TS_OffLed2 = 6
.equ	TS_OnLed3 = 7
.equ	TS_OffLed3 = 8

.equ	TS_OnLed4 = 9
.equ	TS_OffLed4 = 10
.equ	TS_OnLed5 = 11
.equ	TS_OffLed5 = 12
.equ	TS_OnLed6 = 13
.equ	TS_OffLed6 = 14
.equ	TS_OnLed7 = 15
.equ	TS_OffLed7 = 16
;------------------------------------------------------------
OnLed0:
	SBI	PORTD, 0
	SetTT	TS_OffLed0, 100
	RET
;------------------------------------------------------------
OffLed0:
	CBI	PORTD, 0
	SetTT	TS_OnLed0, 100
	RET
;------------------------------------------------------------
OnLed1:
	SBI	PORTD, 1
	SetTT	TS_OffLed1, 200
	RET
;------------------------------------------------------------
OffLed1:
	CBI	PORTD, 1
	SetTT	TS_OnLed1, 200
	RET
;------------------------------------------------------------
OnLed2:
	SBI	PORTD, 2
	SetTT	TS_OffLed2, 400
	RET
;------------------------------------------------------------
OffLed2:
	CBI	PORTD, 2
	SetTT	TS_OnLed2, 400
	RET
;------------------------------------------------------------
OnLed3:
	SBI	PORTD, 3
	SetTT	TS_OffLed3, 800
	RET
;------------------------------------------------------------
OffLed3:
	CBI	PORTD, 3
	SetTT	TS_OnLed3, 800
	RET
;------------------------------------------------------------
OnLed4:
	SBI	PORTD, 4
	SetTT	TS_OffLed4, 1600
	RET
;------------------------------------------------------------
OffLed4:
	CBI	PORTD, 4
	SetTT	TS_OnLed4, 1600
	RET
;------------------------------------------------------------
OnLed5:
	SBI	PORTD, 5
	SetTT	TS_OffLed5, 3200
	RET
;------------------------------------------------------------
OffLed5:
	CBI	PORTD, 5
	SetTT	TS_OnLed5, 3200
	RET
;------------------------------------------------------------
OnLed6:
	SBI	PORTD, 6
	SetTT	TS_OffLed6, 6400
	RET
;------------------------------------------------------------
OffLed6:
	CBI	PORTD, 6
	SetTT	TS_OnLed6, 6400
	RET
;------------------------------------------------------------
OnLed7:
	SBI	PORTD, 7
	SetTT	TS_OffLed7, 12800
	RET
;------------------------------------------------------------
OffLed7:
	CBI	PORTD, 7
	SetTT	TS_OnLed7, 12800
	RET


