;== Var define ==============================================
;
;-- Main Clock
.equ 	XTAL =		8000000 	

;-- Const define
.def	c00 =	R0
.def	cFF =	R1

;-- Status Reg Define
.def	STREG = R25
;-- bits
.equ	RxFull = 0
.equ	TxFull = 1
.equ	res1 =	2
.equ	res2 =	3
.equ	res3 =	4
.equ	res4 =	5
.equ	res5 =	6
.equ	res6 =	7

;-- UART buff var
.def	TxF =	R2
.def	TxL =	R3
.def	RxF =	R4
.def	RxL =	R5
;-- UART buff size
.equ	RxBuffSize =	64
.equ	TxBuffSize =	64
;-- UART Speed
.equ 	BaudRate =	9600  
.equ 	BaudDivider =	XTAL/(16*BaudRate)-1



