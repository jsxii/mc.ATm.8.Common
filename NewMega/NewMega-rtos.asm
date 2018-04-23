			.include "m8def.inc"	; Используем ATMega8
			.include "define.asm"

			.include "macro.asm"	; Все макросы у нас тут
			.include "kernel_macro.asm"


			.DSEG
R_flag:		.byte	1


			.equ 	TaskQueueSize = 11	; Размер очереди событий
TaskQueue: 	.byte 	TaskQueueSize 		; Адрес очереди сотытий в SRAM
			.equ 	TimersPoolSize = 5	; Количество таймеров
TimersPool:	.byte 	TimersPoolSize*3	; Адреса информации о таймерах


;===========.CSEG===============================================================
			.include "vectors.asm"
			
; Interrupts procs
; Output Compare 2 interrupt  - прерывание по совпадению TCNT2 и OCR2
; Main Timer Service - Служба Таймеров Ядра - Обработчик прерывания
OutComp2Int: TimerService	
			RETI	
;------------------------------------------------------------------------------
ADC_OK:		push 	OSRG
			in 		OSRG,SREG		; Спасаем OSRG и флаги. 
			push 	OSRG		


			IN		OSRG,ADCH		; Взять показание АЦП
			CPI		OSRG,Treshold	; Сравнить с порогом
			BRSH	EXIT_ADC		; Если не достигнут выход

			SetTask	TS_OnRed		; Запускаем мырг красным
			
EXIT_ADC:	pop 	OSRG			; Восстанавливаем регистры
			out 	SREG,OSRG		 
			pop 	OSRG
			RETI					; Выходим из прерывания
;--------------------------------------------------------------------------------
Uart_RCV:	push 	OSRG
			in 		OSRG,SREG	; Спасаем OSRG и флаги. 
			push 	OSRG	
			PUSH	XL			; SetTimerTask юзает Х!!!
			PUSH	XH			; Поэтому прячем его!
			PUSH	Tmp2		; Ну и Tmp2 нам пригодится

			OUTI	UDR,'U'

			IN 		OSRG,UDR
			CPI		OSRG,'R'	; Проверяем принятый байт
			BREQ	Armed		; Если = R  - идем взводить флаг

			LDS		Tmp2,R_flag	; Если не R и флага готовности нет
			CPI		Tmp2,0		
			BREQ	U_RCV_EXIT	; То переход на выход

			CPI		OSRG,'A'		; Мы готовы. Это 'А'?	
			BRNE	U_RCV_EXIT	; Нет? Тогда выход!

			SetTask	TS_OnWhite	; Зажечь бело-лунный!

U_RCV_EXIT:	POP		Tmp2
			POP 	XH			; Процедура выхода из прерывания
			POP		XL
			pop 	OSRG		; Восстанавливаем регистры
			out 	SREG,OSRG		 
			pop 	OSRG
			RETI				; <<<<<< Выходим

Armed:		LDI		OSRG,1		; Взводим флаг готовности
			STS		R_flag,OSRG	; Сохраняем его в ОЗУ


			SetTimerTask	TS_ResetR,10

			RJMP	U_RCV_EXIT	; Переход к выходу

;==============================================================================
;Main Code Here

Reset:		OUTI 	SPL,low(RAMEND) 		; Первым делом инициализируем стек
			OUTI	SPH,High(RAMEND)								

			.include "init.asm"				; Все инициализации тут.

Background:	RCALL 	OnGreen
			RCALL	ADC_CHK


Main:		SEI								; Разрешаем прерывания.

			wdr								; Reset Watch DOG (Если не "погладить" "собаку". то она устроит конец света в виде reset для процессора)
			rcall 	ProcessTaskQueue		; Обработка очереди процессов
			rcall 	Idle					; Простой Ядра
											
			rjmp 	Main					; Основной цикл микроядра РТОС


;=============================================================================
;Tasks
;=============================================================================
Idle:		RET
;-----------------------------------------------------------------------------
OnGreen:	SBI		PORTB,1		; Зажечь зеленый
			SetTimerTask	TS_OffGreen,500
			RET
;-----------------------------------------------------------------------------
OffGreen:	CBI 	PORTB,1		; Погасить зеленый
			SetTimerTask	TS_OnGreen,500
			RET
;-----------------------------------------------------------------------------
ADC_CHK:	SetTimerTask	TS_ADC_CHK,1000
			OUTI	ADCSRA,1<<ADEN|1<<ADIE|1<<ADSC|3<<ADPS0
			RET
;-----------------------------------------------------------------------------
OnRed:		SBI		PORTB,2
			SetTimerTask	TS_OffRed,300
			RET
;-----------------------------------------------------------------------------
OffRed:		CBI		PORTB,2
			RET
;--------------------------------------------------------------------------------------
OnWhite:	SBI		PORTB,3
			SetTimerTask	TS_OffWhite,1000
			RET
;--------------------------------------------------------------------------------------
OffWhite:	CBI		PORTB,3
			RET
;-----------------------------------------------------------------------------
ResetR:		CLR		OSRG
			STS		R_Flag,OSRG
			RET
;-----------------------------------------------------------------------------
Task9:		RET



;=============================================================================
; RTOS Here
;=============================================================================
			.include "kerneldef.asm"	; Подключаем настройки ядра
			.include "kernel.asm"		; Подклчюаем ядро ОС

TaskProcs: 	.dw Idle					; [00] 
			.dw OnGreen					; [01] 
			.dw OffGreen				; [02] 
			.dw ADC_CHK					; [03] 
			.dw OnRed 					; [04] 
			.dw OffRed					; [05] 
			.dw OnWhite					; [06] 
			.dw OffWhite				; [07] 
			.dw ResetR				 	; [08]
			.dw	Task9					; [09]
				
