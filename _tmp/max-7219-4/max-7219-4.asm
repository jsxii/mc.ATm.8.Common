;============================================================
.include 	"m8def.inc"
;------------------------------------------------------------
.include	"..\_inc\_macro8.inc"
;------------------------------------------------------------
;============================================================
		.CSEG
		.ORG		0x0000
;------------------------------------------------------------
;-- Vectors --
.include	"..\_inc\vectors8.inc"
;------------------------------------------------------------
.include	"..\_inc\interrupts8.inc"
;------------------------------------------------------------
;-- Initialisation --
Init:
		CLI
		mStackInit	; mac8

;-- Timer Init --

;-- Port Init --
		LDI		R16, 255
		OUT		DDRC, R16
		OUT		DDRB, R16
		OUT		PORTB, R16
		LDI		R16, 0
		OUT		PORTC, R16
		LDI		R16,1
		MOV		R15,R16
;-- LED Init --
		RCALL	InitLED
;		SEI

;== Main =========================================================
loop:
;------------------------------------------------------------
		RJMP	loop

;=================================================================
sendAll:
		RCALL	send0
		RCALL	send1
		RCALL	send2
		RCALL	send3
		RCALL	send4
		RET
;------------------------------------------------------------
send0:
		CBI		PORTB, 0
		NOP
		NOP
		RCALL	sendWord
		NOP
		NOP
		SBI		PORTB, 0
		RET
;------------------------------------------------------------
send1:
		CBI		PORTB, 1
		NOP
		NOP
		RCALL	sendWord
		NOP
		NOP
		SBI		PORTB, 1
		RET
;------------------------------------------------------------
send2:
		CBI		PORTB, 2
		NOP
		NOP
		RCALL	sendWord
		NOP
		NOP
		SBI		PORTB, 2
		RET
;------------------------------------------------------------
send3:
		CBI		PORTB, 3
		NOP
		NOP
		RCALL	sendWord
		NOP
		NOP
		SBI		PORTB, 3
		RET
;------------------------------------------------------------
send4:
		CBI		PORTB, 4
		NOP
		NOP
		RCALL	sendWord
		NOP
		NOP
		SBI		PORTB, 4
		RET
;------------------------------------------------------------
sendWord:		; R19=addr; R20=data
		MOV		R16, R19
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		MOV		R16, R20
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		RCALL	oneBit
		NOP
		NOP
		NOP
		NOP
		NOP
		CBI		PORTC, 1
		RET
;------------------------------------------------------------
oneBit:
		;RCALL				; 3
		ROL		R16			; 1
		ROL		R17			; 1
		CBI		PORTC,1		; x
		AND		R17,R15		; 1
		OUT		PORTC,R17	; 1
		NOP					; 1 1
		NOP					; 1 2
		NOP					; 1 3
		NOP					; 1 4
		NOP					; 1 5
		NOP					; 1 6
		NOP					; 1 7
		SBI		PORTC,1		; x
		RET					; 4
;------------------------------------------------------------
wait:
		RCALL	wait0
		LDI		R16,128
		RJMP	w1
wait0:
		LDI		R16,255
w1:
		LDI		R17,255
w2:
		NOP
		NOP
		NOP
		NOP
		DEC		R17
		BRNE	w2
		DEC		R16
		BRNE	w1
		RET
;------------------------------------------------------------
InitLED:
		LDI		R19, 9
		LDI		R20, 0
		RCALL	sendAll
		LDI		R19, 10
		LDI		R20, 7
		RCALL	sendAll
		LDI		R19, 11
		RCALL	sendAll
		LDI		R19, 12
		LDI		R20, 15
		RCALL	sendAll
		RET
;------------------------------------------------------------
coutAll:
		LDI		R19, 1
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 2
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 3
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 4
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 5
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 6
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 7
		LPM		R20,Z+
		RCALL	sendAll
		LDI		R19, 8
		LPM		R20,Z+
		RCALL	sendAll
		RET
;------------------------------------------------------------
chargen:






;============================================================
.DSEG
offset:	.byte	1
vram:	.byte	64

