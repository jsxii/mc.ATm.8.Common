RCALL	sub01
.db	3,7,15,31,63,127,255,0
; work
;------------------------------------------------------------
loop:
; work
RJMP	loop
;------------------------------------------------------------
sub01:
POP	ZH
POP	ZL
LSL	ZL
ROL	ZH
sub02:
LPM	R16,Z+
CPI	R16,0
BRNE	sub03
LSR	ZH
ROR	ZL
IJMP
sub03:
; --
; work
; --
RJMP	sub02
;------------------------------------------------------------
