			.CSEG
			.ORG 	0x0000
			RJMP 	Reset	


; “ут распологаетс€ таблица векторов важнейша€ вещь. ≈сли про нее забыть, то
; можно огрести такие неразрешимые глюки, что просто капец. “ак что не забываем.
; € его тупо скопировал из файла m8def.inc и заменил все .equ на .org, а потом
; дописал везде команду RETI. Ќа случай если прерывание вдруг вылезет, чтобы 
; вернулось туда же откуда прервалось. 

			.ORG	INT0addr		; External Interrupt Request 0
			RETI
			.ORG	INT1addr		; External Interrupt Request 1
			RETI
			.ORG	OC2addr			; Timer/Counter2 Compare Match
			RJMP	OutComp2Int
			.ORG	OVF2addr		; Timer/Counter2 Overflow
			RETI
			.ORG	ICP1addr		; Timer/Counter1 Capture Event
			RETI
			.ORG	OC1Aaddr		; Timer/Counter1 Compare Match A
			RETI
			.ORG	OC1Baddr		; Timer/Counter1 Compare Match B
			RETI
			.ORG	OVF1addr		; Timer/Counter1 Overflow
			RETI
			.ORG	OVF0addr		; Timer/Counter0 Overflow
			RETI
			.ORG	SPIaddr			; Serial Transfer Complete
			RETI
			.ORG	URXCaddr		; USART, Rx Complete
			RJMP	Uart_RCV
			.ORG	UDREaddr		; USART Data Register Empty
			RETI
			.ORG	UTXCaddr		; USART, Tx Complete
			RETI
			.ORG	ADCCaddr		; ADC Conversion Complete
			RJMP	ADC_OK
			.ORG	ERDYaddr		; EEPROM Ready
			RETI
			.ORG	ACIaddr			; Analog Comparator
			RETI
			.ORG	TWIaddr			; 2-wire Serial Interface
			RETI
			.ORG	SPMRaddr		; Store Program Memory Ready
			RETI

			.ORG	INT_VECTORS_SIZE		;  онец таблицы прерываний
