;------------------------------------------------------------
.include "m8def.inc"
.include "define.asm"
;------------------------------------------------------------
; Interrupt vectors and interrupts tasks
.include "vectors.asm"
.include "spi.int.asm"
;------------------------------------------------------------
; Tasks
.include "max7219.asm"
;------------------------------------------------------------
; Initialisation
.include "init.asm"
;------------------------------------------------------------
; Main loop
MainLoop:
	SEI
; Reset watchdog
	WDR
; Task queue processing
	RCALL	ProcessTaskQueue
; Idle task
	RCALL 	Idle
; Repeat..
	RJMP 	MainLoop
;------------------------------------------------------------
; RTOS kernel
.include "kernel.asm"
;------------------------------------------------------------
; Task index + aliases
.include "tasktable.asm"
;.CSEG end
;------------------------------------------------------------
; SRAM; buffers, vars, etc
.include "memory.asm"
