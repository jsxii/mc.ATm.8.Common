;------------------------------------------------------------
; Init MCU; stack;ram;..
Reset:
; disable Interrupts
	CLI
; Set constants
	CLR	c00		; R10=0; const
	MOV	cFF, c00
	DEC	cFF		; R11=255
; Set stack
	OUTI	SPL, low(RAMEND)
	OUTI	SPH, high(RAMEND)
; Clear SRAM
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
;...

;------------------------------------------------------------
; Init HW
InitHW:
; Init WatchDog
; ...
; Init Ports
	OUT	DDRD, cFF
	;SBI	PORTD, 7
	;------------------------------------------------------------
; Init RTOS
	RCALL	InitRTOS
;------------------------------------------------------------
; Set Backgrounds Tasks...
Background:
	SetTT	TS_OffLed0, 1
	SetTT	TS_OffLed1, 1
	SetTT	TS_OffLed2, 1
	SetTT	TS_OffLed3, 1
	SetTT	TS_OffLed4, 1
	SetTT	TS_OffLed5, 1
	SetTT	TS_OffLed6, 1
	SetTT	TS_OffLed7, 1
;------------------------------------------------------------
; MainLoop next
