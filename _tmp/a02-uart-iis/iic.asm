;== IIC =====================================================
;------------------------------------------------------------
InitIIC:
LDI	R16,0x20
OUT	TWSR,c00
OUT	TWBR,R16
RET
;------------------------------------------------------------
StartIICtransaction:
LDI	R16, 0b10100101	; Set TWIE, TWEN, TWINT, TWSTA
OUT	TWCR,R16
RET
;------------------------------------------------------------
;------------------------------------------------------------
iTWI:
CLI
PUSH	R16
IN	R16,SREG
PUSH	R16
PUSH	R17
PUSH	R18
PUSH	ZL
PUSH	ZH
;------------------------------------------------------------
IN	R16,TWSR
ANDI	R16,0xF8
BREQ	Twint00
CPI	R16,0x20
BREQ	Twint20
CPI	R16,0x30
BREQ	Twint30
CPI	R16,0x38
BREQ	Twint38
RJMP	iTWI2
;============================================================
Twint00:	; Bus error
RCALL	ErrorBusError
;RCALL	SetRepeatTransaction
RJMP	iTWIexit
;------------------------------------------------------------
Twint20:	; SLA + W = NACK
RCALL	ErrorNoAnswer
RCALL	iClrBuff
RJMP	iTWIexit
;------------------------------------------------------------
Twint30:	; Send byte = NACK
RCALL	ErrorNoAckReceived
RCALL	iClrBuff
RJMP	iTWIexit
;------------------------------------------------------------
Twint38:	; Collision on bus
RCALL	ErrorBusCollision
;RCALL	SetRepeatTransaction
RJMP	iTWIexit
;------------------------------------------------------------
iTWI2:
CPI	R16,0x08
BREQ	Twint08
CPI	R16,0x10
BREQ	Twint10
CPI	R16,0x18
BREQ	Twint18
CPI	R16,0x28
BREQ	Twint28
RJMP	iTWI3
;------------------------------------------------------------
Twint08:	; Start sended
Twint10:	; ReStart sended
OR	SLA,c00
BRNE	iTWIsendSLA
LDI	R16, 0b10010101	; Set TWIE, TWEN, TWINT, TWSTO
OUT	TWCR,R16
RCALL	iClrBuff
SBR	STREG,(1<<iTxEnd)	; set flag - Tx ended
RJMP	iTWIexit
iTWIsendSLA:
OUT	TWDR,SLA
LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
OUT	TWCR,R16
RJMP	iTWIexit
;------------------------------------------------------------
Twint18:	; SLA + W = ACK
Twint28:	; Send byte = ACK
RCALL	iRdTxBuff
AND	R18,c00
BRNE	iTWIsendByte
LDI	R16, 0b10010101	; Set TWIE, TWEN, TWINT, TWSTO
OUT	TWCR,R16
SBR	STREG,(1<<iTxEnd)	; set flag - Tx ended
RJMP	iTWIexit
iTWIsendByte:
OUT	TWDR,R17
LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
OUT	TWCR,R16
RJMP	iTWIexit
;------------------------------------------------------------
iTWI3:
CPI	R16,0x40
BREQ	Twint40
CPI	R16,0x48
BREQ	Twint48
CPI	R16,0x50
BREQ	Twint50
CPI	R16,0x58
BREQ	Twint58
;------------------------------------------------------------
iTWIexit:
POP	ZH
POP	ZL
POP	R18
POP	R17
POP	R16
OUT	SREG,R16
POP	R16
RETI
;------------------------------------------------------------
Twint40:	; SLA + R = ACK
OR	iRxLen,c00
BRNE	iTWIreadFirst
LDI	R16, 0b10010101	; Set TWIE, TWEN, TWINT, TWSTO
OUT	TWCR,R16
SBR	STREG,(1<<iRxEnd)	; set flag - Rx ended
RJMP	iTWIexit
iTWIreadFirst:
MOV	R16,iRxLen
CPI	R16,0x01
BREQ	iTWIreadOne
LDI	R16, 0b11000101	; Set TWEA, TWIE, TWEN, TWINT
OUT	TWCR,R16
DEC	iRxLen
RJMP	iTWIexit
iTWIreadOne:
LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
OUT	TWCR,R16
DEC	iRxLen
RJMP	iTWIexit
;------------------------------------------------------------
Twint48:	; SLA + R = NACK
RCALL	ErrorNoAckReceivedRd
RCALL	iClrBuff
RJMP	iTWIexit
;------------------------------------------------------------
Twint50:	; Byte received, send ACK
IN	R17,TWDR
RCALL	iWrRxBuff
MOV	R16,iRxLen
CPI	R16,0x01
BREQ	iTWIreadLast
LDI	R16, 0b11000101	; Set TWEA, TWIE, TWEN, TWINT
OUT	TWCR,R16
DEC	iRxLen
RJMP	iTWIexit
iTWIreadLast:
LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
OUT	TWCR,R16
DEC	iRxLen
RJMP	iTWIexit
;------------------------------------------------------------
Twint58:	; Byte received, send NACK
IN	R17,TWDR
RCALL	iWrRxBuff
SBR	STREG,(1<<iRxEnd)	; set flag - Rx ended
RJMP	iTWIexit
;============================================================
;ClearWrBuff:
;MOV	WrPtr,const0
;MOV	WrLen,const0
;LDI	ZL,low(WrBuff)
;LDI	ZH,high(WrBuff)
;LDI	R17,(WrBuffSize)
;ClearWrBuffLoop:
;ST	Z+,const0
;DEC	R17
;BRNE	ClearWrBuffLoop
;RET
;------------------------------------------------------------
;ClearRdBuff:
;MOV	RdPtr,const0
;MOV	RdLen,const0
;LDI	ZL,low(RdBuff)
;LDI	ZH,high(RdBuff)
;LDI	R17,(RdBuffSize)
;ClearRdBuffLoop:
;ST	Z+,const0
;DEC	R17
;BRNE	ClearRdBuffLoop
;RET
;------------------------------------------------------------
SuccesfulTransmitted:
SBR	STREG,(1<<iTxEnd)
RET
;------------------------------------------------------------
SuccesfulReceived:
SBR	STREG,(1<<iRxEnd)
RET
;------------------------------------------------------------
ErrorNoAckReceived:
;LDI	R16,0x81
;MOV	IICflag,R16
SBR	STREG,(1<<iTxEnd)	; set flag - Tx ended
RET
;------------------------------------------------------------
ErrorNoAckReceivedRd:
;LDI	R16,0x82
;MOV	IICflag,R16
SBR	STREG,(1<<iRxEnd)	; set flag - Rx ended
RET
;------------------------------------------------------------
ErrorNoAnswer:
SBR	STREG,(1<<iTxEnd)	; set flag - Tx ended
SBR	STREG,(1<<iRxEnd)	; set flag - Rx ended
RET
;------------------------------------------------------------
ErrorBusCollision:
SBR	STREG,(1<<iTxEnd)	; set flag - Tx ended
SBR	STREG,(1<<iRxEnd)	; set flag - Rx ended
RET
;------------------------------------------------------------
ErrorBusError:
SBR	STREG,(1<<iTxEnd)	; set flag - Tx ended
SBR	STREG,(1<<iRxEnd)	; set flag - Rx ended
RET
;------------------------------------------------------------
SetRepeatTransaction:
;LDI	R16,0xFF
;MOV	IICflag,R16
RET
;============================================================
