;-- UART init -----------------------------------------------
InitUART:
	OUTI	UBRRL, low(bauddivider)
	OUTI	UBRRH, high(bauddivider)
	OUTI	UCSRA, 0
	OUTI	UCSRB, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)
	OUTI	UCSRC, (1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1)
	RET
; ?
;OUTI 	UCSRB, (0<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)|(1<<RXEN)|(1<<TXEN)|(0<<UCSZ2)|(0<<RXB8)|(0<<TXB8)
; 8 bits, 1 stop, no parity
;OUTI 	UCSRC, (1<<URSEL)|(0<<UMSEL)|(0<<UPM1)|(0<<UPM0)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0)|(0<<UCPOL)
;------------------------------------------------------------
