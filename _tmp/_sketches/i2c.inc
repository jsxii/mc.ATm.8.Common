; = TWCR - TWi Control Register
;7. TWINT � ���� ����������. ����� ��� �������� ��� �������� ������� ����������� ������, � ���������� ����� ����� ��������.
;6. TWEA � Enable ACK. ���������� ������ ACK. ���� ��� ��������, �� ������� TWI ����� ���������� �� ���� �����, � ����� ������ ACK �� ���� ������� ����� ����� ������� ��������. ������, ����� ����� �����. ���� ��� ���� ������� NACK �� ��� �� ������.
;5. TWSTA � ������������ �����. ������ �� ����, ��� ����� ������. �� �������� ��������� �������. ��������, ���� ���� ��� ��������� � 0�38 ���������, �� ����� ����� ����������� ����� ���� �����������. ���������� TWI ����� � ��� ��� ������ �����.
;4. TWSTO � ������� Stop. ����� �� ����������. ����� ������ � ���� ��� ������ ������������ �� ������ ��������. �� ���������� �������������� �������.
;3. TWWC � �������� ������. ������������� � ���, ��� ��� �� �� ���������� ��������� ������� � TWDR ������. ����� ��� � TWDR ���������� ������ ������ ��� �������� TWINT (� ����� ������ ��� ����� ������ � ����������� ����������).
;2. TWEN � ���� TWI �������. ������ � �����.
;0. TWIE � ���������� �� TWI ���������.

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
