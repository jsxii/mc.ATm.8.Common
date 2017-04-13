;============================================================
; Sub			; Input ; Output ; Used ; Remark
;------------------------------------------------------------
; Disp.BSOD		; R17=ErrCode ; void ; [ - ] ; <STOP>
; Disp.SetTask		; R17=TaskId,R18=Param ; void ; [ R16,Z ] ;
; Disp.GetTask		; void ; R17=taskId,R18=Param ; [ R16,Z ] ;
; Disp.GetTaskAddress	; R17=TaskId ; Z=TaskAddress ; [ R16 ] ;
; Disp.TaskQueueInit	; void ; void ; [ Z ] ;
;------------------------------------------------------------
