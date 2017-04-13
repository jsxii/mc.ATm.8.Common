;== Initialization ==========================================
CLI
;-- Init stack --
LDI	R16,low(RAMEND)
OUT	SPL,R16
LDI	R16,high(RAMEND)
OUT	SPH,R16
;-- Init variable --
CLR	R16
;-- Status
MOV	STREG,r16
;---
;MOV	TxF,R16
;MOV	TxL,R16
;MOV	RxF,R16
;MOV	RxL,R16
;-- Register
OUT	DDRB,R16
OUT	DDRC,R16
OUT	DDRD,R16
;-- Init constants
MOV	c00,R16
SER	R16
MOV	cFF,R16

OUT	DDRB,R16
;-- Init Buffers --
;RCALL	ClrBuff

;-- Init Queue
RCALL	TaskQueueInit

;-- Init UART --
		;LDI	R16,1
		;OUT	PORTB,R16
;RCALL	InitUART
;-- Init I2C
;RCALL	InitIIC
