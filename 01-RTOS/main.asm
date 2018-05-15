;------------------------------------------------------------
.include "m8def.inc"
.include "define.asm"
;-- Interrupt vectors ---------------------------------------
.include "vectors.asm"
;-- Tasks ---------------------------------------------------

;-- Initialisation ------------------------------------------
Reset:				; Init MCU
	CLI				; disable Interrupts
	OUTI	SPL, low(RAMEND)	; Set stack
	OUTI	SPH, high(RAMEND)
	CLR	c00			; Set constants
	MOV	cFF, c00		; R10=0; const
	DEC	cFF			; R11=255
ClearRam:				; Clear SRAM
	LDI	ZL, Low(SRAM_START)
	LDI	ZH, High(SRAM_START)
	CLR	R16
ClrRam:	ST	Z+, R16
	CPI	ZH, High(RAMEND)
	BRNE	ClrRam
	CPI	ZL, Low(RAMEND)
	BRNE	ClrRam
	CLR	ZL
	CLR	ZH
;-- Init HW ----------------------------------------------------------
InitHW:
;	OUTI	WDTCR, 0x0F		; Init WatchDog
	OUT	DDRD, cFF		; Init Port D
	SBI	DDRB, 0			; Init Port B-0
	SBI	DDRB, 1			; Init Port B-1
;	RCALL	InitUART		; Init UART
	RCALL	LCDInit
	LDI	R16, 0x78
	STS	char, R16
;-- Init RTOS --------------------------------------------------------
	RCALL	InitRTOS		; Init RTOS

;-- Set Backgrounds Tasks --------------------------------------------
Background:
	SetTT	TS_OffLed0, 1

;-- Main cycle ----------------------------------------------
MainLoop:
	SEI
;	WDR				; Reset watchdog
	RCALL	ProcessTaskQueue	; Task queue processing
	RCALL 	Idle			; Idle task
	RJMP 	MainLoop		; Repeat..

;-- RTOS kernel ---------------------------------------------
.include "kernel-t0.asm"

;-- Task index + aliases ------------------------------------
.include "tasktable.asm"
;-- Libraries -----------------------------------------------
.include "LCD1602-8bit.asm"

;-- .CSEG end -----------------------------------------------
;-- SRAM; buffers, vars, etc --------------------------------
.include "memory.asm"
