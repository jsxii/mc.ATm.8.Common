			.include "m8def.inc"	; ���������� ATMega8
			.include "define.asm"

			.include "macro.asm"	; ��� ������� � ��� ���
			.include "kernel_macro.asm"


			.DSEG
R_flag:		.byte	1


			.equ 	TaskQueueSize = 11	; ������ ������� �������
TaskQueue: 	.byte 	TaskQueueSize 		; ����� ������� ������� � SRAM
			.equ 	TimersPoolSize = 5	; ���������� ��������
TimersPool:	.byte 	TimersPoolSize*3	; ������ ���������� � ��������


;===========.CSEG===============================================================
			.include "vectors.asm"
			
; Interrupts procs
; Output Compare 2 interrupt  - ���������� �� ���������� TCNT2 � OCR2
; Main Timer Service - ������ �������� ���� - ���������� ����������
OutComp2Int: TimerService	
			RETI	
;------------------------------------------------------------------------------
ADC_OK:		push 	OSRG
			in 		OSRG,SREG		; ������� OSRG � �����. 
			push 	OSRG		


			IN		OSRG,ADCH		; ����� ��������� ���
			CPI		OSRG,Treshold	; �������� � �������
			BRSH	EXIT_ADC		; ���� �� ��������� �����

			SetTask	TS_OnRed		; ��������� ���� �������
			
EXIT_ADC:	pop 	OSRG			; ��������������� ��������
			out 	SREG,OSRG		 
			pop 	OSRG
			RETI					; ������� �� ����������
;--------------------------------------------------------------------------------
Uart_RCV:	push 	OSRG
			in 		OSRG,SREG	; ������� OSRG � �����. 
			push 	OSRG	
			PUSH	XL			; SetTimerTask ����� �!!!
			PUSH	XH			; ������� ������ ���!
			PUSH	Tmp2		; �� � Tmp2 ��� ����������

			OUTI	UDR,'U'

			IN 		OSRG,UDR
			CPI		OSRG,'R'	; ��������� �������� ����
			BREQ	Armed		; ���� = R  - ���� �������� ����

			LDS		Tmp2,R_flag	; ���� �� R � ����� ���������� ���
			CPI		Tmp2,0		
			BREQ	U_RCV_EXIT	; �� ������� �� �����

			CPI		OSRG,'A'		; �� ������. ��� '�'?	
			BRNE	U_RCV_EXIT	; ���? ����� �����!

			SetTask	TS_OnWhite	; ������ ����-������!

U_RCV_EXIT:	POP		Tmp2
			POP 	XH			; ��������� ������ �� ����������
			POP		XL
			pop 	OSRG		; ��������������� ��������
			out 	SREG,OSRG		 
			pop 	OSRG
			RETI				; <<<<<< �������

Armed:		LDI		OSRG,1		; ������� ���� ����������
			STS		R_flag,OSRG	; ��������� ��� � ���


			SetTimerTask	TS_ResetR,10

			RJMP	U_RCV_EXIT	; ������� � ������

;==============================================================================
;Main Code Here

Reset:		OUTI 	SPL,low(RAMEND) 		; ������ ����� �������������� ����
			OUTI	SPH,High(RAMEND)								

			.include "init.asm"				; ��� ������������� ���.

Background:	RCALL 	OnGreen
			RCALL	ADC_CHK


Main:		SEI								; ��������� ����������.

			wdr								; Reset Watch DOG (���� �� "���������" "������". �� ��� ������� ����� ����� � ���� reset ��� ����������)
			rcall 	ProcessTaskQueue		; ��������� ������� ���������
			rcall 	Idle					; ������� ����
											
			rjmp 	Main					; �������� ���� ��������� ����


;=============================================================================
;Tasks
;=============================================================================
Idle:		RET
;-----------------------------------------------------------------------------
OnGreen:	SBI		PORTB,1		; ������ �������
			SetTimerTask	TS_OffGreen,500
			RET
;-----------------------------------------------------------------------------
OffGreen:	CBI 	PORTB,1		; �������� �������
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
			.include "kerneldef.asm"	; ���������� ��������� ����
			.include "kernel.asm"		; ���������� ���� ��

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
				
