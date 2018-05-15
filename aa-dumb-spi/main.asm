.include "m8def.inc"
;------------------------------------------------------------
.CSEG
.ORG 	0x0000
;------------------------------------------------------------
	CLI

	LDI	R16, 0xEF
	OUT	DDRB, R16
	OUT	DDRD, R16


	LDI	R16, low(RAMEND)
	OUT	SPL, R16
	LDI	R16, high(RAMEND)
	OUT	SPH, R16

;- SPI
	LDI	R16, 0xEF
	OUT	DDRB, R16
	LDI	R16, 0x53
	OUT	SPCR, R16

;- Display
	LDI	R16, 12
	LDI	R17, 1
	RCALL	DumpSend
	NOP
	NOP

	LDI	R16, 10
	LDI	R17, 15
	RCALL	DumpSend
	NOP
	NOP

	LDI	R16, 11
	LDI	R17, 7
	RCALL	DumpSend
	NOP
	NOP

	LDI	R16, 9
	LDI	R17, 0
	RCALL	DumpSend
	SBI	PORTD, 0
	NOP
	NOP

	LDI	R16, 1
	LDI	R17, 1
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 3
	LDI	R17, 3
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 5
	LDI	R17, 7
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 7
	LDI	R17, 15
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 2
	LDI	R17, 31
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 4
	LDI	R17, 63
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 6
	LDI	R17, 127
	RCALL	DumpSend
	NOP
	NOP
	LDI	R16, 8
	LDI	R17, 255
	RCALL	DumpSend
	NOP
	NOP





Loop:
	NOP
	RJMP	Loop
;------------------------------------------------------------
DumpSend:
	CBI	PORTD, 0
	NOP
	OUT	SPDR, R16
DS2:
	SBIS	SPSR, SPIF
	RJMP	DS2
	NOP
	OUT	SPDR, R17
DS3:
	SBIS	SPSR, SPIF
	RJMP	DS3
	NOP
	SBI	PORTD, 0
	NOP
	RET
