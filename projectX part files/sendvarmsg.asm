


sendvarmsg:
	MOVF	lcdptr,W	;starting register should loaded to msgptr
	ADDLW	0x80		;variable 'tempchar' used to handle a character
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
