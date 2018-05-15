;-- Include Defines and Macros ------------------------------
.include "m8def.inc"
.include "define.asm"
;-- Interrupt vectors and interrupts tasks ------------------
.include "vectors.asm"
;-- Initialisation ------------------------------------------
Reset:
	CLI				; disable Interrupts
	OUTI	SPL, low(RAMEND)	; Set stack
	OUTI	SPH, high(RAMEND)
	CLR	c00			; Set constants
	MOV	cFF,c00			; R10 = 0
	DEC	cFF			; R11 = 0xFF
ClearRam:
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
InitHW:
;	OUTI	DDRD, 0xFF
;	OUTI	PORTD, 0x00
;------------------------------------------------------------
	RCALL	InitRTOS	; Init RTOS
;-- Set Backgrounds Tasks -----------------------------------
Background:
;	SetTT	TS_OffLed3, 1
;-- Main cycle ----------------------------------------------
MainLoop:
	SEI			; too safe
	WDR			; Reset watchdog
	RCALL	ProcessTaskQueue	; Task queue processing
	RCALL 	Idle		; Idle task
	RJMP 	MainLoop	; Repeat..
;------------------------------------------------------------
;-- RTOS kernel ---------------------------------------------
.include "kernel.asm"
;-- Task index + aliases ------------------------------------
.include "tasktable.asm"
;-- Tasks ---------------------------------------------------
; ...
;------------------------------------------------------------
;.CSEG end
;-- SRAM; buffers, vars, etc --------------------------------
; 
.include "memory.asm"
;------------------------------------------------------------
