			.include "m8def.inc"   ; Используем ATMega16
			.include "macro.inc"

; RAM ========================================================
		.DSEG

			.equ MAXBUFF_IN	 =	10	
			.equ MAXBUFF_OUT = 	10
	
IN_buff:	.byte	MAXBUFF_IN
IN_PTR_S:	.byte	1
IN_PTR_E:	.byte	1
IN_FULL:	.byte	1	

OUT_buff:	.byte	MAXBUFF_OUT
OUT_PTR_S:	.byte	1
OUT_PTR_E:	.byte	1
OUT_FULL:	.byte	1

; FLASH ======================================================
         .CSEG
         .ORG $000        	; (RESET) 

vRESET:		RJMP		Init
vINT0:		RJMP		iINT0
vINT1:		RJMP		iINT1
vT2comp:	RJMP		iT2comp
vT2ovf:		RJMP		iT2ovf
vT1capt:	RJMP		iT1capt
vT1compA:	RJMP		iT1compA
vT1compB:	RJMP		iT1compB
vT1ovf:		RJMP		iT1ovf
vT0ovf:		RJMP		iT0ovf
vSPIstc:	RJMP		iSPIstc
vUSARTrxc:	RJMP		iUSARTrxc
vUSARTudre:	RJMP		iUSARTudre
vUSARTtxc:	RJMP		iUSARTtxc
vADCcompl:	RJMP		iADCcompl
vEErdy:		RJMP		iEErdy
vAcomp:		RJMP		iAcomp
vTWI:		RJMP		iTWI
vSPMrdy:	RJMP		iSPMrdy
	
	 	.ORG   INT_VECTORS_SIZE      	; Конец таблицы прерываний

; Interrupts ==============================================


RX_OK:		PUSHF						; Макрос, пихающий в стек SREG и R16
			PUSH	R17
			PUSH	R18
			PUSH	XL
			PUSH	XH

			LDI		XL,low(IN_buff)		; Берем адрес начала буффера
			LDI		XH,high(IN_buff)
			LDS		R16,IN_PTR_E		; Берем смещение точки записи
			LDS		R18,IN_PTR_S		; Берем смещение точки чтения

			ADD		XL,R16				; Сложением адреса со смещением
			CLR		R17					; получаем адрес точки записи
			ADC		XH,R17
			
			IN		R17,UDR				; Забираем данные
			ST		X,R17				; сохраняем их в кольцо

			INC		R16					; Увеличиваем смещение

			CPI		R16,MAXBUFF_IN		; Если достигли конца 
			BRNE	NoEnd
			CLR		R16					; переставляем на начало

NoEnd:		CP		R16,R18				; Дошли до непрочитанных данных?
			BRNE	RX_OUT				; Если нет, то просто выходим


RX_FULL:	LDI		R18,1				; Если да, то буффер переполнен.
			STS		IN_FULL,R18			; Записываем флаг наполненности
			
RX_OUT:		STS		IN_PTR_E,R16		; Сохраняем смещение. Выходим

			POP		XH
			POP		XL
			POP		R18
			POP		R17
			POPF						; Достаем SREG и R16
			RETI


TX_OK:		PUSHF						; Выключаем прерывание UDRE
			LDI 	R16, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE)
			OUT 	UCSRB, R16
			POPF
			RETI



UD_OK:		PUSHF						
			PUSH	R17
			PUSH	R18
			PUSH	R19
			PUSH	XL
			PUSH	XH


			LDI		XL,low(OUT_buff)	; Берем адрес начала буффера
			LDI		XH,high(OUT_buff)
			LDS		R16,OUT_PTR_E		; Берем смещение точки записи
			LDS		R18,OUT_PTR_S		; Берем смещение точки чтения			
			LDS		R19,OUT_FULL		; Берм флаг переполнения

			CPI		R19,1				; Если буффер переполнен, то указатель начала
			BREQ	NeedSend			; Равер указателю конца. Это надо учесть.

			CP		R18,R16				; Указатель чтения достиг указателя записи?
			BRNE	NeedSend			; Нет! Буффер не пуст. Надо слать дальше

			LDI 	R16,1<<RXEN|1<<TXEN|1<<RXCIE|1<<TXCIE|0<<UDRIE	; Запрет прерывания
			OUT 	UCSRB, R16										; По пустому UDR
			RJMP	TX_OUT				; Выходим

NeedSend:	CLR		R17					; Получаем ноль
			STS		OUT_FULL,R17		; Сбрасываем флаг переполнения

			ADD		XL,R18				; Сложением адреса со смещением
			ADC		XH,R17				; получаем адрес точки чтения

			LD		R17,X				; Берем байт из буффера
			OUT		UDR,R17				; Отправляем его в USART

			INC		R18					; Увеличиваем смещение указателя чтения

			CPI		R18,MAXBUFF_OUT		; Достигли конца кольца?
			BRNE	TX_OUT				; Нет? 
			
			CLR		R18					; Да? Сбрасываем, переставляя на 0

TX_OUT:		STS		OUT_PTR_S,R18		; Сохраняем указатель
			
			POP		XH
			POP		XL
			POP		R19
			POP		R18
			POP		R17
			POPF						; Выходим, достав все из стека
			RETI
; End Interrupts ==========================================

; Load Loop Buffer 
; IN R19 	- DATA
; OUT R19 	- ERROR CODE 
Buff_Push:	LDI		XL,low(OUT_buff)	; Берем адрес начала буффера
			LDI		XH,high(OUT_buff)
			LDS		R16,OUT_PTR_E		; Берем смещение точки записи
			LDS		R18,OUT_PTR_S		; Берем смещение точки чтения

			ADD		XL,R16				; Сложением адреса со смещением
			CLR		R17					; получаем адрес точки записи
			ADC		XH,R17
			

			ST		X,R19				; сохраняем их в кольцо
			CLR		R19					; Очищаем R19, теперь там код ошибки
										; Который вернет подпрограмма

			INC		R16					; Увеличиваем смещение

			CPI		R16,MAXBUFF_OUT		; Если достигли конца 
			BRNE	_NoEnd
			CLR		R16					; переставляем на начало

_NoEnd:		CP		R16,R18				; Дошли до непрочитанных данных?
			BRNE	_RX_OUT				; Если нет, то просто выходим


_RX_FULL:	LDI		R19,1				; Если да, то буффер переполнен.
			STS		OUT_FULL,R19		; Записываем флаг наполненности
										; В R19 остается 1 - код ошибки переполнения
			
_RX_OUT:	STS		OUT_PTR_E,R16		; Сохраняем смещение. Выходим
			RET

; Read from loop Buffer
; IN: NONE
; OUT: 	R17 - Data,
;		R19 - ERROR CODE

Buff_Pop: 	LDI		XL,low(IN_buff)		; Берем адрес начала буффера
			LDI		XH,high(IN_buff)
			LDS		R16,IN_PTR_E		; Берем смещение точки записи
			LDS		R18,IN_PTR_S		; Берем смещение точки чтения			
			LDS		R19,IN_FULL			; Берм флаг переполнения

			CPI		R19,1				; Если буффер переполнен, то указатель начала
			BREQ	NeedPop				; Равен указателю конца. Это надо учесть.

			CP		R18,R16				; Указатель чтения достиг указателя записи?
			BRNE	NeedPop				; Нет! Буффер не пуст. Работаем дальше

			LDI		R19,1				; Код ошибки - пустой буффер!
												
			RJMP	_TX_OUT				; Выходим

NeedPop:	CLR		R17					; Получаем ноль
			STS		IN_FULL,R17			; Сбрасываем флаг переполнения

			ADD		XL,R18				; Сложением адреса со смещением
			ADC		XH,R17				; получаем адрес точки чтения

			LD		R17,X				; Берем байт из буффера
			CLR		R19					; Сброс кода ошибки

			INC		R18					; Увеличиваем смещение указателя чтения

			CPI		R18,MAXBUFF_OUT		; Достигли конца кольца?
			BRNE	_TX_OUT				; Нет? 
			
			CLR		R18					; Да? Сбрасываем, переставляя на 0

_TX_OUT:	STS		IN_PTR_S,R18		; Сохраняем указатель
			RET



; RUN =====================================================
Init:   	STACKINIT					; Инициализация стека
			RAMFLUSH					; Очистка памяти

; Usart INIT
			.equ 	XTAL = 8000000 	
			.equ 	baudrate = 9600  
			.equ 	bauddivider = XTAL/(16*baudrate)-1

uart_init:	LDI 	R16, low(bauddivider)
			OUT 	UBRRL,R16
			LDI 	R16, high(bauddivider)
			OUT 	UBRRH,R16

			LDI 	R16,0
			OUT 	UCSRA, R16

; Прерывания запрещены, прием-передача разрешен.
			LDI 	R16, (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE)
			OUT 	UCSRB, R16	

; Формат кадра - 8 бит, пишем в регистр UCSRC, за это отвечает бит селектор
			LDI 	R16, (1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1)
			OUT 	UCSRC, R16


; Иницилизация буфферов:
			CLR		R16

			STS		IN_PTR_S,R16				; Обнуляем указатели
			STS		IN_PTR_E,R16
			STS		OUT_PTR_S,R16
			STS		OUT_PTR_E,R16


		
			SEI
; End Internal Hardware Init ===================================



; External Hardware Init  ======================================


; End External Hardware Init  ==================================

; Run ==========================================================

; End Run ======================================================

; Main =========================================================
Main:		
LOOPS:		RCALL	Buff_Pop
			CPI		R19,1
			BREQ	LOOPS

			INC		R17

			MOV		R19,R17
			RCALL	Buff_Push
			
			CPI		R19,1
			BRNE	RUN	
			
			RCALL	Delay

RUN:		
			TX_RUN

			RJMP		LOOPS

	


; Procedure ====================================================

			.equ 	LowByte  = 255
			.equ	MedByte  = 255
			.equ	HighByte = 1

Delay:		LDI		R16,LowByte		; Грузим три байта
			LDI		R17,MedByte		; Нашей выдержки
			LDI		R18,HighByte
 
loop:		SUBI	R16,1			; Вычитаем 1
			SBCI	R17,0			; Вычитаем только С
			SBCI	R18,0			; Вычитаем только С
 
			BRCC	Loop 			; Если нет переноса - переход




uart_snt:	SBIS 	UCSRA,UDRE		; Пропуск если нет флага готовности
			RJMP	PC-1 			; ждем готовности - флага UDRE

			OUT		UDR, R16		; шлем байт
			RET


uart_rcv:	SBIS	UCSRA,RXC
			RJMP	uart_rcv

			IN		R16,UDR
			RET


; End Procedure ================================================
;------------------------------------------------------------
;-- Interrupts --
;------------------------------------------------------------
iINT0:		RETI
iINT1:		RETI
iT2comp:	RETI
iT2ovf:		RETI
iT1capt:	RETI
iT1compA:	RETI
iT1compB:	RETI
iT1ovf:		RETI
iT0ovf:		RETI
iSPIstc:	RETI
iUSARTrxc:	RJMP	RX_OK
iUSARTudre:	RJMP	UD_OK
iUSARTtxc:	RJMP	TX_OK
iADCcompl:	RETI
iEErdy:		RETI
iAcomp:		RETI
iTWI:		RETI
iSPMrdy:	RETI
;------------------------------------------------------------



; EEPROM =====================================================
			.ESEG				; Сегмент EEPROM
