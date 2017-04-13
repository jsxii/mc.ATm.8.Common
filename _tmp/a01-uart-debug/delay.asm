;== Delays ==================================================
;
;------------------------------------------------------------
Delay1K:			; 3 for RCALL/ICALL
LDI	R17,248			; 1
Delay1Kloop:
NOP				; 1
DEC	R17			; 1
BRNE	Delay1Kloop		; 2/1
NOP				; 1
RET				; 4
;------------------------------------------------------------
Delay8K:			; 3 for RCALL/ICALL
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay1K			; 1000
NOP				; 1
RET				; 4
;------------------------------------------------------------
Delay10K:			; 3 for RCALL/ICALL
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay1K			; 1000
RCALL	Delay1K			; 1000
RCALL	Delay1K			; 1000
RET				; 4
;------------------------------------------------------------
Delay100K:			; 3 for RCALL/ICALL
RCALL	Delay9997		; 9'997
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay9997		; 9'997
RCALL	Delay9997		; 9'997
NOP				; 1
NOP				; 1
RET				; 4
;------------------------------------------------------------
Delay1M:			; 3 for RCALL/ICALL
NOP				; 1
NOP				; 1
RCALL	Delay99995		; 99'995
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay100K		; 100'000
RCALL	Delay99995		; 99'995
NOP				; 1
RET				; 4
;------------------------------------------------------------
;------------------------------------------------------------
Delay999:			; 3 for RCALL/ICALL
LDI	R17,248			; 1
Delay999loop:
NOP				; 1
DEC	R17			; 1
BRNE	Delay999loop		; 2/1
RET				; 4
;------------------------------------------------------------
Delay9997:			; 3 for RCALL/ICALL
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RCALL	Delay999		; 999
RET				; 4
;------------------------------------------------------------
Delay99995:			; 3 for RCALL/ICALL
RCALL	Delay9997		; 9'997
RCALL	Delay9997		; 9'997
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay10K		; 10'000
RCALL	Delay9997		; 9'997
RCALL	Delay9997		; 9'997
RET				; 4
;------------------------------------------------------------
