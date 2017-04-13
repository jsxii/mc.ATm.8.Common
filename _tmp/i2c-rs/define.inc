;== Var define ==============================================
; IIC
.def	WrPtr =		R0
.def	WrLen =		R1
.def	RdPtr =		R2
.def	RdLen =		R3
.def	SLA =		R4
.def	IICflag =	R5
; UART
.def	TxFull =	R6
.def	TxPtrS =	R7
.def	TxPtrE =	R8
.def	RxFull =	R9
.def	RxPtrS =	R10
.def	RxPtrE =	R11
; Const define
.def	const0 =	R14
.def	constFF =	R15
;---
.equ	WrBuffSize =	8
.equ	RdBuffSize =	8
.equ	RxBuffSize =	16
.equ	TxBuffSize =	16
;---
.equ 	XTAL =		8000000 	
;---
.equ 	BaudRate =	9600  
.equ 	BaudDivider =	XTAL/(16*BaudRate)-1
;---
.equ	IICRate =	100000
.equ	IICDivider =	(XTAL/IICRate-16)/2
