;------------------------------------------------------------
InitMax:
	SBI	DDRB, 2
	SBI	DDRB, 3
	SBI	DDRB, 5
	OUTI	SPCR, 0x50
	PUSH	R16
	PUSH	R17
	LDI	R16, 9
	LDI	R17, 0
	RCALL	DumpSend
	LDI	R16, 10
	LDI	R17, 15
	RCALL	DumpSend
	LDI	R16, 11
	LDI	R17, 7
	RCALL	DumpSend
	LDI	R16, 12
	LDI	R17, 1
	RCALL	DumpSend
	POP	R17
	POP	R16
	RET
;------------------------------------------------------------
DumpSend:
	CBI	CSPORT, CSPIN
	NOP
	OUT	SPDR, R16
DS1:
	SBIS	SPSR, SPIF
	RJMP	DS1
	NOP
	OUT	SPDR, R17
DS2:
	SBIS	SPSR, SPIF
	RJMP	DS2
	SBI	CSPORT, CSPIN
	RET
;------------------------------------------------------------
ClearMax:
	PUSH	R16
	PUSH	R17
	LDI	R16, 1
ClearMax2:
	LDI	R17, 0
	RCALL	DumpSend
	INC	R16
	CPI	R16, 9
	BRNE	ClearMax2
	POP	R17
	POP	R16
	RET
;------------------------------------------------------------
ClearVram:
	PUSH	R16
	LDI	R16, 0x0
	STS	Vram, R16
	STS	Vram+1, R16
	STS	Vram+2, R16
	STS	Vram+3, R16
	STS	Vram+4, R16
	STS	Vram+5, R16
	STS	Vram+6, R16
	STS	Vram+7, R16
	POP	R16
	RET
;------------------------------------------------------------
PrintStatus:
	PUSH	R17
	MOV	R17, R16
	LDI	R16, 1
	RCALL	DumpSend
	POP	R17
	RET
;------------------------------------------------------------
