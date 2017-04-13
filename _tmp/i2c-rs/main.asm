.include	"m8def.inc"		; ++
.include	"define.inc"		; ?
.include	"_HEADERS.inc"
;== Program =================================================
.CSEG
;------------------------------------------------------------
.ORG	0x00
;------------------------------------------------------------
.include	"int.vectors.asm"	; +
;------------------------------------------------------------
Init:
.include	"main.init.asm"	; +
;------------------------------------------------------------
Main:
.include	"main.prog.asm"	; ?
;------------------------------------------------------------
Mainloop:
RJMP	Mainloop
;------------------------------------------------------------
.include	"main.uart.asm"	; +
;------------------------------------------------------------
.include	"main.iic.asm"	; -
;------------------------------------------------------------
.include	"int.uart.asm"	; +
;------------------------------------------------------------
.include	"int.iic.asm"	; +
;------------------------------------------------------------
.include	"int.body.asm"	; +
;------------------------------------------------------------
.include	"SRAM.asm"	; +