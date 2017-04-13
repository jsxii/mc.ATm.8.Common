;============================================================

ProgrammInit:
LDI	R16,0xFF
OUT	DDRB,R16

LDI	R17,0x02
RCALL	SetTask

RET
