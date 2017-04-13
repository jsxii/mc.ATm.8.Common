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
ADD	XL,R16		; Сложением адреса со смещением
CLR	R17		; получаем адрес точки записи
ADC	XH,R17
IN	R17,UDR		; Забираем данные
ST	X,R17		; сохраняем их в кольцо
INC	R16		; Увеличиваем смещение
CPI	R16,RxBuffSize	; Если достигли конца 
BRNE	RxBuffNoEnd
CLR	R16		; переставляем на начало

RxBuffNoEnd:
CP	R16,R18		; Дошли до непрочитанных данных?
BRNE	RxIntExit	; Если нет, то просто выходим
LDI	R18,1		; Если да, то буффер переполнен.
MOV	RxFull,R18	; Записываем флаг наполненности

RxIntExit:
MOV	RxPtrE,R16	; Сохраняем смещение. Выходим
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
LDI	XL,low(TxBuff)		; Берем адрес начала буффера
LDI	XH,high(TxBuff)
MOV	R16,TxPtrE		; Берем смещение точки записи
MOV	R18,TxPtrS		; Берем смещение точки чтения			
MOV	R19,TxFull		; Берм флаг переполнения
CPI	R19,1			; Если буффер переполнен, то указатель начала
BREQ	TxBuffNotEmpty		; Равер указателю конца. Это надо учесть.
CP	R18,R16			; Указатель чтения достиг указателя записи?
BRNE	TxBuffNotEmpty		; Нет! Буффер не пуст. Надо слать дальше
LDI	R16,1<<RXEN|1<<TXEN|1<<RXCIE|1<<TXCIE|0<<UDRIE	; Запрет прерывания
OUT	UCSRB, R16					; По пустому UDR
RJMP	TxIntExit			; Выходим

TxBuffNotEmpty:
CLR	R17			; Получаем ноль
MOV	TxFull,R17		; Сбрасываем флаг переполнения
ADD	XL,R18			; Сложением адреса со смещением
ADC	XH,R17			; получаем адрес точки чтения
LD	R17,X			; Берем байт из буффера
OUT	UDR,R17			; Отправляем его в USART
INC	R18			; Увеличиваем смещение указателя чтения
CPI	R18,TxBuffSize		; Достигли конца кольца?
BRNE	TxIntExit		; Нет? 
CLR	R18			; Да? Сбрасываем, переставляя на 0

TxIntExit:
MOV	TxPtrS,R18		; Сохраняем указатель
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
