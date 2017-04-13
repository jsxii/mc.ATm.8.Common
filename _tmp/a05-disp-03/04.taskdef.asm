;------------------------------------------------------------
TaskDefinition:
Task00:	.db	0x00, 0x00, 0x00, 0x00
Task01:	.db	0x01, low(TaskQueueInit), high(TaskQueueInit), 0x00
Task02:	.db	0x02, low(Task02code), high(Task02code), 0x00
Task03:	.db	0x03, low(LEDon), high(LEDon), 0x00
Task04:	.db	0x04, low(LEDoff), high(LEDoff), 0x00
;------------------------------------------------------------
Task02code:
LDI	R17,0x03
IN	R16,PORTB
EOR	R16,R17
OUT	PORTB,R16
;LDI	R17,0x03
;RCALL	SetTask
;LDI	R17,0x02
;RCALL	SetTask
RET
;------------------------------------------------------------
LEDon:
LDS	R16,LEDnum
INC	R16
INC	R16
STS	LEDnum,R16
OUT	PORTB,R16
LDI	R17,0x04
LDI	R18,0x00
LDI	R19,0xE1	; 0xe1 + 0x03 * 0x100 = 1000 dec ~1sec 
LDI	R20,0x03
RCALL	SetTaskOnTimer
RET
;------------------------------------------------------------
LEDoff:
LDI	R16,0
OUT	PORTB,R16
LDI	R17,0x03
LDI	R18,0x00
LDI	R19,0xE1	; 0xe1 + 0x03 * 0x100 = 1000 dec ~1sec 
LDI	R20,0x03
RCALL	SetTaskOnTimer
RET
;------------------------------------------------------------
