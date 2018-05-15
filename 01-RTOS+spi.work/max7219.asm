;------------------------------------------------------------
InitMax:
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
	RCALL	ClearMax
	RCALL	ClearVram
	LDI	R16, 3
	LDI	R17, 255
	RCALL	DumpSend
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
	LDI	R16, 1
ClearMax2:
	LDI	R17, 0
	RCALL	DumpSend
	INC	R16
	CPI	R16, 9
	BRNE	ClearMax2
	RET
;------------------------------------------------------------
ClearVram:
	LDI	R16, 31
	STS	Vram, R16
	LDI	R16, 0
	STS	Vram+1, R16
	LDI	R16, 0
	STS	Vram+2, R16
	LDI	R16, 0
	STS	Vram+3, R16
	LDI	R16, 0
	STS	Vram+4, R16
	LDI	R16, 0
	STS	Vram+5, R16
	LDI	R16, 0
	STS	Vram+6, R16
	LDI	R16, 0
	STS	Vram+7, R16
	RET
;------------------------------------------------------------
