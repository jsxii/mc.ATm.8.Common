;-- Macros --------------------------------------------------
.MACRO	OUTI	; [Port, Value]
	LDI	R16, @1
	OUT	@0, R16
.ENDMACRO
;------------------------------------------------------------
.MACRO	SetTT	; [TaskId, Timer]; Timer = 0..65535
	LDI	XL, low(@1)
	LDI	XH, high(@1)
	LDI	R16, @0
	RCALL	SetTimer
.ENDMACRO
;------------------------------------------------------------

;-- Variables -----------------------------------------------
.equ	MainClock	= 8000000		; CPU Clock
.equ	TaskQueueSize	= 32			; 8/16/32/64 !!
.equ	TimersPoolSize	= 8
.equ	QueueSize01	= 32			; Ring buffer 01 size
.equ	Tmr_Counter =	0x83			; 8MHz
.equ	Tmr_Prescaler =	0x03			; 8MHz
;.equ	XTAL		= MainClock
;.equ	baudrate	= 19200
;.equ	bauddivider	= XTAL / (16 * baudrate) - 1
;------------------------------------------------------------

;-- Defines -------------------------------------------------
; aliases
.def	OSreg	= R16
; constants
.def	c00	= R10
.def	cFF	= R11
;------------------------------------------------------------
