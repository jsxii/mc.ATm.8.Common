;============================================================
.DSEG
WrDataLen:	.byte	1
WrDataPtr:	.byte	1
RdDataLen:	.byte	1
RdDataPtr:	.byte	1
ReadyFlag:	.byte	1	; 0 = ready
WrDataBuff:	.byte	8	; [Data])
RdDataBuff:	.byte	8	; [Data])
;============================================================
InitVar:
	LDI	R16,1
	MOV	R1,R16		; in R1 = 0x01
	DEC	R16
	MOV	R0,R16		; in R0 = 0x00
	DEC	R16
	MOV	R2,R16		; in R2 = 0xFF	
;============================================================
	LDI	R16,21
	LDI	ZL,low(WrDataLen)
	LDI	ZH,high(WrDataLen)
IV2:
	ST	Z+,R0
	DEC	R16
	BRNE	IV2
;============================================================
loop0:
	RCALL	SendData1
	RCALL	ReadyWait
	RCALL	SendReciveData
	RCALL	ReadyWait
	RJMP	loop0
;============================================================
ReadyWait:
	RCALL	Delay
	LDI	ZL,low(ReadyFlag)
	LDI	ZH,high(ReadyFlag)
	LD	R16,Z
	OR	R16,R16
	BRNE	ReadyWait
	RET
;============================================================
SendData1:
	LDI	ZL,low(WrDataLen)
	LDI	ZH,high(WrDataLen)
	LDI	R16,4	; Lenght = SLA+W + 3 byte data
	ST	Z+,R16
	ST	Z,R0	; Pointer = 0

	LDI	ZL,low(WrDataBuff)
	LDI	ZH,high(WrDataBuff)
	LDI	R16, <Address+W>
	ST	Z+,R16
	LDI	R16, <Data0>
	ST	Z+,R16
	LDI	R16, <Data1>
	ST	Z+,R16
	LDI	R16, <Data2>
	ST	Z,R16

	LDI	ZL,low(ReadyFlag)
	LDI	ZH,high(ReadyFlag)
	ST	Z,R1
; Start!
	LDI	R16, 0b10100101	; Set TWIE, TWEN, TWINT, TWSTA
	RET
	
		
;============================================================
NoIntStart:
	LDI	R16, 0b10100101	; Set TWIE, TWEN, TWINT, TWSTA
	RET
;============================================================
int00:	; Bus Error
	RCALL	ErrorBusError
	RCALL	SetRepeatTransaction
	RET
int38:	; Collision
	RCALL	ErrorCollision
	RCALL	SetRepeatTransaction
	RET
;============================================================
int08:	; Start completed
int10:	; RepeatStart completed
	LDI	R16,<SLA+W/SLA+R>
	OUT	TWDR,R16
	LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
	OUT	TWCR,R16
	RET
int18:	; SLA+W=ACK
	LD	R16,<DATA>
	OUT	TWDR,R16
	LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
	OUT	TWCR,R16
	RET
int20:	; SLA+W=NACK
	RCALL	ErrorNoAnswer
	RET
int28:	; SendByte=ACK
SndToo:	RJMP	int18
SndEnd:	LDI	R16, 0b10010101	; Set TWIE, TWEN, TWINT, TWSTO
	OUT	TWCR,R16	; Send Stop
	RCALL	SuccesfulTransmitted
int30:	; SendByte=NACK
	RCALL	ErrorNoAckReceived
	RET
;============================================================
