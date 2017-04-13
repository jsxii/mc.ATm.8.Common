;== Dispatcher ==============================================
;------------------------------------------------------------
MainCycle:
RCALL	GetTask
CPI	R17,0
BREQ	MainIdle
RCALL	GetTaskAddress
ICALL
RJMP	MainCycle
MainIdle:
IN	R16,SREG
PUSH	R16
LDI	R16,0x80
OUT	MCUCR,R16
SEI
; set sleep mode
SLEEP
POP	R16
OUT	SREG,R16
RJMP	MainCycle
;------------------------------------------------------------
SetTask:	; R17=TaskId,R18=Param ; void ; ...
;------------------------------------------------------------
LDS	R16,TaskQueueLen
CPI	R16,MaxTaskQueueLen
BRNE	SetTask1
LDI	R17,TaskQueueFull
RJMP	BSOD
SetTask1:
INC	R16
STS	TaskQueueLen,R16
LDI	ZL,low(TaskQueue)
LDI	ZH,high(TaskQueue)
LDS	R16,TaskQueueEnd
PUSH	R17
PUSH	R18
MOV	R17,R16
CLR	R18
CLC
ROL	R17
ROL	R18
ADD	ZL,R17
ADC	ZH,R18
POP	R18
POP	R17
ST	Z+,R17
ST	Z,R18
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
MOV	R17,R16
CLC
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
GetTaskAddress:	; R17=TaskId ; Z=TaskAddress ; [ R16 ]
;------------------------------------------------------------
LDI	ZL,low(TaskDefinition * 2)
LDI	ZH,high(TaskDefinition * 2)
PUSH	R17
CLR	R16
CLC
ROL	R17
ROL	R16
ROL	R17
ROL	R16
ADD	ZL,R17
ADC	ZH,R16
LPM	R16,Z+
POP	R17
CP	R16,R17
BRNE	GetTaskAddressExc
LPM	R16,Z+
LPM	R17,Z
MOV	ZL,R16
MOV	ZH,R17
RET
GetTaskAddressExc:
LDI	R17,TaskAddressFailed
RJMP	BSOD
;------------------------------------------------------------
TaskQueueInit:	; void ; void ; [ Z ]
;------------------------------------------------------------
CLR	R16
LDI	ZL,low(TaskQueueStart)
LDI	ZH,high(TaskQueueStart)
LDI	R17,MaxTaskQueueLen * 2 + 3
QueueInit1:
ST	Z+,R16
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

