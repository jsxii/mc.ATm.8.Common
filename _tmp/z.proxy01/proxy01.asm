.include "tn45def.inc"

CLI
LDI		R16,low(RAMEND)
OUT		SPL,R16
LDI		R16,high(RAMEND)
OUT		SPH,R16

LDI		R16,31
LDI		R17,0
OUT		DDRB,R16

loop:
LDI		R16,21
OUT		PORTB,R16
;LDI		R18,16
;RCALL	loop1
RCALL	delay
RCALL	delay


LDI		R16,10
OUT		PORTB,R16
RCALL	delay
RCALL	delay


LDI		R16,31
OUT		PORTB,R16
RCALL	delay
RCALL	delay
RCALL	delay
RCALL	delay
RCALL	delay
RCALL	delay
RCALL	delay
RCALL	delay
RJMP	loop

delay:
LDI		R18,255
loop1:
LDI		R19,255
loop2:
NOP
NOP
DEC		R19
BRNE	loop2
DEC		R18
BRNE	loop1
RET
