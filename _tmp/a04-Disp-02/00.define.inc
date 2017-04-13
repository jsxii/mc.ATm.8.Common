;== Var define ==============================================
;------------------------------------------------------------
;-- Main Clock
.equ 	XTAL =		8000000 	
.equ 	F_CPU =		XTAL 	

;------------------------------------------------------------
;-- TaskQueue & TimerQueue
.equ	MaxTaskQueueLen =	16
.equ	TimerQueueLen =		16

;------------------------------------------------------------
;-- TaskQueue & TimerQueue Fails
.equ	TaskQueueFull =		1
.equ	TaskAddressFailed =	2 
;------------------------------------------------------------
