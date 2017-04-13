;-- IIC -----------------------------------------------------
InitIIC:
LDI	R16,0x20
OUT	TWSR,const0
OUT	TWBR,R16
RET
;------------------------------------------------------------
StartIICtransaction:
LDI	R16, 0b10100101	; Set TWIE, TWEN, TWINT, TWSTA
OUT	TWCR,R16
RET
;------------------------------------------------------------
