; (R18(flag)) = WrTxBuff(R17(data)) [ R16-18,Z ] (0 = ok; 1 = overflow)
; (R18(flag)) = WrRxBuff(R17(data)) [ R16-18,Z ] (0 = ok; 1 = overflow)
; (R17(data),R18(flag)) = RdTxBuff(void) [ R16-18,Z ] (0 = ok; 2 = empty)
; (R17(data),R18(flag)) = RdRxBuff(void) [ R16-18,Z ] (0 = ok; 2 = empty)
; (void) = ClrBuff(void) [R16,R17,Z] (-)

;------------------------------------------------------------
ClrBuff:
CLR	R16
LDI	ZL,low(RxBuff)
LDI	ZH,high(RxBuff)
LDI	R17,(RxBuffSize + TxBuffSize)
Clrb1:
ST	Z+,R16
DEC	R17
BRNE	Clrb1
CBR	STREG,(1<<RxFull|1<<TxFull)	; clear 'full' flags
RET
;------------------------------------------------------------
RdRxBuff:
CP	RxL,RxF
BRNE	Rrb1
LDI	R18,2		; if ret in next check
SBRS	STREG,RxFull	; check
RET			; ret if clear 'full'
Rrb1:
MOV	R16,RxF
LDI	ZH,high(RxBuff)	; load buff start addr
LDI	ZL,low(RxBuff)	; -//--//-
ADD	ZL,R16		; add pointer
ADC	ZH,c00		; -//--//-
LD	R17,Z		; read from buff
INC	R16
CPI	R16,RxBuffSize	; end buff ?
BRNE	Rrb2		; no, next
MOV	R16,c00		; yes? go to 0
Rrb2:
MOV	RxF,R16		; save pointer
CBR	STREG,(1<<RxFull)	; clear 'full' flag
MOV	R18,c00		; 'no error' return
RET
;------------------------------------------------------------
RdTxBuff:
CP	TxL,TxF
BRNE	Rtb1
LDI	R18,2		; if ret in next check
SBRS	STREG,TxFull	; check
RET			; ret if clear 'full'
Rtb1:
MOV	R16,TxF
LDI	ZH,high(TxBuff)	; load buff start addr
LDI	ZL,low(TxBuff)	; -//--//-
ADD	ZL,R16		; add pointer
ADC	ZH,c00		; -//--//-
LD	R17,Z		; read from buff
INC	R16
CPI	R16,TxBuffSize	; end buff ?
BRNE	Rtb2		; no, next
MOV	R16,c00		; yes? go to 0
Rtb2:
MOV	TxF,R16		; save pointer
CBR	STREG,(1<<TxFull)	; clear 'full' flag
MOV	R18,c00		; 'no error' return
RET
;------------------------------------------------------------
WrTxBuff:
LDI	R18,0x01	; if ret in next check
SBRC	STREG,TxFull	; check
RET			; ret if set 'full'
MOV	R16,TxL		
LDI	ZH,high(TxBuff)	; load buff start addr
LDI	ZL,low(TxBuff)	; -//--//-
ADD	ZL,R16		; add pointer
ADC	ZH,c00		; -//--//-
ST	Z,R17		; save to buff
INC	R16		; increase pointer
CPI	R16,TxBuffSize	; end buff ?
BRNE	Wtb1		; no, next
MOV	R16,c00		; yes? go to 0
Wtb1:
CP	R16,TxF		; buff full ?
BRNE	Wtb2		; no, go to next
SBR	STREG,(1<<TxFull)	; yes, set flag
Wtb2:
MOV	TxL,R16		; save pointer
MOV	R18,c00		; 'no error' return
RET
;------------------------------------------------------------
WrRxBuff:
LDI	R18,0x01	; if ret in next check
SBRC	STREG,RxFull	; check
RET			; ret if set 'full'
MOV	R16,RxL		
LDI	ZH,high(RxBuff)	; load buff start addr
LDI	ZL,low(RxBuff)	; -//--//-
ADD	ZL,R16		; add pointer
ADC	ZH,c00		; -//--//-
ST	Z,R17		; save to buff
INC	R16		; increase pointer
CPI	R16,RxBuffSize	; end buff ?
BRNE	Wrb1		; no, next
MOV	R16,c00		; yes? go to 0
Wrb1:
CP	R16,RxF		; buff full ?
BRNE	Wrb2		; no, go to next
SBR	STREG,(1<<RxFull)	; yes, set flag
Wrb2:
MOV	RxL,R16
MOV	R18,c00
RET
;------------------------------------------------------------


