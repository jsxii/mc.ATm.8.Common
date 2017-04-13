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
;-- Initialisation --
Init:
		CLI
		mStackInit	; mac8
;		SEI

; Main =========================================================
		LDI		R16, 255
		OUT		DDRC, R16
		LDI		R16, 4
		OUT		PORTC, R16
;------------------------------------------------------------
; InitReg
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

		LDI		ZH, high(vram)
		LDI		ZL, low(vram)
		LDI		R16,1
		LDI		R17,40
vrams:
		ST		Z, R16
		INC		R16
		ADIW	Z, 1
		DEC		R17
		BRNE	vrams
;------------------------------------------------------------
loop:
		RCALL	sendVram
		RJMP	loop
;------------------------------------------------------------
;------------------------------------------------------------
sendAll:	; R19=addr ;R20=data
		CLI
		LDI		R16,8
		MOV		R14, R16
		LDI		R16, 0
		MOV		R0, R16
		CBI		PORTC, 2
		RCALL	send2
		RCALL	send2
		RCALL	send2
		RCALL	send2
		RCALL	send2
		RCALL	send2
		RCALL	send2
		RCALL	send2
		SBI		PORTC, 2
;		SEI
		RET
;------------------------------------------------------------
send2:
		RCALL	sendWord
		RCALL	sendWord
		RCALL	sendWord
		RCALL	sendWord
		RCALL	sendWord
		RCALL	sendWord
		RCALL	sendWord
		RCALL	sendWord
		RET
;------------------------------------------------------------
sendVram:
		CLI
		LDI		R16,8
		MOV		R14, R16
		LDI		R16, 0
		MOV		R0, R16
		CBI		PORTC, 2
		LDI		R19, 1
		LDI		ZH, high(vram)
		LDI		ZL, low(vram)
		RCALL	send1
		LDI		R19, 2
		LDI		ZH, high(vram+1)
		LDI		ZL, low(vram+1)
		RCALL	send1
		LDI		R19, 3
		LDI		ZH, high(vram+2)
		LDI		ZL, low(vram+2)
		RCALL	send1
		LDI		R19, 4
		LDI		ZH, high(vram+3)
		LDI		ZL, low(vram+3)
		RCALL	send1
		LDI		R19, 5
		LDI		ZH, high(vram+4)
		LDI		ZL, low(vram+4)
		RCALL	send1
		LDI		R19, 6
		LDI		ZH, high(vram+5)
		LDI		ZL, low(vram+5)
		RCALL	send1
		LDI		R19, 7
		LDI		ZH, high(vram+6)
		LDI		ZL, low(vram+6)
		RCALL	send1
		LDI		R19, 8
		LDI		ZH, high(vram+7)
		LDI		ZL, low(vram+7)
		RCALL	send1
		SBI		PORTC, 2
;		SEI
		RET
;------------------------------------------------------------
send1:
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
		ADD		ZL, R14
		ADC		ZH, R0
		LD		R20, Z
		RCALL	sendWord
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
.include	"..\_inc\interrupts8.inc"

.DSEG
vram:
.byte 40
