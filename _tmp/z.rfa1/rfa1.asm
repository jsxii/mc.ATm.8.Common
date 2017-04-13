.include	"m128rfa1def.inc"

.cseg
		CLI
;Stack init
		LDI 	R16,Low(RAMEND)
	  	OUT 	SPL,R16
 	  	LDI 	R16,High(RAMEND)
	  	OUT 	SPH,R16
;---
		LDI		R16,255
		OUT		DDRB,R16
		OUT		DDRD,R16
		OUT		DDRE,R16
		OUT		DDRF,R16
		OUT		DDRG,R16
;---
loop:
		LDI		R16,0
		OUT		PORTB,R16
		OUT		PORTD,R16
		OUT		PORTE,R16
		OUT		PORTF,R16
		OUT		PORTG,R16
		RCALL	delay
		LDI		R16,255
		OUT		PORTB,R16
		OUT		PORTD,R16
		OUT		PORTE,R16
		OUT		PORTF,R16
		OUT		PORTG,R16
		RCALL	delay
		rjmp loop
;---
delay:
		LDI		R19, 255
d1:
		LDI		R18, 255
d2:
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		DEC		R18
		BRNE	d2
		DEC		R19
		BRNE	d1
		RET
;---
