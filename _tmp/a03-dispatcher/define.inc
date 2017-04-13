;== Var define ==============================================
;
;-- Main Clock
.equ 	XTAL =		8000000 	

;-- TaskQueue & TimerQueue
.equ	MaxTaskQueueLen =	6
;------------------------------------------------------------

;-- Const define
.def	c00 =	R0
.def	cFF =	R1

;-- Status Reg Define
.def	STREG = R25
;-- bits
;.equ	RxFull = 0
;.equ	TxFull = 1
;.equ	iRxFull = 2
;.equ	iTxFull = 3
;.equ	iRxEnd = 4
;.equ	iTxEnd = 5
;.equ	res5 =	6
;.equ	res6 =	7

;-- UART buff var
;.def	TxF =	R2
;.def	TxL =	R3
;.def	RxF =	R4
;.def	RxL =	R5

;-- I2C buff var
;.def	iTxF =	R6
;.def	iTxL =	R7
;.def	iRxF =	R8
;.def	iRxL =	R9
;.def	SLA =	R10
;.def	iRxLen = R11
;-- UART buff size
;.equ	RxBuffSize =	64
;.equ	TxBuffSize =	64
;-- I2C buff size
;.equ	iRxBuffSize =	16
;.equ	iTxBuffSize =	16
;-- UART Speed
;.equ 	BaudRate =	9600  
;.equ 	BaudDivider =	XTAL/(16*BaudRate)-1
;-- I2C Speed
;.equ	iBaudRate = ?
;.equ	iBaudDivider = ?
