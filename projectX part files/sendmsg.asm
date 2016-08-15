





;this is a correct and easy file			
;copied from msgs.asm			
			
sendXmsg:			;starting register should loaded to msgptr
	MOVWF	msgptr		;variable 'tempchar' used to handle a character
	MOVF	msgptr,W	;'LINEMSGTEMP' function should be initialized near character data tables
	CALL	LINEMSGTEMP	;'sendchar' function used to send a character
	MOVWF	tempchar	;once called lineXsg function whole data table characters send to LCD
	INCF	msgptr,F
	MOVF	tempchar,W
	XORLW	0x5F
	BTFSC	bitz
	GOTO	NEWLINE
	MOVF	tempchar,W	
	XORLW	0x7C
	BTFSC	bitz
	RETURN
	MOVF	tempchar,W
	CALL	sendchar
	GOTO	sendmsg
NEWLINE:
	MOVLW	0x00C0
	CALL	cmd
	GOTO	sendmsg

sendvarmsg:
	MOVWF	lcdptr		;starting register should loaded to msgptr
	ADDLW	0x81		;variable 'tempchar' used to handle a character
	CALL	cmd		;'LINEMSGTEMP' function should be initialized near character data tables
	MOVF	var0,W		;'sendchar' function used to send a character
	XORLW	0x00		;once called lineXsg function whole data table characters send to LCD
	BTFSS	bitz		
	ADDLW	0x10
	ADDLW	0x20
	CALL	sendchar
	MOVF	var1,W
	ADDLW	0x30	
	CALL	sendchar
	MOVF	var2,W
	ADDLW	0x30	
	CALL	sendchar
	MOVLW	A'.'
	CALL	sendchar
	MOVF	var4,W
	ADDLW	0x30	
	CALL	sendchar	
	MOVF	var5,W
	ADDLW	0x30	
	CALL	sendchar
	RETURN
