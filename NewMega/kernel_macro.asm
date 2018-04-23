;==========================================================================
;Kernel Macro
;==========================================================================
		.MACRO SetTimerTask
		ldi 	OSRG, @0
		ldi 	XL, Low(@1)			;
		ldi 	XH, High(@1)			; ЗАдержка в милисекундах
		rcall 	SetTimer
		.ENDM

;==========================================================================

		.MACRO SetTask
		ldi OSRG, @0			; Обращение к процедуре через событийный диспетчер
		rcall SendTask				; 
		.ENDM

;==========================================================================

		.MACRO TimerService
			push 	OSRG
			in 		OSRG,SREG			; Save Sreg
			push 	OSRG				; Сохранение регистра OSRG и регистра состояния SREG

			push 	ZL	
			push 	ZH					; сохранение Регистра Z
			push 	Counter				; сохранение Регистра Counter
	
			ldi 	ZL,low(TimersPool)	; Загрузка с регистр Z адреса RAM, 
			ldi 	ZH,high(TimersPool); по которому находится информация о таймерах

			ldi 	Counter,TimersPoolSize ; максимальное количество таймеров
	
Comp1L01:	ld 		OSRG,Z				; OSRG = [Z] ; Получить номер события
			cpi 	OSRG,$FF			; Проверить на "NOP"
			breq 	Comp1L03			; Если NOP то переход к следующей позиции

			clt							; Флаг T используется для сохранения информации об окончании счёта
			ldd 	OSRG,Z+1			; 
			subi 	OSRG,Low(1) 		; Уменьшение младшей части счётчика на 1
			std 	Z+1,OSRG			;
			breq 	Comp1L02			; Если 0 то флаг T не устанавливаем
			set							; 

Comp1L02:	ldd 	OSRG,Z+2			;
			sbci 	OSRG,High(1) 		; Уменьшение старшей части счётчика на 1
			std 	Z+2,OSRG			;
			brne 	Comp1L03			; Счёт не окончен
			brts 	Comp1L03			; Счёт не окончен (по T)	
	
			ld 		OSRG,Z				; Получить номер события
			rcall 	SendTask			; послать в системную очередь задач
	
			ldi 	OSRG,$FF			; = NOP (задача выполнена, таймер самоудаляется)
			st 		Z, OSRG				; Clear Event

Comp1L03:	subi 	ZL,Low(-3)			; Skip Counter
			sbci 	ZH,High(-3)			; Z+=3 - переход к следующему таймеру
			dec 	Counter				; счетчик таймеров
			brne 	Comp1L01			; Loop	

			pop 	Counter				; восстанавливаем переменные
			pop 	ZH
			pop 	ZL

			pop 	OSRG				; Восстанавливаем регистры
			out 	SREG,OSRG			; 
			pop 	OSRG
			.ENDM

;======================================================================================
			.MACRO	INIT_RTOS
			ldi OSRG, 0x00
			out SREG, OSRG			; Инициализация SREG 

			rcall ClearTimers		; Очистить список таймеров РТОС
			rcall ClearTaskQueue	; Очистить очередь событий РТОС
			sei						; Разрешить обработку прерываний

; Init Timer 2
; Основной таймер для ядра РТОС

			.equ MainClock 		= 8000000				; CPU Clock
			.equ TimerDivider 	= MainClock/64/1000 	; 1 mS


			ldi OSRG,1<<CTC2|4<<CS20	; Freq = CK/64 - Установить режим и предделитель
			out TCCR2,OSRG				; Автосброс после достижения регистра сравнения

			clr OSRG					; Установить начальное значение счётчиков
			out TCNT2,OSRG				;	
			

			ldi OSRG,low(TimerDivider)
			out OCR2,OSRG				; Установить значение в регистр сравнения
			.ENDM
;=======================================================================================
;SRAM STS analog for Tiny
			.MACRO	LDR
			PUSH	ZL
			PUSH	ZH

			LDI		ZL,low(@1)
			LDI		ZH,High(@1)

			LD		@0,Z

			POP		ZH
			POP		ZL
			.ENDM



			.MACRO	STR
			PUSH	ZL
			PUSH	ZH

			LDI		ZL,low(@0)
			LDI		ZH,High(@0)

			ST		Z,@1

			POP		ZH
			POP		ZL
			.ENDM

;=======================================================================================
;FLASH
			.MACRO	LDF
			PUSH	ZL
			PUSH	ZH

			LDI		ZL,low(@1*2)
			LDI		ZH,High(@1*2)

			LPM		@0,Z

			POP		ZH
			POP		ZL
			.ENDM

			.MACRO	LDPA
			LDI		ZL,low(@0*2)
			LDI		ZH,High(@0*2)
			.ENDM
;========================================================================================
;XYZ
			.MACRO	LDX
			LDI		XL,low(@0)
			LDI		XH,High(@0)
			.ENDM

			.MACRO	LDY
			LDI		YL,low(@0)
			LDI		YH,High(@0)
			.ENDM

			.MACRO	LDZ
			LDI		ZL,low(@0)
			LDI		ZH,High(@0)
			.ENDM

;========================================================================================
;USART INIT


			.MACRO	USART_INIT

			.equ XTAL 			= MainClock
			.equ baudrate 		= 19200
			.equ bauddivider 	= XTAL/(16*baudrate)-1

			
			OUTI 	UBRRL,low(bauddivider)
			OUTI 	UBRRH,high(bauddivider)
			OUTI 	UCSRA, 0
			OUTI 	UCSRB,(1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)
			OUTI 	UCSRC,(1<<URSEL)|(1<<UCSZ0)|(1<<UCSZ1)
			.ENDM
