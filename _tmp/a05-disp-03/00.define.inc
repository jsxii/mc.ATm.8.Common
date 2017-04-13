;== Var define ==============================================
;------------------------------------------------------------
;-- Main Clock
.equ 	XTAL =		8000000 	
.equ 	F_CPU =		XTAL 	
;------------------------------------------------------------
;-- TaskQueue & TimerQueue
.equ	MaxTaskQueueLen =	3
.equ	MaxTimerQueueLen =	3
;------------------------------------------------------------
;-- TaskQueue & TimerQueue Fails
.equ	TaskQueueFull =		1
.equ	TaskAddressFailed =	2 
;------------------------------------------------------------
