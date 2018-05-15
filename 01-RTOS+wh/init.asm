;------------------------------------------------------------
; Init MCU; stack;ram;..
Reset:
	CLI			; disable Interrupts
	OUTI	SPL, low(RAMEND)	; Set stack
	OUTI	SPH, high(RAMEND)
	CLR	c00		; Set constants
	MOV	cFF,c00		; R10=0; const
	DEC	cFF		; R11=255
ClearRam:	; Clear SRAM
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
	OUTI	DDRD, 0xFF
	OUTI	PORTD, 0x00
;------------------------------------------------------------
; Init RTOS
	RCALL	InitRTOS
;------------------------------------------------------------
; Set Backgrounds Tasks...
Background:
;	SetTT	TS_OffLed3, 1
;------------------------------------------------------------
; MainLoop next
