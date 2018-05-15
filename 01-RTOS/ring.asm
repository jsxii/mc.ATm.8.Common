;-- Put to buffer 01 ----------------------------------------
PutBuff01:
	LDS	R17, PtrIn01
	LDS	R18, PtrOut01
	INC	R17
	ANDI	R17, QueueSize01-1
	CP	R17, R18
	BRNE	PB01
	MOV	R16, cFF		; queue full !!
	RET
PB01:	LDI	ZL, low(Queue01)
	LDI	ZH, high(Queue01)
	ADD	ZL, R17
	ADC	ZH, c00
	ST	Z, R16	
	STS	PtrIn01, R17
	MOV	R16, c00		; ok
	RET
;-- Get from buffer 01 --------------------------------------
GetBuff01:
	LDS	R16, PtrIn01
	LDS	R17, PtrOut01
	CP	R17, R16
	BRNE	GB01
	MOV	R17, cFF		; Queue empty
	RET	
GB01:	LDI	ZL, low(Queue01)
	LDI	ZH, high(Queue01)
	INC	R17
	ANDI	R17, QueueSize01-1
	ADD	ZL, R17
	ADC	ZH, c00
	LD	R16, Z
	STS	PtrOut01, R17
	MOV	R17, c00		; ok
	RET
;------------------------------------------------------------
