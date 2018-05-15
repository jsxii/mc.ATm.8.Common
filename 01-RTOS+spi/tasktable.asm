;------------------------------------------------------------
;------------------------------------------------------------
Idle:
; Empty cycle task, background
	RET
;------------------------------------------------------------
TaskTable:
;	.dw	<Task Label> (=task addr)
	.dw	Idle	; [00] Idle
	.dw	OnLed3	; [01] TS_OnLed3
	.dw	OffLed3	; [02] TS_OffLed3
	.dw	TBSOD	; [03] TBSOD
; etc...
;------------------------------------------------------------

;------------------------------------------------------------
.equ	TS_Idle = 0	; Task alias (const)
;.equ	TS_<Name> = <Index>
.equ	TS_OnLed3 = 1
.equ	TS_OffLed3 = 2
.equ	TS_BSOD = 3
;------------------------------------------------------------
OnLed3:
	SBI	PORTD, 3
	SetTT	TS_OffLed3, 50
	SBI	SPCR, 7
	RET
;------------------------------------------------------------
OffLed3:
	CBI	PORTD, 3
	SetTT	TS_OnLed3, 50
	LDS	R16, Vram
	ROL	R16
;	EOR	R16, R11
	STS	Vram, R16
	LDS	R16, Vram+1
	ROR	R16
;	EOR	R16, R11
	STS	Vram+1, R16
	LDS	R16, Vram+2
	ROL	R16
;	EOR	R16, R11
	STS	Vram+2, R16
	LDS	R16, Vram+3
	ROR	R16
;	EOR	R16, R11
	STS	Vram+3, R16
	LDS	R16, Vram+4
	ROL	R16
;	EOR	R16, R11
	STS	Vram+4, R16
	LDS	R16, Vram+5
	ROR	R16
;	EOR	R16, R11
	STS	Vram+5, R16
	LDS	R16, Vram+6
	ROL	R16
;	EOR	R16, R11
	STS	Vram+6, R16
	LDS	R16, Vram+7
	ROR	R16
;	EOR	R16, R11
	STS	Vram+7, R16
	RET
;------------------------------------------------------------
;------------------------------------------------------------
TBSOD:
	LDI	R16, 0xFF
	RCALL	PrintStatus
	RJMP	TBSOD
;------------------------------------------------------------


