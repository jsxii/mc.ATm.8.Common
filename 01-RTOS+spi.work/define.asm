;------------------------------------------------------------
; Macros
;------------------------------------------------------------
.MACRO	OUTI
	LDI	R16, @1
	OUT	@0, R16
.ENDMACRO
;------------------------------------------------------------
.MACRO	SetTT
	LDI	XL, low(@1)
	LDI	XH, high(@1)
	LDI	R16, @0
	RCALL	SetTimer
.ENDMACRO
;------------------------------------------------------------
.MACRO	IncPortD
	PUSH	R16
	IN	R16, PORTD
	INC	R16
	OUT	PORTD, R16
	POP	R16
.ENDMACRO
;------------------------------------------------------------
.MACRO	BreakPoint
	CLI
BreakPointLoop:
	RJMP	BreakPointLoop
.ENDMACRO
;------------------------------------------------------------
; Variables
;------------------------------------------------------------
.equ	TaskQueueSize	= 32			; 8/16/32/64 !!
.equ	TimersPoolSize	= 8
.equ	MainClock	= 8000000		; CPU Clock
.equ	TimerDivider	= MainClock/64/1000 	; 1 mS
;.equ	XTAL		= MainClock
;.equ	baudrate	= 19200
;.equ	bauddivider	= XTAL / (16 * baudrate) - 1



;------------------------------------------------------------
; Defines
;------------------------------------------------------------
; aliases
.def	OSreg	= R16
; constants
.def	c00	= R10
.def	cFF	= R11
; hw - spi
.equ	CSPIN	= 0
.equ	CSPORT	= PORTB
.equ	CSDDR	= DDRB

