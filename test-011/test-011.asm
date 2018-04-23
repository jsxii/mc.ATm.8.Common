.include	"tn85def.inc"
.include	"macro.asm"

; b0 = syn; b1 = enable

.cseg
	cli
	ldi ZL, 0
	ldi ZH, 0
	ldi r20, 0
	ldi r21, 1
	ldi r22, 2
	ldi r23, 3

	long
	long
	long
	long
	long

	short
	nop	
	short
	nop	
	short	
	nop
	short	
	nop
	short	
	out portb, r23

	line	;1
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;11
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;21
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;31
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;41
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;1
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;11
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;21
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;31
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;41
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;1
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;11
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;21
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;31
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;41
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;1
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;11
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;21
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;31
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;41
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;1
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;11
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;21
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;31
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;41
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;1
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;11
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;21
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;31
	line
	line
	line
	line
	line
	line
	line
	line
	line
	line	;41
	line
	line
	line
	line
	line
	line
	line
	line
	line

	line
	line
	line
	line

	short
	short
	short
	short
	short
	shortend
	ijmp


