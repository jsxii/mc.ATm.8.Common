.include "m8def.inc"
.equ	RBsize=32

.DSEG
InPnt:	.byte	1
OutPnt:	.byte	1
RBuff:	.byte	RBsize

.CSEG
PutBuff:
	PUSH	R16
	LDI	XL,low(RBuff)
	LDI	XH,high(RBuff)
	LDS	R17,InPnt
	LDS	R16,OutPnt
	INC	R17
	ANDI	R17,RBsize-1
	CP	R17,R16
	BRNE	put2
	POP	R16
	MOV	R16,R1
	RET
put2:	ADD	XL,R17
	ADC	XH,R0
	POP	R16
	ST	X,R16	
	STS	(InPnt),R17
	MOV	R16,R0
	RET
GetBuff:
	LDS	R16,InPnt
	LDS	R17,OutPnt
	CP	R17,R16
	BRNE	get2
	MOV	R17,R1
	RET
get2:	LDI	XL,low(RBuff)
	LDI	XH,high(RBuff)
	INC	R17
	ANDI	R17,RBsize-1
	ADD	XL,R17
	ADC	XH,R0
	LD	R17,X
	STS	(OutPnt),R17
	MOV	R17,R0
	RET
