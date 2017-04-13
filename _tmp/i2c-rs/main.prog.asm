; R17(Data),R19(Error code) = ReadRxBuff (void)	[[R16-R19, X]]
; R19(Error code) = WriteTxBuff (R17(Data))	[[R16-R19, X]]
;------------------------------------------------------------

SEI

MainLoop1:
;RCALL	ReadRxBuff
;RCALL	MainDelay1
;CPI	R19,0x01
;BREQ	MainLoop1

RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
MOV	R16,constFF
OUT	PORTD,R16
RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
;RCALL	MainDelay1
MOV	R16,const0
OUT	PORTD,R16
RJMP	MainLoop1

;------------------------------------------------------------
LDI	ZL,low(HelloMsg *2)
LDI	ZH,high(HelloMsg *2)
MainLoop2:
LD	R17,Z+
ORI	R17,0x00
BREQ	MainEnd
RCALL	WriteTxBuff
RJMP	MainLoop2

;------------------------------------------------------------
HelloMsg:	.db	"Hello. AVR I2C<>RS232 Ready.",0,0
;HelloMsg:	.db	"H","e","l","l","o","."," ","A","V","R"," ","I","2","C","<",">","R","S","2","3","2"," ","R","e","a","d","y",".",0
;------------------------------------------------------------
MainDelay1:
LDI	R16,160
MainDelay1Loop1:
LDI	R17,250
MainDelay1Loop2:
NOP
DEC	R17
BRNE	MainDelay1Loop2
DEC	R16
BRNE	MainDelay1Loop1
RET
;------------------------------------------------------------
MainEnd:
SBI	UCSRB,UDRIE
