;------------------------------------------------------------
.DSEG
;------------------------------------------------------------
TaskQueue:	.byte	TaskQueueSize
TaskIndexIn:	.byte	1
TaskIndexOut:	.byte	1
;------------------------------------------------------------
TimersPool:	.byte	TimersPoolSize * 3
null_1:		.byte	1
;-- Ring Buffer 01 ------------------------------------------
Queue01:	.byte	QueueSize01
PtrIn01:	.byte	1
PtrOut01:	.byte	1
;------------------------------------------------------------
char:		.byte	1
