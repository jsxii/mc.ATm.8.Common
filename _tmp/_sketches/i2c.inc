; = TWCR - TWi Control Register
;7. TWINT — флаг прерывания. Сброс его означает что конечный автомат провернется дальше, а прерывание будет снова уловлено.
;6. TWEA — Enable ACK. Разрешение ответа ACK. Если его включить, то автомат TWI будет отзываться на свой адрес, а также давать ACK во всех случаях когда этого требует протокол. Скажем, после прием байта. Если нам надо послать NACK то бит не ставим.
;5. TWSTA — Сформировать старт. Причем не факт, что прямо сейчас. От текущего состояния зависит. Например, если этот бит поставить в 0х38 состоянии, то старт будет сформирован когда шина освободится. Контроллер TWI умный и сам все хорошо знает.
;4. TWSTO — сделать Stop. Опять же аналогично. После записи в этот бит модуль отваливается от сессии передачи. МК становится неадресованным ведомым.
;3. TWWC — конфликт записи. Сигнализирует о том, что кто то из прикладной программы записал в TWDR данные. Тогда как в TWDR полагается писать только при поднятом TWINT (в нашем случае это будет толкьо в обработчике прерывания).
;2. TWEN — блок TWI включен. Только и всего.
;0. TWIE — прерывания от TWI разрешены.

; = TWSR
;============================================================
int00:	; Bus Error
	RCALL	ErrorBusError
	RCALL	SetRepeatTransaction
	RET
int38:	; Collision
	RCALL	ErrorCollision
	RCALL	SetRepeatTransaction
	RET
;============================================================
int08:	; Start completed
int10:	; RepeatStart completed
	LDI	R16,<SLA+W/SLA+R>
	OUT	TWDR,R16
	LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
	OUT	TWCR,R16
	RET
int18:	; SLA+W=ACK
	LD	R16,<DATA>
	OUT	TWDR,R16
	LDI	R16, 0b10000101	; Set TWIE, TWEN, TWINT
	OUT	TWCR,R16
	RET
int20:	; SLA+W=NACK
	RCALL	ErrorNoAnswer
	RET
int28:	; SendByte=ACK
SndToo:	RJMP	int18
SndEnd:	LDI	R16, 0b10010101	; Set TWIE, TWEN, TWINT, TWSTO
	OUT	TWCR,R16	; Send Stop
	RCALL	SuccesfulTransmitted
int30:	; SendByte=NACK
	RCALL	ErrorNoAckReceived
	RET
;============================================================
