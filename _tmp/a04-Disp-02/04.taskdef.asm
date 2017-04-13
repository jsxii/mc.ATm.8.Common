;------------------------------------------------------------
TaskDefinition:
Task00:	.db	0x00, 0x00, 0x00, 0x00
Task01:	.db	0x01, low(TaskQueueInit), high(TaskQueueInit), 0x00
Task02:	.db	0x02, low(Task02code), high(Task02code), 0x00
Task03:	.db	0x03, low(Delay1M), high(Delay1M), 0x00
;------------------------------------------------------------
Task02code:
LDI	R17,0x03
IN	R16,PORTB
EOR	R16,R17
OUT	PORTB,R16

LDI	R17,0x03
RCALL	SetTask

LDI	R17,0x03
RCALL	SetTask

LDI	R17,0x02
RCALL	SetTask

RET
;------------------------------------------------------------

