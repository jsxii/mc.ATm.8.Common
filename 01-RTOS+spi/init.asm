;------------------------------------------------------------
; Init MCU; stack;ram;..
Reset:
; disable Interrupts
	CLI
; Set stack
	OUTI	SPL, low(RAMEND)
	OUTI	SPH, high(RAMEND)
; check reset
	;RCALL	CheckReset
; Set constants
	CLR	c00		; R10=0; const
	MOV	cFF,c00
	DEC	cFF		; R11=255
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
;-- Init HW --
InitHW:
; Init Ports
	OUTI	DDRD, 0xFF
	OUTI	PORTD, 0x00
; Init SPI
; Init WatchDog
	OUTI	WDTCR, 15	; on, timeout ~2sec
; Init Max
	SBI	CSDDR, CSPIN
	SBI	CSPORT, CSPIN
	RCALL	InitMax
	RCALL	ClearMax
	RCALL	ClearVram
;------------------------------------------------------------
; Init RTOS
	RCALL	InitRTOS
;------------------------------------------------------------
; Set Backgrounds Tasks...
Background:
	SetTT	TS_OffLed3, 1
	SetTT	TS_BSOD, 5000
;------------------------------------------------------------
; MainLoop next
