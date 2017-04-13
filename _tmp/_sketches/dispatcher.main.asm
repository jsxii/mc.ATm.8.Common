;== Dispatcher ==============================================
;------------------------------------------------------------
Main:
RCALL	GetTask
CPI	R17,0
BREQ	MainIdle
RCALL	GetTaskAddress
ICALL
RJMP	Main
MainIdle:
IN	R16,SREG
PUSH	R16
SEI
; set sleep mode
SLEEP
POP	R16
OUT	SREG,R16
RJMP	Main
;------------------------------------------------------------
SetTask:	; R17=TaskId,R18=Param ; void ; ...
;------------------------------------------------------------
LDS	R16,TaskQueueLen
CPI	R16,MaxTaskQueueLen
BRNE	SetTask1
LDI	R17,1		; Task queue full - fail add task
RJMP	BSOD
SetTask1:
INC	R16
STS	TaskQueueLen,R16
LDI	ZL,low(TaskQueue)
LDI	ZH,high(TaskQueue)
LDS	R16,TaskQueueEnd
PUSH	R17
PUSH	R18
MOV	R17,16
CLR	R18
ROL	R17
ROL	R18
ADD	ZL,R17
ADC	ZH,R18
POP	R18
POP	R17
STS	Z+,R17
STS	Z,R18
INC	R16
CPI	R16,MaxTaskQueueLen
BRNE	SetTask2
CLR	R16
SetTask2:
STS	TaskQueueEnd,R16
RET
;------------------------------------------------------------
GetTask:	; void ; R17=taskId,R18=Param ; [ R16,Z ]
;------------------------------------------------------------
LDS	R17,TaskQueueLen
CPI	R17,0x00
BRNE	GetTask1
RET
GetTask1:
DEC	R17
STS	TaskQueueLen,R17
LDI	ZL,low(TaskQueue)
LDI	ZH,high(TaskQueue)
LDS	R16,TaskQueueStart
MOV	R17,16
CLR	R18
ROL	R17
ROL	R18
ADD	ZL,R17
ADC	ZH,R18
LD	R17,Z+
LD	R18,Z
INC	R16
CPI	R16,MaxTaskQueueLen
BRNE	GetTask2
CLR	R16
GetTask2:
STS	TaskQueueStart,R16
RET
;------------------------------------------------------------
GetTasAddress:	; R17=TaskId ; Z=TaskAddress ; [ R16 ]
;------------------------------------------------------------
LDI	ZL,low(TaskDefinition * 2)
LDI	ZH,high(TaskDefinition * 2)
CLR	R16
CLC
ROL	R17
ROL	R16
ROL	R17
ROL	R16
ADD	ZL,R17
ADC	ZH,R16
LPM	R16,Z+
LPM	R17,Z
MOV	ZL,R16
MOV	ZH,R17
RET
;------------------------------------------------------------
TaskQueueInit:	; void ; void ; [ Z ]
;------------------------------------------------------------
CLR	R16
LDI	ZL,low(TaskQueueStart)
LDI	ZH,high(TaskQueueStart)
LDI	R17,MaxTaskQueueLen * 2 + 3
QueueInit1:
LD	Z+,R16
DEC	R17
BRNE	QueueInit1
RET 
;------------------------------------------------------------
BSOD:		; R17=ErrCode ; void ; -
;------------------------------------------------------------
LDI	R16,0xFF
OUT	DDRB,R16
OUT	PORTB,R17
CLI
BSOD1:
SLEEP
RJMP	BSOD1
;------------------------------------------------------------
TaskDefinition:
Task01:	.db	0x01, low(TaskQueueInit), high(TaskQueueInit), 0x00
;------------------------------------------------------------
.def	MaxTaskQueueLen =	16
;------------------------------------------------------------
.DSEG
TaskQueueStart:	.byte	1
TaskQueueEnd:	.byte	1
TaskQueueLen:	.byte	1
TaskQueue:	.byte	MaxTaskQueueLen * 2
