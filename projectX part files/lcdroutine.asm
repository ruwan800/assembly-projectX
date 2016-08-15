


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


