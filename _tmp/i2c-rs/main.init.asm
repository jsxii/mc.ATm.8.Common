;== Initialization ==========================================
CLI
;-- Init stack --
LDI	R16,low(RAMEND)
OUT	SPL,R16
LDI	R16,high(RAMEND)
OUT	SPH,R16
;-- Init variable --
LDI	R16,0x00
MOV	WrPtr,R16
MOV	WrLen,R16
MOV	RdPtr,R16
MOV	Rdlen,R16
MOV	SLA,R16
MOV	IICflag,R16
;---
MOV	TxFull,R16
MOV	TxPtrS,R16
MOV	TxPtrE,R16
MOV	RxFull,R16
MOV	RxPtrS,R16
MOV	RxPtrE,R16
;-- Register
OUT	DDRB,R16
OUT	DDRC,R16
OUT	DDRD,R16
RJMP	MainLoop1	; DEBUG !!!!!!
;-- Init Buffers --
LDI	ZL,low(WrBuff)
LDI	ZH,high(WrBuff)
LDI	R17,(WrBuffSize + RdBuffSize)
InitLoop1:
ST	Z+,R16
DEC	R17
BRNE	InitLoop1
;---
LDI	ZL,low(RxBuff)
LDI	ZH,high(RxBuff)
LDI	R17,(RxBuffSize + TxBuffSize)
InitLoop2:
ST	Z+,R16
DEC	R17
BRNE	InitLoop2
;-- Init constants
MOV	const0,R16
LDI	R16,0xFF
MOV	constFF,R16
;-- Init UART --
;RCALL	InitUART
;-- Init IIC --
;RCALL	InitIIC
