;------------------------------------------------------------
;------------------------------------------------------------
.macro	CASE
CPI	R17,@0
BRNE	@2
LDI	R17,@1
RET
.endm
;------------------------------------------------------------
Bin2Hex:
PUSH	R17
ANDI	R17,0x0F
RCALL	bh0
MOV	R18,R17
POP	R17
SWAP	R17
ANDI	R17,0x0F
RCALL	bh0
RET
;------------------------------------------------------------
bh0:	CASE	0,0x30,bh1
bh1:	CASE	1,0x31,bh2
bh2:	CASE	2,0x32,bh3
bh3:	CASE	3,0x33,bh4
bh4:	CASE	4,0x34,bh5
bh5:	CASE	5,0x35,bh6
bh6:	CASE	6,0x36,bh7
bh7:	CASE	7,0x37,bh8
bh8:	CASE	8,0x38,bh9
bh9:	CASE	9,0x39,bhA
bhA:	CASE	10,'A',bhB
bhB:	CASE	11,'B',bhC
bhC:	CASE	12,'C',bhD
bhD:	CASE	13,'D',bhE
bhE:	CASE	14,'E',bhF
bhF:	
LDI	R17,'F'
RET
;------------------------------------------------------------
