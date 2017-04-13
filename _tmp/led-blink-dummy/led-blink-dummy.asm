.include	"m8def.inc"
CLI
;-- Init stack --
LDI	R16,low(RAMEND)
OUT	SPL,R16
LDI	R16,high(RAMEND)
OUT	SPH,R16
LDI	R16,255
;-- Register
OUT	DDRB,R16
OUT	DDRC,R16
OUT	DDRD,R16
MainLoop1:

RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
LDI	R16,255
OUT	PORTD,R16
RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
LDI	R16,0
OUT	PORTD,R16
RJMP	MainLoop1

MainDelay1:
LDI	R16,160
MainDelay1Loop1:
LDI	R17,250
MainDelay1Loop2:
NOP
DEC	R17
BRNE	MainDelay1Loop2
DEC	R16
BRNE	MainDelay1Loop1
RET
