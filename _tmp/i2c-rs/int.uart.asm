;-- UART ----------------------------------------------------
;------------------------------------------------------------
iUSARTrxc:
CLI
PUSH	R16
IN	R16,SREG
PUSH	R16
PUSH	R17
PUSH	R18
PUSH	XL
PUSH	XH
LDI	XL,low(RxBuff)
LDI	XH,high(RxBuff)
MOV	R16,RxPtrE
MOV	R18,RxPtrS
ADD	XL,R16		; ��������� ������ �� ���������
CLR	R17		; �������� ����� ����� ������
ADC	XH,R17
IN	R17,UDR		; �������� ������
ST	X,R17		; ��������� �� � ������
INC	R16		; ����������� ��������
CPI	R16,RxBuffSize	; ���� �������� ����� 
BRNE	RxBuffNoEnd
CLR	R16		; ������������ �� ������

RxBuffNoEnd:
CP	R16,R18		; ����� �� ������������� ������?
BRNE	RxIntExit	; ���� ���, �� ������ �������
LDI	R18,1		; ���� ��, �� ������ ����������.
MOV	RxFull,R18	; ���������� ���� �������������

RxIntExit:
MOV	RxPtrE,R16	; ��������� ��������. �������
POP	XH
POP	XL
POP	R18
POP	R17
POP	R16
OUT	SREG,R16
POP	R16
SEI
RETI

;------------------------------------------------------------
iUSARTudre:
PUSH	R16
IN	R16,SREG
PUSH	R16
PUSH	R17
PUSH	R18
PUSH	R19
PUSH	XL
PUSH	XH
LDI	XL,low(TxBuff)		; ����� ����� ������ �������
LDI	XH,high(TxBuff)
MOV	R16,TxPtrE		; ����� �������� ����� ������
MOV	R18,TxPtrS		; ����� �������� ����� ������			
MOV	R19,TxFull		; ���� ���� ������������
CPI	R19,1			; ���� ������ ����������, �� ��������� ������
BREQ	TxBuffNotEmpty		; ����� ��������� �����. ��� ���� ������.
CP	R18,R16			; ��������� ������ ������ ��������� ������?
BRNE	TxBuffNotEmpty		; ���! ������ �� ����. ���� ����� ������
LDI	R16,1<<RXEN|1<<TXEN|1<<RXCIE|1<<TXCIE|0<<UDRIE	; ������ ����������
OUT	UCSRB, R16					; �� ������� UDR
RJMP	TxIntExit			; �������

TxBuffNotEmpty:
CLR	R17			; �������� ����
MOV	TxFull,R17		; ���������� ���� ������������
ADD	XL,R18			; ��������� ������ �� ���������
ADC	XH,R17			; �������� ����� ����� ������
LD	R17,X			; ����� ���� �� �������
OUT	UDR,R17			; ���������� ��� � USART
INC	R18			; ����������� �������� ��������� ������
CPI	R18,TxBuffSize		; �������� ����� ������?
BRNE	TxIntExit		; ���? 
CLR	R18			; ��? ����������, ����������� �� 0

TxIntExit:
MOV	TxPtrS,R18		; ��������� ���������
POP	XH
POP	XL
POP	R19
POP	R18
POP	R17
POP	R16
OUT	SREG,R16
POP	R16
RETI

;------------------------------------------------------------
