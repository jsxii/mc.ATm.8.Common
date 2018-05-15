;------------------------------------------------------------
; Init MCU; stack;ram;..
Reset:
; disable Interrupts
	CLI
; Set constants
	CLR	R9
	CLR	c00		; R10=0; const
	LDI	R16, 0xAA	; R11=255
	MOV	R11, R16
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
; Init Ports
	OUTI	DDRD, 0xFF
	OUTI	PORTD, 0x00
; SPI
	SBI	CSDDR, CSPIN
	SBI	CSPORT, CSPIN
	SBI	DDRB, 2
	SBI	DDRB, 3
	SBI	DDRB, 5
	OUTI	SPCR, 0x52
	SBI	SPCR, 4
	NOP
	IN	R16, SPCR
	OUT	PORTD, R16

;	BreakPoint
	...
; Init WatchDog
; ...
;------------------------------------------------------------
	RCALL	InitMax
;------------------------------------------------------------
; Init RTOS
	RCALL	InitRTOS
;------------------------------------------------------------
; Set Backgrounds Tasks...
Background:
	;SetTT	TS_OffLed0, 1
	;SetTT	TS_OffLed1, 1
	;SetTT	TS_OffLed2, 1
	SetTT	TS_OffLed3, 1
	;SetTT	TS_OffLed4, 1
	;SetTT	TS_OffLed5, 1
	;SetTT	TS_OffLed6, 1
	;SetTT	TS_OffLed7, 1
;------------------------------------------------------------
; MainLoop next
