;------------------------------------------------------------
.CSEG
.ORG 	0x0000
;------------------------------------------------------------
; Vectors
;+ Reset
	RJMP	Reset	
;- External Interrupt Request 0
	RETI
;- External Interrupt Request 1
	RETI
;+ Timer/Counter2 Compare Match
	RJMP	iT2CM
;- Timer/Counter2 Overflow
	RETI
;- Timer/Counter1 Capture Event
	RETI
;- Timer/Counter1 Compare Match A
	RETI
;- Timer/Counter1 Compare Match B
	RETI
;- Timer/Counter1 Overflow
	RETI
;- Timer/Counter0 Overflow
	RETI
;- Serial Transfer Complete
	RJMP	iSpi
;- USART, Rx Complete
	RETI
;- USART Data Register Empty
	RETI
;- USART, Tx Complete
	RETI
;- ADC Conversion Complete
	RETI
;- EEPROM Ready
	RETI
;- Analog Comparator
	RETI
;- 2-wire Serial Interface
	RETI
;- Store Program Memory Ready
	RETI
; End vectors
;------------------------------------------------------------
; Interrupts Tasks
;------------------------------------------------------------
iT2CM:
	RJMP	TimerService
;------------------------------------------------------------
