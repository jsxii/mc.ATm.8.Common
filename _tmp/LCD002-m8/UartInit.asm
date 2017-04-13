;-------------------------------------------------------------------------------
UartInit:
;-------------------------------------------------------------------------------
.equ 	XTAL = 8000000 	
.equ 	baudrate = 9600  
.equ 	bauddivider = XTAL/(16*baudrate)-1
;-------------------------------------------------------------------------------
LDI 	R16,low(bauddivider)
OUT 	UBRRL,R16
LDI 	R16,high(bauddivider)
OUT 	UBRRH,R16
LDI 	R16,0
OUT 	UCSRA,R16
LDI 	R16,(0<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)|(1<<RXEN)|(1<<TXEN)|(0<<UCSZ2)|(0<<RXB8)|(0<<TXB8)
OUT 	UCSRB, R16
; 8 bits, 1 stop, no parity
LDI 	R16,(1<<URSEL)|(0<<UMSEL)|(0<<UPM1)|(0<<UPM0)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0)|(0<<UCPOL)
OUT 	UCSRC,R16
RET
;-------------------------------------------------------------------------------
