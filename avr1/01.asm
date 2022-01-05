;
; AVRA
;
	.include	"m8def.inc"
	.dseg
	.org		0x0000
	CLI
	LDI	R16, low(RAMEND)
	OUT	SPL, R16
	LDI	R16, high(RAMEND)
	OUT	SPH, R16

loop:
	RJMP	loop
