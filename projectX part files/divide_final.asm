; t8:t7:t6/tcounth:tcountl=[m1.m0]
;this is specified divide function
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
DVLP:	DECFSZ	t0,F
	GOTO	DVLP1
	RETURN
