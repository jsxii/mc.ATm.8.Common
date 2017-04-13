;============================================================
.DSEG
;------------------------------------------------------------
;-- TaskQueue --
TaskQueueStart:	.byte	1
TaskQueueEnd:	.byte	1
TaskQueueLen:	.byte	1
TaskQueue:	.byte	MaxTaskQueueLen * 2
;------------------------------------------------------------
;-- TimerQueue --
TimerQueue:	.byte	TimerQueueLen
;------------------------------------------------------------
