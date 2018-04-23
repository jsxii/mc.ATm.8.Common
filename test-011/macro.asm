.MACRO short
	out portb, r20
	nop
	out portb, r21
	ldi r16, 6
aad:	dec r16
	nop
	breq aac
	rjmp aad
aac:
	nop
.ENDM

.MACRO shortend
	out portb, r20
	nop
	out portb, r21
	ldi r16, 4
aag:	dec r16
	nop
	breq aah
	rjmp aag
aah:
	nop
.ENDM

.MACRO long
	out portb, r20
	ldi r16, 6
aae:	dec r16
	nop
	breq aaf
	rjmp aae
aaf:
	nop
	nop
	out portb, r21
	nop
.ENDM

.MACRO line
	out portb, r22
	nop
	nop
	nop
	out portb, r23
	ldi r16, 13
aaa:	dec r16
	nop
	breq aab
	rjmp aaa
aab:
.ENDM


