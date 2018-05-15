;-- Empty cycle task + background ---------------------------
Idle:
	RET
;-- Task Addresses ------------------------------------------
TaskTable:
;	.dw	<Task Label> (=task addr)
	.dw	Idle	; [00] Idle
	.dw	OnLed0	; [01] TS_OnLed0
	.dw	OffLed0	; [02] TS_OffLed0
;------------------------------------------------------------

;-- Task alias ----------------------------------------------
.equ	TS_Idle		= 0 	; .equ	TS_<Name> = <Index>
.equ	TS_OnLed0	= 1
.equ	TS_OffLed0	= 2
;------------------------------------------------------------
OnLed0:
	SBI	PORTB, 0
	SetTT	TS_OffLed0, 1
	LDS	R17, char
	INC	R17
	STS	char, R17
	RCALL	LCDDataWR
	RET
;------------------------------------------------------------
OffLed0:
	CBI	PORTB, 0
	SetTT	TS_OnLed0, 1
	LDS	R17, char
	INC	R17
	STS	char, R17
	RCALL	LCDDataWR
	RET
;------------------------------------------------------------
