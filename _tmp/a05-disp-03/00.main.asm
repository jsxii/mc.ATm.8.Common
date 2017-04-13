;------------------------------------------------------------
.include	"m8def.inc"
.include	"00.define.inc"
;== Program =================================================
.CSEG
;-- System/OS -----------------------------------------------
.ORG	0x00
;------------------------------------------------------------
.include	"01.vectors.asm"
.include	"02.init.asm"
.include	"03.dispatcher.asm"
.include	"03.timer.asm"
.include	"04.taskdef.asm"
.include	"05.headers.inc"
;-- System/App ----------------------------------------------
.include	"09.checkreset.asm"
.include	"09.watchdog.asm"
;-- User Space ----------------------------------------------
.include	"10.program.init.asm"



;------------------------------------------------------------
.include	"99.SRAM.asm"
