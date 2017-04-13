;== Vectors =================================================
; ATMega8
;------------------------------------------------------------
intRESET:	RJMP	Initialisation
intINT0:	RETI
;intINT0:	RJMP	..
intINT1:	RETI
;intINT1:	RJMP	..
intT2comp:	RETI
;intT2comp:	RJMP	..
intT2ovf:	RETI
;intT2ovf:	RJMP	..
intT1capt:	RETI
;intT1capt:	RJMP	..
intT1compA:	RETI
;intT1compA:	RJMP	..
intT1compB:	RETI
;intT1compB:	RJMP	..
intT1ovf:	RETI
;intT1ovf:	RJMP	TimerQueueInt
intT0ovf:	RETI
;intT0ovf:	RJMP	..
intSPIstc:	RETI
;intSPIstc:	RJMP	..
intUSARTrxc:	RETI
;intUSARTrxc:	RJMP	..
intUSARTudre:	RETI
;intUSARTudre:	RJMP	..
intUSARTtxc:	RETI
;intUSARTtxc:	RJMP	..
intADCcompl:	RETI
;intADCcompl:	RJMP	..
intEErdy:	RETI
;intEErdy:	RJMP	..
intAcomp:	RETI
;intAcomp:	RJMP	..
intTWI: 	RETI
;intTWI: 	RJMP	..
intSPMrdy:	RETI
;intSPMrdy:	RJMP	..
;------------------------------------------------------------

