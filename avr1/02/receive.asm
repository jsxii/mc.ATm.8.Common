; Данная программа написана для микроконтроллера atmega8.
; Частота генератора 8МГц.
; Устройство состоит из светодиода, atmega8 и NRD24l01.
; По приходу байта срабатывает прерывание по выводу IRQ, проверяется значение
; полученного байта, а дальше если 1 то включаетс светодиод, если 2 то выключается.
		.include	"m8def.inc"

		.equ	CE = PC0		; указываем какие выводы куда подключены
		.equ	pCE = portC		; порты в том числе
		.equ	dCE = ddrC
		.equ	CSN = PD6
		.equ	pCSN = portD
		.equ	dCSN = ddrD
		.equ	IRQ = PB1
		.equ	pIRQ = portB
		.equ	pinIRQ = pinB
		.equ	led = PC3		;вывод светодиода (анод к питанию, катотд к ноге led)
		.equ	dLED = ddrC

		.dseg
		.org	0x0000
		rjmp	Start

		.org	INT_VECTORS_SIZE
Start:
		;Стек в конец памяти (нужно для работы команды ret):
		ldi r16,high(RAMEND)
		out SPH,r16
		ldi r16,low(RAMEND)
		out SPL,r16
		;Инициилизация SPI:
		ldi r16,(1<<PB3)|(1<<PB5) ;mosi,sck на выход (обязательно)
		out ddrB,r16
		ldi r16,(0<<spie)|(1<<spe)|(1<<mstr)|(3<<spr0)	;(spie=1 прерывание после
		; передачи)(spe -вкл SPI)(mstr-мастер)(spr-частота 0-макс 3-мин)
		out SPCR,r16
		;Настройка портов:
		sbi pIRQ,IRQ	;вешаем подтяжку на IRQ
		sbi dCE,CE		;CE на выход
		sbi dCSN,CSN	;CSN на выход
		;Инициилизация NRF24L01 на приемник:
		ldi r16, 0x20		; Отправляем команду записи регистра конфигурации (CE и CSN уже опущены)
		rcall transmit_SPI
		ldi r16, 0b00001011	; Отправляем знчение байта конфигуорации (7 бит всегда 0)
		; (6=0 5=0 4=0-разрешить прерывание по приему, передаче, исчерпанию количества
		; попыток передачи соответственно)(3=1 использовать CRC)(2=0 CRC 1байт, 1- 2 байта)
		; (1=1 включить модуль)(0=0/1-режим передатчика/приемника)
		rcall transmit_SPI
		sbi pCSN,CSN		;поднимаем CSN - закончили передачу
		rcall delay			;задержка на всякий случай
		cbi portD,CSN		;снова опускаем CSN для
		ldi r16, 0x31		;записи байта RX_PW_P0
		rcall transmit_SPI
		ldi r16, 1			;принимать только 1 байт(можно от 1 до 32)
		rcall transmit_SPI
		sbi pCSN,CSN		;закончили
		sbi pCE,CE			;поднимаем CE, чтобы передатчик начал принимать данные

wait:
		sbis pinIRQ, IRQ	;ждем перывания о получении данных с модуля
		rjmp give_byte
		rjmp wait

give_byte:
		cbi pCE,CE		; не забываем опустить CЕ и CSN
		cbi pCSN,CSN
		ldi r16, 0x27		;Записываем в регистр статуса
		rcall transmit_SPI
		ldi r16, 0x40		;единицу на место флага прерывания по приходу байта, чтобы его сбросить
		rcall transmit_SPI
		sbi pCSN,CSN
		rcall delay			;задержка на всякий случай
		cbi pCSN,CSN
		ldi r16, 0x61		;отправялем кманду чтения из R_RX_PAYLOAD
		rcall transmit_SPI
		clr r16				;далее отпрвляем нулевой байт, чтобы получить значение R_RX_PAYLOAD
		rcall transmit_SPI
		sbi pCSN,CSN		;завершаем процедуру обмена по SPI
		sbi pCE,CE			;и снова разрешаем принимать данные
		in r16, SPDR		;считываем пришедший байт со значением R_RX_PAYLOAD
		cpi r16,1			;и сравниваем с 1
		brne off
		sbi dLED,led		;если да, то включаем светодиод
		rjmp wait
off:
		cpi r16,2			;сравниваем с 2
		brne wait
		cbi dLED,led		; если 2, то выключаем светодитод
		rjmp wait

transmit_SPI:
		out SPDR,r16	;отправляем данные на SPI
		; Wait_Transmit:
		; sbis SPSR,SPIF  --- по номальному надо смотреть пока не
		; поднимется флаг SPIF по завершению передачи, но он что то поднимался
		; через раз и контроллер зависал на этом месте.
		; rjmp Wait_Transmit			--- если у кого заработает, то смело удаляем
		; строчку ниже и не забываем раскомментирвать эти 2.
		rcall delay		; так что просто поставил задержку с нехилым таким запасом
		ret
delay:
		ldi r17, 255	; собственно вот и сама задержка, на 8МГц это чуть больше 2х
		; миллисекунд, конечноможно и убавить если нужно быстрее, но и так все работает
		ldi r18, 25
ddd:
		dec r17
		brne ddd
		dec r18
		brne ddd
		ret
