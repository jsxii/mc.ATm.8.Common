.include "m8def.inc"
;------------------------------------------------------------
.equ	TQ_Counter =	0x83	; 8MHz
.equ	TQ_Prescaler =	0x03
.equ	SpiQueueSize = 	32
;------------------------------------------------------------
.CSEG
.ORG 	0x0000
;------------------------------------------------------------
; Vectors
;- Reset
	RJMP	Reset	; Reset, POR, BOR, WDR
	RETI		; External Interrupt Request 0
	RETI		; External Interrupt Request 1
	RETI		; Timer2 Compare Match
	RETI		; Timer2 Overflow
	RETI		; Timer1 Capture Event
	RETI		; Timer1 Compare Match A
	RETI		; Timer1 Compare Match B
	RETI		; Timer1 Overflow
	RJMP	iTimer	; Timer0 Overflow
;	RJMP	iSPI	; Serial Transfer Complete
	RETI
	RETI		; USART, Rx Complete
	RETI		; USART Data Register Empty
	RETI		; USART, Tx Complete
	RETI		; ADC Conversion Complete
	RETI		; EEPROM Ready
	RETI		; Analog Comparator
	RETI		; 2-wire Serial Interface
	RETI		; Store Program Memory Ready
;End vectors
;------------------------------------------------------------
; Interrupts Tasks
;------------------------------------------------------------
iSPI:
	PUSH	R16
	IN	R16, SREG
	PUSH	R16
	PUSH	R17
	PUSH	R18
	PUSH	R19
	PUSH	ZL
	PUSH	ZH
	RCALL	SpiGetBuff
	OR	R17, R0
	BRNE	iSpiEmpty
	OUT	SPDR, R16
	RJMP	iSpiExit
iSpiEmpty:
	CBI	SPCR, 7
	CBI	SPCR, 6	; spi & int disable
	SBI	PORTD, 0
	LDS	R16, Index
	INC	R16
	ANDI	R16, 7
	STS	Index, R16
	ADD	ZL, R16
	ADC	ZH, R0
	LD	R19, Z
	LDI	R16, 1
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 2
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 3
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 4
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 5
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 6
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 7
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
	LDI	R16, 8
	RCALL	SpiPutBuff
	MOV	R16, R19
	RCALL	SpiPutBuff
iSpiExit:
	POP	ZH
	POP	ZL
	POP	R19
	POP	R18
	POP	R17
	POP	R16
	OUT	SREG, R16
	POP	R16
	RETI
;------------------------------------------------------------
iTimer:
	PUSH	R16
	IN	R16, SREG
	PUSH	R16
	LDI	R16, TQ_Counter
	OUT	TCNT0, R16
	IN	R16, TIMSK
	ORI	R16, 0x01
	OUT	TIMSK, R16
	PUSH	R17
	PUSH	R18
	PUSH	ZL
	PUSH	ZH
;------------------------------------------------------------
	LDS	R16, Counter1
	DEC	R16
	BREQ	iTmr2
	STS	Counter1, R16
	RJMP	iTmrExit	
iTmr2:
	LDI	R16, 250
	STS	Counter1, R16
	LDS	R16, Counter2
	DEC	R16
	BREQ	iTmr3
	STS	Counter2, R16
	RJMP	iTmrExit	
iTmr3:
	IN	R16, PORTD
	EOR	R16, R2
	OUT	PORTD, R16

	LDI	R16, 4
	STS	Counter2, R16

;	RCALL	SpiGetBuff
;	CBI	PORTD, 0
;	OUT	SPDR, R16
;	SBI	SPCR, 7
;	SBI	SPCR, 6	; spi & int enable
;------------------------------------------------------------
iTmrExit:
	POP	ZH
	POP	ZL
	POP	R18
	POP	R17
	POP	R16
	OUT	SREG, R16
	POP	R16
	RETI
;------------------------------------------------------------
Reset:
	CLI

	LDI	R16, 255
	OUT	DDRD, R16
	LDI	R16, 3
	OUT	PORTD, R16


	LDI	R16, low(RAMEND)
	OUT	SPL, R16
	LDI	R16, high(RAMEND)
	OUT	SPH, R16
;- const
	CLR	R16
	STS	SpiIn, R16
	STS	SpiOut, R16
	MOV	R0, R16
	LDI	R16,128
	MOV	R2, R16
	LDI	R16, 255
	MOV	R1, R16
;- timer0
	LDI	R16, TQ_Prescaler
	OUT	TCCR0, R16
	LDI	R16, TQ_Counter
	OUT	TCNT0, R16
	IN	R16, TIMSK
	ORI	R16, 0x01
	OUT	TIMSK, R16
;- counter
	LDI	R16, 250
	STS	Counter1, R16
	LDI	R16, 4
	STS	Counter2, R16
	LDI	R16, 255
	STS	Index, R16
	LDI	R16, 0x01
	STS	Queue, R16	
	LDI	R16, 0x03
	STS	Queue+1, R16	
	LDI	R16, 0x07
	STS	Queue+2, R16	
	LDI	R16, 0x0F
	STS	Queue+3, R16	
	LDI	R16, 0x1F
	STS	Queue+4, R16	
	LDI	R16, 0x3F
	STS	Queue+5, R16	
	LDI	R16, 0x7F
	STS	Queue+6, R16	
	LDI	R16, 0xFF
	STS	Queue+7, R16	
;-
	SBI	PORTD, 2

;	LDS	R16, Index
;	INC	R16
;	ANDI	R16, 7
;	STS	Index, R16
;	ADD	ZL, R16
;	ADC	ZH, R0
;	LD	R19, Z
;	LDI	R16, 1
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 2
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 3
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 4
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 5
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 6
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 7
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;	LDI	R16, 8
;	RCALL	SpiPutBuff
;	MOV	R16, R19
;	RCALL	SpiPutBuff
;- SPI
	LDI	R16, 0xEF
	OUT	DDRB, R16
	LDI	R16, 0xD2
	OUT	SPCR, R16
;- Display
	SBI	PORTD, 3

	CBI	PORTD, 0
	NOP
	LDI	R16, 9
	RCALL	DumpSend
	LDI	R16, 0
	RCALL	DumpSend
	SBI	PORTD, 0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CBI	PORTD, 0
	NOP
	LDI	R16, 10
	RCALL	DumpSend
	LDI	R16, 15
	RCALL	DumpSend
	SBI	PORTD, 0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CBI	PORTD, 0
	NOP
	LDI	R16, 11
	RCALL	DumpSend
	LDI	R16, 7
	RCALL	DumpSend
	SBI	PORTD, 0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CBI	PORTD, 0
	NOP
	LDI	R16, 12
	RCALL	DumpSend
	LDI	R16, 1
	RCALL	DumpSend
	SBI	PORTD, 0
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	CBI	PORTD, 0
	NOP
	LDI	R16, 3
	RCALL	DumpSend
	LDI	R16, 255
	RCALL	DumpSend
	SBI	PORTD, 0

	SBI	PORTD, 4

	SEI
Loop:
	NOP
	RJMP	Loop
;------------------------------------------------------------
DumpSend:
	OUT	SPDR, R16
DS2:
	SBIS	SPSR, SPIF
	RJMP	DS2
	RET
;------------------------------------------------------------
SpiPutBuff:
	LDS	R17, SpiIn
	LDS	R18, SpiOut
	INC	R17
	ANDI	R17, SpiQueueSize-1
	CP	R17, R18
	BRNE	SB2
	MOV	R16, R1	; queue full !!
	RET
SB2:
	LDI	ZL, low(SpiQueue)
	LDI	ZH, high(SpiQueue)
	ADD	ZL, R17
	ADC	ZH, R0
	ST	Z, R16	
	STS	(SpiIn), R17
	MOV	R16, R0
	RET
;------------------------------------------------------------
SpiGetBuff:
	LDS	R16, SpiIn
	LDS	R17, SpiOut
	CP	R17, R16
	BRNE	SB4
	MOV	R17, R1	; Queue empty
	RET	
SB4:
	LDI	ZL, low(SpiQueue)
	LDI	ZH, high(SpiQueue)
	INC	R17
	ANDI	R17, SpiQueueSize-1
	ADD	ZL, R17
	ADC	ZH, R0
	LD	R16, Z
	STS	(SpiOut), R17
	MOV	R17, R0
	RET
;------------------------------------------------------------
.DSEG
Counter1:	.byte	1
Counter2:	.byte	1
Index:		.byte	1
Queue:		.byte	8
SpiIn:		.byte	1
SpiOut:		.byte	1
SpiQueue:	.byte	SpiQueueSize
