

;===============================================================================
; Stack initialisation
	.MACRO mStackInit
		LDI			R16,Low(RAMEND)
	  	OUT			SPL,R16
 	  	LDI			R16,High(RAMEND)
	  	OUT			SPH,R16
	.ENDM

;===============================================================================
; PUSH R16 & PUSH SREG
	.MACRO mPUSHF
	PUSH	R16
	IN	R16,SREG
	PUSH	R16
	.ENDM
;-------------------------------------------------------------------------------
; POP R16 & POP SREG
	.MACRO mPOPF
	POP	R16
	OUT	SREG,R16
	POP	R16
	.ENDM
;===============================================================================
