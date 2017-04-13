;== UART ====================================================
; void InitUART (void) [R16]
; R17(Data),R19(Error code) = ReadRxBuff (void) [[R16-R19, X]]
; R19(Error code) = WriteTxBuff (R17(Data)) [[R16-R19, X]]
;------------------------------------------------------------
InitUART:
LDI 	R16, low(bauddivider)
OUT 	UBRRL,R16
LDI 	R16, high(bauddivider)
OUT 	UBRRH,R16
LDI 	R16,0
OUT 	UCSRA, R16
LDI 	R16, (0<<RXCIE)|(0<<TXCIE)|(0<<UDRIE)|(1<<RXEN)|(1<<TXEN)|(0<<UCSZ2)|(0<<RXB8)|(0<<TXB8)
OUT 	UCSRB, R16
; 8 bits, 1 stop, no parity
LDI 	R16, (1<<URSEL)|(0<<UMSEL)|(0<<UPM1)|(0<<UPM0)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0)|(0<<UCPOL)
OUT 	UCSRC, R16
RET
;------------------------------------------------------------
ReadRxBuff:
CLI
LDI	XL,low(RxBuff)	; ����� ����� ������ �������
LDI	XH,high(RxBuff)
MOV	R16,RxPtrE	; ����� �������� ����� ������
MOV	R18,RxPtrS	; ����� �������� ����� ������			
MOV	R19,RxFull	; ���� ���� ������������
CPI	R19,1		; ���� ������ ����������, �� ��������� ������
BREQ	ReadRxNext	; ����� ��������� �����. ��� ���� ������.
CP	R18,R16		; ��������� ������ ������ ��������� ������?
BRNE	ReadRxNext	; ���! ������ �� ����. �������� ������
LDI	R19,1		; ��� ������ - ������ ������!
RJMP	ReadRxExit	; �������

ReadRxNext:
CLR	R17		; �������� ����
MOV	RxFull,R17	; ���������� ���� ������������
ADD	XL,R18		; ��������� ������ �� ���������
ADC	XH,R17		; �������� ����� ����� ������
LD	R17,X		; ����� ���� �� �������
CLR	R19		; ����� ���� ������
INC	R18		; ����������� �������� ��������� ������
CPI	R18,RxBuffSize	; �������� ����� ������?
BRNE	ReadRxExit	; ���? 
CLR	R18		; ��? ����������, ����������� �� 0

ReadRxExit:
MOV	RxPtrS,R18	; ��������� ���������
SEI			; ��������� ����������
RET

;------------------------------------------------------------
WriteTxBuff:
CLI 			; ������ ����������. 
LDI	XL,low(TxBuff)	; ����� ����� ������ �������
LDI	XH,high(TxBuff)
MOV	R16,TxPtrE	; ����� �������� ����� ������
MOV	R18,TxPtrS	; ����� �������� ����� ������
ADD	XL,R16		; ��������� ������ �� ���������
CLR	R17		; �������� ����� ����� ������
ADC	XH,R17
ST	X,R19		; ��������� �� � ������
CLR	R19		; ������� R19, ������ ��� ��� ������, ������� ������ ������������
INC	R16		; ����������� ��������
CPI	R16,TxBuffSize	; ���� �������� ����� 
BRNE	WriteTxNext
CLR	R16		; ������������ �� ������

WriteTxNext:
CP	R16,R18		; ����� �� ������������� ������?
BRNE	WriteTxExit	; ���� ���, �� ������ �������
LDI	R19,1		; ���� ��, �� ������ ����������.
MOV	TxFull,R19	; ���������� ���� ������������� � R19 �������� 1 - ��� ������ ������������

WriteTxExit:
MOV	TxPtrE,R16	; ��������� ��������. �������
SEI			; ���������� ����������
RET

;------------------------------------------------------------
