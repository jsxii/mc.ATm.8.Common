;== Initialization ==========================================
;
;------------------------------------------------------------
Initialisation:
;------------------------------------------------------------
CLI
;-- Init stack --
LDI	R16,low(RAMEND)
OUT	SPL,R16
LDI	R16,high(RAMEND)
OUT	SPH,R16

;-- Init dispatcher
RCALL	TaskQueueInit

;-- Init programm
RCALL	ProgrammInit

; -- Start dispatcher
SEI
RJMP	MainCycle
