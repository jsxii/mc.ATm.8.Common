;------------------------------------------------------------

;-- enable rx int
LDI 	R16,(1<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)|(1<<RXEN)|(1<<TXEN)
OUT 	UCSRB, R16
SEI
;-- wait first receiving
Mainloop1:
RCALL	Delay10K
CP	RxF,RxL
BREQ	Mainloop1

LDI	R16,3
OUT	PORTB,R16
;--
RCALL	RdRxBuff
LDI	R17,0x0D
RCALL	WrTxBuff
LDI	R17,0x0A
RCALL	WrTxBuff

LDI	ZH,high(Msg1 * 2)
LDI	ZL,low(Msg1 * 2)
RCALL	PrintF

LDI 	R16,(1<<RXCIE)|(0<<TXCIE)|(1<<UDRIE)|(1<<RXEN)|(1<<TXEN)
OUT 	UCSRB, R16

LDI	R24,3

Mainloop2:
MOV	RxF,c00
MOV	RxL,c00
RCALL	Delay100K
OUT	PORTB,R24
CP	RxF,RxL
BREQ	Mainloop2

LDI	ZH,high(Msg2 * 2)
LDI	ZL,low(Msg2 * 2)
RCALL	PrintF

LDI 	R16,(1<<RXCIE)|(0<<TXCIE)|(1<<UDRIE)|(1<<RXEN)|(1<<TXEN)
OUT 	UCSRB, R16
INC	R24
RJMP	Mainloop2

;------------------------------------------------------------
PrintF:
LPM	R17,Z+
CP	R17,c00
BRNE	Prn1
RET
Prn1:
PUSH	ZL
PUSH	ZH
RCALL	WrTxBuff
POP	ZH
POP	ZL
RJMP	PrintF
;------------------------------------------------------------
Msg1:	.db	"Hello! UART Test Programm welcome to you.",0x0D,0x0A,0
Msg2:	.db	"No command allowed.",0x0D,0x0A,0
;------------------------------------------------------------
MainEnd:



