
ORG	0x0004
		;interrupt here
		;interrupt.asm
;######################################################################

main:
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

;######################################################################
	
welcome:
	MOVLW	msg0
	CALL	sendmsg
WCMF0:	MOVLW	0xC0
	CALL	cmd
	MOVLW	0x10
	MOVWF	msgptr
	MOVLW	0x03
	MOVWF	txchk
WCMF1:	MOVLW	0xFF
	CALL	sendchar
	DECFSZ	msgptr,F
	GOTO	WCMF1
	MOVLW	0xC0
	CALL	cmd
	MOVLW	0x19
	MOVWF	msgptr
WCMF2:	MOVLW	0x20
	CALL	sendchar
	DECFSZ	msgptr,F
	GOTO	WCMF2
	DECFSZ	txchk
	GOTO	WCMF0

;######################################################################

xvoltage:
	CLRF	counth
	CLRF	countl
	MOVLW	0xFF
	MOVWF	lowvolt
XVLT0:	CALL	inf
	MOVF	tdatah,W
	SUBWF	highvolt,W
	BTFSC	bitc
	GOTO	XVLT2
	MOVF	tdatah,W
	MOVWF	highvolt
XVLT2:	MOVF	lowvolt,W
	SUBWF	tdatah,W
	BTFSC	bitc
	GOTO	XVLT3
	MOVF	tdatah,W
	MOVWF	lowvolt
XVLT3:	BTFSS	counth,7
	GOTO	XVLT0	
	MOVF	lowvolt,W
	SUBWF	highvolt,W
	MOVWF	margin
	SUBLW	0x10
	BTFSC	bitc
	GOTO	xvoltage
	BCF	bitc
	RRF	margin,F
	BCF	bitc
	RRF	margin,F
	MOVF	margin,W
	SUBWF	highvolt,W
	MOVWF	margin

;######################################################################

usartcheck:
	CLRF	txchk
	CLRF	txchk1
	BSF	txchk,7
	BSF	txchk1,6
TXCF2:	BANKSEL	TXSTA
	BTFSS	TXSTA,TRMT
	GOTO	TXCF1
	MOVLW	0xFF
	MOVWF	TXREG
	DECFSZ	txchk1,F
	GOTO	TXCF1
	MOVLW	msg6
	CALL	sendmsg
	GOTO	usartroutine
TXCF1:	DECFSZ	txchk,F
	GOTO	TXCF2
	BANKSEL	TXSTA
	BCF	TXSTA,TXEN
	GOTO	LCDF

;######################################################################

usartroutine:
	CLRF	txchk
	BSF	txchk,7
TXRF0:	BANKSEL	TXSTA
	BTFSC	TXSTA,TRMT
	GOTO	TXRF2
	DECFSZ	txchk,F
	GOTO	TXRF0	
	MOVLW	msg1
	CALL	sendmsg
	GOTO	usartcheck
TXRF2:	MOVF	tdatah
	MOVWF	TXREG
	CLRF	txchk
	BSF	txchk,7
TXRF1:	BANKSEL	TXSTA
	BTFSC	TXSTA,TRMT
	GOTO	TXRF3
	DECFSZ	txchk,F
	GOTO	TXRF1	
	MOVLW	msg1
	CALL	sendmsg
	GOTO	usartcheck
TXRF3:	MOVF	tdatal
	MOVWF	TXREG
	CALL	inf
	GOTO	usartroutine

;######################################################################

LCDF:	BSF	meancount,3
	MOVLW	msg2
	CALL	sendmsg

lcdroutine:
	BSF	decerr,1
hpc:	MOVF	margin,W
	SUBWF	tdata,W
	BTFSS	bitc
	GOTO	HPCF0
	MOVF	counth,W
	SUBLW	0x06,W
	BTFSC	bitc
	GOTO	HPCF2
	MOVF	countl,W
	MOVWF	tcountl
	MOVF	counth,W
	MOVWF	tcounth
	CLRF	countl
	CLRF	counth
	CALL	inf
	GOTO	divide
HPCF0:	BTFSC	counth,7
	GOTO	HPCF2
	CALL	inf
	GOTO	hpc
HPCF2:	CLRF	countl
	CLRF	counth
	CALL	inf
	DECFSZ	decerr
	GOTO	hpc
	MOVLW	msg5
	CALL	sendmsg
	GOTO	xvoltage

;######################################################################

divide:	
	MOVLW	0x09
	MOVWF	t8
	MOVLW	0x27
	MOVWF	t7
	MOVLW	0xC0
	MOVWF	t6
	CLRF	m0	
	CLRF	m1
	CLRF	t0
	BSF	t0,4
DVLP1:	BCF	STATUS,C
	RLF	m0,F
	RLF	m1,F		
	RLF	t6,F
	RLF	t7,F
	RLF	t8,F
	MOVF	tcounth,W
	SUBWF	t8,W
	BTFSS	bitc
	GOTO	DVLP
	BTFSS	bitz
	GOTO	DVLP2
	MOVF	tcountl,W
	SUBWF	t7,W
	BTFSS	bitc
	GOTO	DVLP
DVLP2:	MOVF	tcountl,W
	SUBWF	t7,F
	BTFSS	bitc
	DECF	t8,F
	MOVF	tcounth,W
	SUBWF	t8,F	
	BSF	m0,0
	GOTO	DVLP
DVLP:	CALL	inf
	DECFSZ	t0,F
	GOTO	DVLP1

;######################################################################

getmean:
	MOVF	m0,W
	ADDWF	m2,F
	BTFSC	bitc
	INCF	m1,W
	ADDWF	m3,F
	RRF	m3,F
	RRF	m2,F	;ZZZZZ2
	MOVF	m2,W
	ADDWF	m4,F
	BTFSC	bitc
	INCF	m3,W
	ADDWF	m5,F
	RRF	m5,F
	RRF	m4,F	;ZZZZZ4
	MOVF	m4,W
	ADDWF	finalmeanf,F
	BTFSC	bitc
	INCF	m5,W
	ADDWF	finalmean,F
	RRF	finalmean,F
	RRF	finalmeanf,F	;ZZZZZ8
	MOVF	m0,W
	MOVWF	m2
	MOVF	m1,W
	MOVWF	m3
	MOVF	m2,W
	MOVWF	m4
	MOVF	m3,W
	MOVWF	m5
	MOVF	m4,W
	MOVWF	finalmeanf
	MOVF	m5,W
	MOVWF	finalmean
	DECFSZ	meancount,W
	GOTO	lcdroutine
	BSF	meancount,3
	MOVF	finalmean,W
	SUBLW	.100
	BTFSC	bitc
	BSF	bitbuzz
	MOVF	finalmean,W
	SUBLW	.60
	BTFSS	bitc
	BSF	bitbuzz
	GOTO	decimals

;######################################################################

decimals:
	CLRF	t1
	CLRF	t0
	MOVF	finalmean,W
	CALL	DECC
	CALL	inf
	MOVF	t1,W
	MOVWF	var2
	MOVF	t0,W
	CLRF	t1
	CLRF	t0
	CALL	DECC
	CALL	inf
	MOVF	t1,W
	MOVWF	var1
	MOVF	t0,W
	MOVWF	var0
	
	CLRW		;dividing stuff here
	BTFSC	finalmeanf,0
	ADDLW	.9
	BTFSC	finalmeanf,1
	ADDLW	.8
	BTFSC	finalmeanf,2
	ADDLW	.6
	BTFSC	finalmeanf,3
	ADDLW	.2
	BTFSC	finalmeanf,4
	ADDLW	.5
	ADDLW	.1
	CALL	DECC
	CALL	inf
	MOVF	t0,W
	CLRF	t0		;&&&&&&&&&&&&&&&
	BTFSC	finalmeanf,0
	ADDLW	.3
	BTFSC	finalmeanf,1
	ADDLW	.7
	BTFSC	finalmeanf,2
	ADDLW	.5
	BTFSC	finalmeanf,3
	ADDLW	.1
	BTFSC	finalmeanf,4
	ADDLW	.2
	BTFSC	finalmeanf,5
	ADDLW	.5
	CALL	DECC
	CALL	inf
	MOVF	t0,W
	CLRF	t0		;&&&&&&&&&&&&&&&
	BTFSC	finalmeanf,2
	ADDLW	.1
	BTFSC	finalmeanf,3
	ADDLW	.3
	BTFSC	finalmeanf,4
	ADDLW	.6
	BTFSC	finalmeanf,5
	ADDLW	.2
	BTFSC	finalmeanf,6
	ADDLW	.5
	CALL	DECC
	CALL	inf
	MOVF	t1,W
	MOVWF	var4
	MOVF	t0,W
	CLRF	t0		;&&&&&&&&&&&&&&&
	CLRF	t1
	BTFSC	finalmeanf,5
	ADDLW	.1
	BTFSC	finalmeanf,6
	ADDLW	.2
	BTFSC	finalmeanf,7
	ADDLW	.5
	MOVF	t1,W
	MOVWF	var3
	GOTO	sendxmsg

DECC:
	SUBLW	.10
	BTFSS	bitc
	RETURN
	MOVWF	t1
	INCF	t0,F
	GOTO	DECC

;######################################################################

sendxmsg:
	MOVLW	msg3
	CALL	sendmsg
	MOVLW	0x40
	CALL	sendvarmsg
	
lpc:	MOVF	counth,W
	SUBLW	0x05,W
	BTFSC	bitc
	GOTO	LPCF0
	MOVF	tdata,W
	SUBWF	margin,W
	BTFSS	bitc
	GOTO	LPCF1
	CALL	inf
	GOTO	lcdroutine
LPCF1:	BTFSC	counth,7
	GOTO	LPCF2
LPCF0:	CALL	inf
	GOTO	lpc
LPCF2:	MOVLW	msg5
	CALL	sendmsg
	GOTO	xvoltage

;######################################################################

sendmsg:			;starting register should loaded to msgptr
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

;######################################################################

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

;######################################################################

sendchar:			;send a character to LCD
	MOVWF	dataport
	NOP
	BSF	dataen		;select data registry
	signal			;signal enable macro
	NOP
	CLRF	dataport	;make all PORTB outputs low
	BCF	dataen		;select instruction registry
	CALL	inf
	RETURN

;######################################################################

cmd:	MOVWF	dataport	;send command to PORTB
	NOP
	signal			;signal enable macro
	CLRF	dataport	;make all PORTB outputs low
	CALL	inf
	RETURN

;######################################################################

inf:	BANKSEL	interren
BSF	interren
madinf:	NOP			;if interrupt not initialized return
	NOP
	NOP
	GOTO	madinf

END

;######################################################################
