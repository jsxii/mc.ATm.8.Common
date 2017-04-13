.include	"m8def.inc"
;.include	"macro.inc"


.CSEG
.include	"vectors8.asm"

Init:
.include	"init.asm"

LDI	R20,0x00
MOV	R21,R20
loop:

USART_Receive:

SBIS	UCSRA, RXC
RJMP	USART_Receive
IN	R17, UDR

USART_Transmit:
SBIS	UCSRA,UDRE
RJMP	USART_Transmit
OUT	UDR,R17

RCALL	LCDDataWR

INC	R20
CPI	R20,0x10
BRNE	loop
LDI	R20,0
INC	R21
ANDI	R21,1
MOV	R17,R20
MOV	R18,R21

RCALL	LCDCoordSet

RJMP	loop


.include	"LCD1602-8bit.asm"
.include	"UartInit.asm"
.include	"interrupts8.asm"
;.include	""
