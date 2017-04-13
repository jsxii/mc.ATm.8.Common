;== Var define ==============================================
;------------------------------------------------------------
;-- Main Clock
.equ 	XTAL =		8000000 	
.equ 	F_CPU =		XTAL 	

;------------------------------------------------------------
;-- TaskQueue & TimerQueue
.equ	MaxTaskQueueLen =	6
.equ	TimerQueueLen =		6

;------------------------------------------------------------
;-- TaskQueue & TimerQueue Fails
.equ	TaskQueueFull =		1
.equ	TaskAddressFailed =	2 
;------------------------------------------------------------
