;== UART ====================================================
; void InitUART (void) [R16]


;------------------------------------------------------------
InitUART:
LDI 	R16, low(bauddivider)
OUT 	UBRRL,R16
LDI 	R16, high(bauddivider)
OUT 	UBRRH,R16
LDI 	R16,0
OUT 	UCSRA, R16
LDI 	R16, (0<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)|(1<<RXEN)|(1<<TXEN)|(0<<UCSZ2)|(0<<RXB8)|(0<<TXB8)
OUT 	UCSRB, R16
; 8 bits, 1 stop, no parity
LDI 	R16, (1<<URSEL)|(0<<UMSEL)|(0<<UPM1)|(0<<UPM0)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0)|(0<<UCPOL)
OUT 	UCSRC, R16
RET
;------------------------------------------------------------
iUSARTrxc:
CLI
PUSH	R16
IN	R16,SREG
PUSH	R16
PUSH	R17
PUSH	R18
PUSH	ZL
PUSH	ZH
IN	R17,UDR		; read data from uart
RCALL	WrRxBuff	; save data to buff
; --
; m.b. check overflow ?
; --
POP	ZH
POP	ZL
POP	R18
POP	R17
POP	R16
OUT	SREG,R16
POP	R16
RETI
;------------------------------------------------------------
iUSARTudre:
CLI
PUSH	R16
IN	R16,SREG
PUSH	R16
PUSH	R17
PUSH	R18
PUSH	ZL
PUSH	ZH
RCALL	RdTxBuff	; read data from buff
CPI	R18,0x00	; check data validity
BREQ	TxDataOk	; if 'ok' go to send
LDI	R16,1<<RXEN|1<<TXEN|1<<RXCIE|1<<TXCIE|0<<UDRIE ; if not, disalble UDRE
OUT	UCSRB, R16	; -//--//-
RJMP	TxIntExit
TxDataOk:
OUT	UDR,R17		; send data
TxIntExit:
POP	ZH
POP	ZL
POP	R18
POP	R17
POP	R16
OUT	SREG,R16
POP	R16
RETI
;------------------------------------------------------------
