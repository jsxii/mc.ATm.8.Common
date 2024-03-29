; Данный код написан для микроконтроллера atmega88, но должен так же работать
; на других контроллерах серии atmega, так как использованы стандартные команды.
; Устройство представляет собой конструкцию из 2х кнопок, atmega88 и приемопередатчика NRF24l01
; Задержки настроены под частоту 8Мгц, если частота будет ниже то будет работать,
; если выше, то нужно откорректировать  задержку в Send_byte, а то будет меньше 10мкс.
; При нажатии на кнопку 1 передатчик отсылает байт со значением 0х01, а при
; нажатии кнопки 2 0х02.
; При желании все задержки переделываются на прерывания, но в данном случае
; контроллеру все равно делать больше нечего.

		.include	"m8def.inc"

		.equ	CE	= PC2				;здесь нужно указать куда подключены выводы приемопередатчика CE
		.equ	pCE	= portC
		.equ	dCE	= ddrC
		.equ	CSN	= PB2				;и CSN
		.equ	pCSN	= portB
		.equ	dCSN	= ddrB
		.equ	Button1	= PD2			;в том числе и кнопки
		.equ	pButton1	= portD
		.equ	pinButton1	= pinD
		.equ	Button2	= PD3
		.equ	pButton2	= portD
		.equ	pinButton2	= pinD

		.dseg
		.org	0x0000
		rjmp	Start

		.org	INT_VECTORS_SIZE
Start:
		;Стек в конец памяти:
		ldi r16,high(RAMEND)
		out SPH,r16
		ldi r16,low(RAMEND)
		out SPL,r16
		;Инициилизация SPI:
		ldi r16,(1<<PB3)|(1<<PB5) ;mosi,sck на выход (обязательно)
		out ddrB,r16
		sbi dCSN,CSN		;CSN на выход
		sbi pCSN,CSN		;CSN лог 1 (этот вывод нужно опускать только на время передачи данных)
		sbi dCE,CE			;CE на выход	(в даташите написано, что лучше его держать поднятым)
		ldi r16,(1<<spie)|(1<<spe)|(1<<mstr)|(3<<spr0)	;(spie=1 прерывание после передачи)
		; (spe -вкл SPI)(mstr-мастер)(spr-частота 0-макс 3-мин)
		out SPCR,r16
		;Настройка кнопок
		sbi pButton1,Button1 ;Резистор подтяжки
		sbi pButton2,Button2 ;Резистор подтяжки
		;Инициилизация NRF24L01 на передатчик
		cbi pCE,CE			;опустить СЕ
		cbi pCSN,CSN		; и CSN
		ldi r16, 0x20		; байт с инструкцией записи регистра статуса
		rcall transmit_SPI	; отправляем по SPI
		ldi r16, 0b00001010	; собственно сам байт который нужно записать (все
		; прерывания разрешены, CRC вкл - 1байт, включить модуль, режим передатчика)
		rcall transmit_SPI
		sbi pCSN,CSN		; конец передачи, поднимаем CSN
		sbi pCE,CE			; и CE на всякий случай

wait:
		sbis pinButton1,Button1		;отправить 1 по нажатию кнопки (кнопка замыкает пин на землю)
		rjmp send_1
		sbis pinButton2,Button2		;отправить 2 по нажатию кнопки (аналогично)
		rjmp send_2
		RJMP	wait

send_1:
		ldi r17,1					;Записываем в r17 единицу
		rcall Send_byte				; и отправляем ее
check1:
		sbis pinButton1,Button1	;ждем отпускания кнопки 1, чтобы случайно не отправить сто тыщ раз
		rjmp check1
		rcall delay					;антидребезг
		rjmp wait

send_2:
		ldi r17,2					;тут все аналогично, только шлем двойку
		rcall Send_byte
check2:
		sbis pinButton2,Button2	;ждем отпускания кнопки 2
		rjmp check2
		rcall delay
		rjmp wait

Send_byte:
		cbi pCE, CE			;данная подпрограмма отправляет байт содержащийся в r17,
		; при желании можно организовать передачу до 32 байт за раз (тут только 1)
		cbi pCSN,CSN			;начианаем передачу по SPI
		ldi	R16, 0b10100000		; отправляем команду записи на W_TX_PAYLOAD
		rcall transmit_SPI
		mov	R16, r17			;байт из r17
		rcall transmit_SPI		; отправляем следом
		; тут можно дописать отправку еще 31 байта например:
		;mov	R16, r18		;следом полетит r18
		;rcall transmit_SPI
		;но стоит учесть что применик должен знать сколько байт ловить.
		sbi pCSN,CSN			; и завершаем передачу поднятием
		sbi pCE, CE				; дергаем СЕ на 10-15мкс:
		ldi r16, 30				; Задержка на примерно 12мкс
d10:
		dec r16
		brne d10
		cbi pCE, CE
		rcall delay				;ждем какое то вреия пока данные передадутся (по-нормальному,
		; надо использовать прерывание IRQ, но c задержкой проще)
		sbi pCE, CE				;поднимаем CE обратно
		ret
transmit_SPI:
		out SPDR,r16			;отправляем данные на SPI и далее ждем пока байт отправится
Wait_Transmit:
		in r19, SPSR	;на atmega88 нельзя использовать sbis для провеки SPIF, поэтому
		; проверка таким образом. но на atmega8 тоже должно работать
		andi r19,1<<SPIF			;если флаг SPIF=0
		breq Wait_Transmit			;то ждем дальше
		ret

delay:
		ldi r17, 255			;стандартная задержка
		ldi r18, 25
ddd:
		dec r17
		brne ddd
		dec r18
		brne ddd
		ret

; Cтоит добавить, что не отслеживается флаг MAX_RT который устанавливается при
; исчерпании количества попыток, после чего данные перестают отправляться, его
; нужно каждый раз сбрасывать вручную либо использовать REUSE_TX_PL, но если
; быстро не отправлять данные то проблем не возникнет.
