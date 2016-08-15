;m1 m0 t2,t1,t0

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
