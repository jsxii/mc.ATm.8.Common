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
LDI	XL,low(RxBuff)	; Берем адрес начала буффера
LDI	XH,high(RxBuff)
MOV	R16,RxPtrE	; Берем смещение точки записи
MOV	R18,RxPtrS	; Берем смещение точки чтения			
MOV	R19,RxFull	; Берм флаг переполнения
CPI	R19,1		; Если буффер переполнен, то указатель начала
BREQ	ReadRxNext	; Равен указателю конца. Это надо учесть.
CP	R18,R16		; Указатель чтения достиг указателя записи?
BRNE	ReadRxNext	; Нет! Буффер не пуст. Работаем дальше
LDI	R19,1		; Код ошибки - пустой буффер!
RJMP	ReadRxExit	; Выходим

ReadRxNext:
CLR	R17		; Получаем ноль
MOV	RxFull,R17	; Сбрасываем флаг переполнения
ADD	XL,R18		; Сложением адреса со смещением
ADC	XH,R17		; получаем адрес точки чтения
LD	R17,X		; Берем байт из буффера
CLR	R19		; Сброс кода ошибки
INC	R18		; Увеличиваем смещение указателя чтения
CPI	R18,RxBuffSize	; Достигли конца кольца?
BRNE	ReadRxExit	; Нет? 
CLR	R18		; Да? Сбрасываем, переставляя на 0

ReadRxExit:
MOV	RxPtrS,R18	; Сохраняем указатель
SEI			; Разрешаем прерывания
RET

;------------------------------------------------------------
WriteTxBuff:
CLI 			; Запрет прерываний. 
LDI	XL,low(TxBuff)	; Берем адрес начала буффера
LDI	XH,high(TxBuff)
MOV	R16,TxPtrE	; Берем смещение точки записи
MOV	R18,TxPtrS	; Берем смещение точки чтения
ADD	XL,R16		; Сложением адреса со смещением
CLR	R17		; получаем адрес точки записи
ADC	XH,R17
ST	X,R19		; сохраняем их в кольцо
CLR	R19		; Очищаем R19, теперь там код ошибки, Который вернет подпрограмма
INC	R16		; Увеличиваем смещение
CPI	R16,TxBuffSize	; Если достигли конца 
BRNE	WriteTxNext
CLR	R16		; переставляем на начало

WriteTxNext:
CP	R16,R18		; Дошли до непрочитанных данных?
BRNE	WriteTxExit	; Если нет, то просто выходим
LDI	R19,1		; Если да, то буффер переполнен.
MOV	TxFull,R19	; Записываем флаг наполненности В R19 остается 1 - код ошибки переполнения

WriteTxExit:
MOV	TxPtrE,R16	; Сохраняем смещение. Выходим
SEI			; Разрешение прерываний
RET

;------------------------------------------------------------
