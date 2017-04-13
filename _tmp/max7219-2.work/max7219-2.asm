;============================================================
.include 	"m8def.inc"
;------------------------------------------------------------
.include	"..\_inc\_macro8.inc"
;------------------------------------------------------------
.MACRO mSendBit
		MOV	R16, @0	;(R18,R19,R16)
		ROL	R16	; 7->C, 6->7...C->0
		ROL	R17	; C->0
		CBI	PORTC, 1	;CLK
		AND	R17, R15	;R15 = 0x01
		OUT	PORTC, R17
		NOP
		NOP
		SBI	PORTC, 1	;CLK
		NOP
.ENDM		
.MACRO mSend2
		LDI		R18, @0
		LDI		R19, @1
		LDI		R20, @0
		LDI		R21, @1
		RCALL	send2
		NOP
		NOP
.ENDM
.MACRO mSend
		LDI		R18, @0
		LDI		R19, @1
		LDI		R20, @2
		LDI		R21, @3
		RCALL	send2
		NOP
		NOP
.ENDM
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
; InitReg
		mSend2	9, 0
		mSend2	10, 7
		mSend2	11, 7
		mSend2	12, 15
; ----
loop:
		RCALL	messg

		RJMP	loop
;------------------------------------------------------------
;------------------------------------------------------------
send:	
		CLI
		CBI		PORTC, 2
		NOP
		LDI		R16,1
		MOV		R15,R16
		mSendBit	R18
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16

		mSendBit	R19
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		NOP
		NOP
		NOP
		CBI		PORTC, 1
		NOP
		NOP
		NOP
		NOP
		SBI		PORTC, 2
;		SEI
		RET
;------------------------------------------------------------
send2:	
		CLI
		CBI		PORTC, 2
		NOP
		LDI		R16,1
		MOV		R15,R16
		mSendBit	R18
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16

		mSendBit	R19
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16

		mSendBit	R20
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16

		mSendBit	R21
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		mSendBit	R16
		NOP
		NOP
		NOP
		CBI		PORTC, 1
		NOP
		NOP
		NOP
		NOP
		SBI		PORTC, 2
;		SEI
		RET
;------------------------------------------------------------
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

messg:
;1 _v
		mSend	1,0,1,0x00
		mSend	2,0,2,0x66
		mSend	3,0,3,0xFF
		mSend	4,0,4,0xFF
		mSend	5,0,5,0x7E
		mSend	6,0,6,0x3C
		mSend	7,0,7,0x18
		mSend	8,0,8,0x00
		RCALL	wait
;2 v_
		mSend	1,0x00,1,0
		mSend	2,0x66,2,0
		mSend	3,0xFF,3,0
		mSend	4,0xFF,4,0
		mSend	5,0x7E,5,0
		mSend	6,0x3C,6,0
		mSend	7,0x18,7,0
		mSend	8,0x00,8,0
		RCALL	wait
;3 _3
		mSend	1,0,1,0x00
		mSend	2,0,2,0x3C
		mSend	3,0,3,0x02
		mSend	4,0,4,0x1C
		mSend	5,0,5,0x02
		mSend	6,0,6,0x02
		mSend	7,0,7,0x7C
		mSend	8,0,8,0x00
		RCALL	wait
;4 3a
		mSend	1,0x00,1,0x00
		mSend	2,0x3C,2,0x3C
		mSend	3,0x02,3,0x42
		mSend	4,0x1C,4,0x42
		mSend	5,0x02,5,0x7E
		mSend	6,0x02,6,0x42
		mSend	7,0x7C,7,0x42
		mSend	8,0x00,8,0x00
		RCALL	wait
;5 au
		mSend	1,0x00,1,0x18
		mSend	2,0x3C,2,0x52
		mSend	3,0x42,3,0x46
		mSend	4,0x42,4,0x4A
		mSend	5,0x7E,5,0x52
		mSend	6,0x42,6,0x62
		mSend	7,0x42,7,0x42
		mSend	8,0x00,8,0x00
		RCALL	wait
;6 u4
		mSend	1,0x18,1,0x00
		mSend	2,0x52,2,0x42
		mSend	3,0x46,3,0x42
		mSend	4,0x4A,4,0x42
		mSend	5,0x52,5,0x3E
		mSend	6,0x62,6,0x02
		mSend	7,0x42,7,0x02
		mSend	8,0x00,8,0x00
		RCALL	wait
;7 4u
		mSend	1,0x00,1,0x00
		mSend	2,0x42,2,0x42
		mSend	3,0x42,3,0x46
		mSend	4,0x42,4,0x4A
		mSend	5,0x3E,5,0x52
		mSend	6,0x02,6,0x62
		mSend	7,0x02,7,0x42
		mSend	8,0x00,8,0x00
		RCALL	wait
;8 uk
		mSend	1,0x00,1,0x00
		mSend	2,0x42,2,0x42
		mSend	3,0x46,3,0x44
		mSend	4,0x4A,4,0x78
		mSend	5,0x52,5,0x44
		mSend	6,0x62,6,0x42
		mSend	7,0x42,7,0x42
		mSend	8,0x00,8,0x00
		RCALL	wait
;9 k_
		mSend	1,0x00,1,0
		mSend	2,0x42,2,0
		mSend	3,0x44,3,0
		mSend	4,0x78,4,0
		mSend	5,0x44,5,0
		mSend	6,0x42,6,0
		mSend	7,0x42,7,0
		mSend	8,0x00,8,0
		RCALL	wait
;10 _v
		mSend	1,0,1,0x00
		mSend	2,0,2,0x66
		mSend	3,0,3,0xFF
		mSend	4,0,4,0xFF
		mSend	5,0,5,0x7E
		mSend	6,0,6,0x3C
		mSend	7,0,7,0x18
		mSend	8,0,8,0x00
		RCALL	wait
;11 v_
		mSend	1,0x00,1,0
		mSend	2,0x66,2,0
		mSend	3,0xFF,3,0
		mSend	4,0xFF,4,0
		mSend	5,0x7E,5,0
		mSend	6,0x3C,6,0
		mSend	7,0x18,7,0
		mSend	8,0x00,8,0
		RCALL	wait
;10 _v
		mSend	1,0,1,0x00
		mSend	2,0,2,0x66
		mSend	3,0,3,0xFF
		mSend	4,0,4,0xFF
		mSend	5,0,5,0x7E
		mSend	6,0,6,0x3C
		mSend	7,0,7,0x18
		mSend	8,0,8,0x00
		RCALL	wait
;11 v_
		mSend	1,0x00,1,0
		mSend	2,0x66,2,0
		mSend	3,0xFF,3,0
		mSend	4,0xFF,4,0
		mSend	5,0x7E,5,0
		mSend	6,0x3C,6,0
		mSend	7,0x18,7,0
		mSend	8,0x00,8,0
		RCALL	wait
		RET
