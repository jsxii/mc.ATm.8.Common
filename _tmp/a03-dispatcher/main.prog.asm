;------------------------------------------------------------
LDI	R17,0x02
LDI	R18,0xAA

PUSH	R17
PUSH	R18
RCALL	SetTask
POP	R18
POP	R17

Start:
RJMP	Main
;------------------------------------------------------------
PrintF:
;LPM	R17,Z+
;CP	R17,c00
;BRNE	Prn1
;RET
Prn1:
;PUSH	ZL
;PUSH	ZH
;RCALL	WrTxBuff
;POP	ZH
;POP	ZL
;RJMP	PrintF
;------------------------------------------------------------
Msg1:	.db	"Hello! UART Test Programm welcome to you.",0x0D,0x0A,0
Msg2:	.db	"No command allowed.",0x0D,0x0A,0
MsgS:	.db	"Start I2C",0x0D,0x0A,0
MsgE:	.db	"End I2C",0x0D,0x0A,0
Msgz:	.db	0x0D,0x0A,0x0D,0x0A,0x0D,0x0A,0,0
;------------------------------------------------------------
MainEnd:



