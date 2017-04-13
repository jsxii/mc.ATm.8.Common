;============================================================
; Sub			; Input ; Output ; Used ; Remark
;------------------------------------------------------------
; Disp.MainCycle	; void ; void ; [ Any ] ; 
; Disp.SetTask		; R17=TaskId,R18=Param ; void ; [ R16,Z ] ; BSOD if queue full.
; Disp.GetTask		; void ; R17=taskId,R18=Param ; [ R16,Z ] ;
; Disp.GetTaskAddress	; R17=TaskId ; Z=TaskAddress ; [ R16 ] ;
; Disp.TaskQueueInit	; void ; void ; [ Z ] ;
; Disp.BSOD		; R17=ErrCode ; void ; [ - ] ; <STOP>
;------------------------------------------------------------
; Timer.TaskTimerInit	; void ; void ; [ R16,Z ] ; Init & start timer0
; Timer.TimerQueueInt	; void ; void ; [--] ; ISR
; Timer.SetTaskOnTimer	; R17=status ; R17=TaskId,R18=Param,R19=CounterLow,R20=CounterHigh ; [ R16,Z ] ; Set task to TimerQueue ; 0x00 -Success, 0x01 - no slot.
;------------------------------------------------------------
; WDTon		; void ; void ; [ R16 ] ;
; WDToff	; void ; void ; [ R16 ] ;
;------------------------------------------------------------
; CheckReset	; void ; void ; [ - ] ;
;------------------------------------------------------------
