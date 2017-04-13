; LCD 8bit lib. (Use R16, R17, R18)
;================================================================================
; EXPORT 
;================================================================================
; -- required --
; void LCDInit (void)
; void LCDCommandWR (R17)
; R17= LCDCommandRD (void)
; void LCDDataWR (R17)
; R17= LCDDataRD (void)
; -- optional --
; void LCDShiftScrLeft (void)
; void LCDShiftScrRight (void)
; void LCDShiftCurLeft (void)
; void LCDShiftCurRight (void)
; void LCDCoordSet (R17,R18); (x,y) = (0..63, 0..3) TODO : !(0x40) =40 (0x28) 
; void LCDClearScreen (void)
; void LCDSetToDDRAM (R17)
; void LCDSetToCGRAM (R17)
;================================================================================
; PRIVATE
;================================================================================
; LCDBusywait
; LCDDelay
;================================================================================
.equ	LCDDataPort	= PORTB
.equ	LCDDataPin	= PINB
.equ	LCDDataDDR	= DDRB
;---
.equ	LCDCommandPort	= PORTC
.equ	LCDCommandPin	= PINC
.equ	LCDCommandDDR		= DDRC
;---
.equ	LCDPinE		= 0
.equ	LCDPinRW	= 1
.equ	LCDPinRS	= 2
;---
.equ	LCDDelayValue	= 10	; 14=(XTAL=16MHz), 10=(XTAL=8MHz), 6=(XTAL=4MHz), 5=(XTAL<4MHz)
;================================================================================
LCDInit:		; Start Initialisation
CBI	LCDCommandPort,LCDPinRS	; set cmd bits to null
CBI	LCDCommandPort,LCDPinRW	; ..
CBI	LCDCommandPort,LCDPinE	; ..
SBI	LCDCommandDDR,LCDPinRS	; set cmd bits to out.
SBI	LCDCommandDDR,LCDPinRW	; ..
SBI	LCDCommandDDR,LCDPinE	; ..
LDI	R16,0x00	; set data port to in.
OUT	LCDDataDDR,R16	; ..
LDI	R16,0xFF	; Pull-up on
OUT	LCDDataPort,R16	; ..
LDI	R16, 0x03	; wait
RCALL	LCDDelayLoop	; ..
LDI	R17,0x38	; |001|mode|lines|charset|00|; mode=(1=8bit;0=4bit); lines=(1=two lines;0=one line); charset=(1=5x10 font;0=5x7 font).
RCALL	LCDCommandWR	; Function set = 8bit, 2 lines, charset 5x7
LDI	R17,0x01	; No param
RCALL	LCDCommandWR	; Clear display and set DDRAM address = 0
LDI	R17,0x06	; |000001|i/d|s|; i/d=(1=increment DDRAM;0=decrement DDRAM); s=(1=enable screen shift;0=disable screen shift).
RCALL	LCDCommandWR	; Entry mode set = increment DDRAM, screen shift disable
LDI	R17,0x0E	; |00001|display|cursor|blink|; 0=off,1=on for (display; visibility cursor; blinking cursor)
RCALL	LCDCommandWR	; Display on/off control; display on, cursor on, blinking off
LDI	R17,0x02	; No param
RCALL	LCDCommandWR	; Return home; Cursor at 0,0(DDRAM=0); Cancel all shifts.
RET
;================================================================================
LCDCommandWR:
CLI	; int off
RCALL	LCDBusyWait	; wait
CBI	LCDCommandPort,LCDPinRS	;
RJMP	LCDWrite
;--------------------------------------------------------------------------------
LCDDataWR:
CLI		; int off
RCALL	LCDBusyWait	; wait
SBI	LCDCommandPort,LCDPinRS	; data
LCDWrite:
CBI	LCDCommandPort,LCDPinRW	; write
SBI	LCDCommandPort,LCDPinE	; strob on
LDI	R16,0xFF	; set data port to out.
OUT	LCDDataDDR,R16	; ..
OUT	LCDDataPort,R17	; output data
RCALL	LCDDelay	; wait
CBI	LCDCommandPort,LCDPinE	; strob off
LDI	R16,0	; set data port to in.
OUT	LCDDataDDR,R16	; ..
LDI	R16,0xFF	; Pull-up on
OUT	LCDDataPort,R16	; ..
SEI	; int on
RET
;================================================================================
LCDCommandRD:
CLI	; int off
LDI	R16,0	; set data port to in.
OUT	LCDDataDDR,R16	; ..
LDI	R16,0xFF	; Pull-up on
OUT	LCDDataPort,R16	; ..
RCALL	LCDBusyWait	;wait
CBI	LCDCommandPort,LCDPinRS	; command
RJMP	LCDRead
;--------------------------------------------------------------------------------
LCDDataRD:
CLI	; int off
LDI	R16,0	; set data port to in.
OUT	LCDDataDDR,R16	; ..
LDI	R16,0xFF	; Pull-up on
OUT	LCDDataPort,R16	; ..
RCALL	LCDBusyWait	; wait
SBI	LCDCommandPort,LCDPinRS	; data
LCDRead:
SBI	LCDCommandPort,LCDPinRW	; read
SBI	LCDCommandPort,LCDPinE	; strob on
RCALL	LCDDelay	; wait
IN	R17,LCDDataPin	; read data from lcd
CBI	LCDCommandPort,LCDPinE	; strob off
SEI	; int on
RET
;================================================================================
LCDClearScreen:
LDI	R17,0x01
RJMP	LCDCommandWR
;================================================================================
LCDCoordSet:
;ANDI	R17,0x2F	; check for valid X
ANDI	R18,0x03	; check for valid Y
LSL	R18	; R18 = R18 * 0x28
LSL	R18	; ..
LSL	R18	; ..
MOV	R16,R18
LSL	R18	; ..
LSL	R18	; ..
ADD	R17,R16	; R17 = R17 + R18 * 0x08
ADD	R17,R18 ; R17 = R17 + R18 * 0x20
ORI	R17,0x80	; set bit 7; command = 1yxxxxxx
RJMP	LCDCommandWR	; write command
;================================================================================
LCDSetToDDRAM:
ORI	R17,0x80	; set bit 7; command = 1aaaaaaa
RJMP	LCDCommandWR
;================================================================================
LCDSetToCGRAM:
ANDI	R17,0x7F	; check valid address
ORI	R17,0x40	; set bit 6; command = 01aaaaaa
RJMP	LCDCommandWR
;================================================================================
LCDShiftScrLeft:
LDI	R17,0x18
RJMP	LCDCommandWR
;================================================================================
LCDShiftScrRight:
LDI	R17,0x1C
RJMP	LCDCommandWR
;================================================================================
LCDShiftCurLeft:
LDI	R17,0x10
RJMP	LCDCommandWR
;================================================================================
LCDShiftCurRight:
LDI	R17,0x14
RJMP	LCDCommandWR
;================================================================================
LCDBusyWait:
LDI	R16,0	; set data port to in.
OUT	LCDDataDDR,R16	; ..
LDI	R16,0xFF	; Pull-up on
OUT	LCDDataPort,R16	; ..
CBI	LCDCommandPort,LCDPinRS	; command
SBI	LCDCommandPort,LCDPinRW	; read
LCDBusyLoop:
SBI	LCDCommandPort,LCDPinE	; strob on
RCALL	LCDDelay	; wait
CBI	LCDCommandPort,LCDPinE	; strob off
IN	R16,LCDDataPin	; read data
ANDI	R16,0x80	; check flag (bit7)
BRNE	LCDBusyLoop	; repeat if busy
RET
;================================================================================
LCDDelay:
LDI	R16,LCDDelayValue
LCDDelayloop:
DEC	R16
BRNE	LCDDelayloop
RET
;================================================================================
