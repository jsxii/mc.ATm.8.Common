;-- UART init -----------------------------------------------
InitUART:
	OUTI	UBRRL, low(bauddivider)
	OUTI	UBRRH, high(bauddivider)
	OUTI	UCSRA, 0
	OUTI	UCSRB, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)
	OUTI	UCSRC, (1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1)
	RET
;------------------------------------------------------------
