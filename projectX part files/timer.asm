resettimer:
	MOVLW	0xD1
	MOVWF	TMR0
	BANKSEL	INTCON
	BCF	INTCON,T0IF
	BANKSEL	interren
	BCF	interren
timerinit:
	BANKSEL	INTCON
	CLRF	INTCON
	BSF	INTCON,GIE
	BANKSEL	OPTION_REG	
	MOVLW	C0
	MOVWF	OPTION_REG
