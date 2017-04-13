;============================================================
.DSEG
;RxBuff:	.byte	RxBuffSize
;TxBuff:	.byte	TxBuffSize
;iRxBuff:	.byte	iRxBuffSize
;iTxBuff:	.byte	iTxBuffSize
;-- TaskQueue --
TaskQueueStart:	.byte	1
TaskQueueEnd:	.byte	1
TaskQueueLen:	.byte	1
TaskQueue:	.byte	MaxTaskQueueLen * 2
