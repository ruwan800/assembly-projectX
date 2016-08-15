;init asm(function of project-X)

init:
	BANKSEL	TRISA
	BSF	TRISA,1
	CLRF	TRISB
	CLRF	TRISD
	BANKSEL	PORTB
	CLRF	PORTB
	CLRF	PORTD
	BANKSEL	TRISC		;configure pins for serial transmitting
	BCF	TRISC,6		;c6=0 as output
	BSF	TRISC,7		;c7=1 as input
	
timerinit:
	BANKSEL	INTCON
	CLRF	INTCON
	BSF	INTCON,GIE
	BANKSEL	OPTION_REG	
	MOVLW	C0
	MOVWF	OPTION_REG
	
adinit:
	BANKSEL	ADCON1
	MOVLW	0x0E
	MOVWF	ADCON1
	BANKSEL	ADCON0
	MOVLW	0x41	;godone bit not set here
	MOVWF	ADCON0
		
lcdinit:
	CALL	delay100ms
	MOVLW	0x0030	;setting function set
	CALL	cmd
	MOVLW	0x0030	;setting function set
	CALL	cmd
	MOVLW	0x0030	;setting function set
	CALL	cmd
	MOVLW	0x0038	;setting function set
	CALL	cmd
	MOVLW	0x000C	;display ON/OFF control[1,display on,curser off,blinck off]
	CALL	cmd
	MOVLW	0x0006	;entry mode set[1,increment on,display shift off]
	CALL	cmd
	MOVLW	0x0001	;clear display
	CALL	cmd

usartinit:
	BANKSEL	RCSTA
	BSF	RCSTA,SPEN
	BANKSEL	TXSTA
	BSF	TXSTA,TXEN
	BSF	TXSTA,BRGH
	BANKSEL	SPBRG		;setting up baud rate
	MOVLW	D'25'
	MOVWF	SPBRG
	


