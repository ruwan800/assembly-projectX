; t8:t7:t6/t2:t1=[t5.t4]
;this is specified divide function
divide:	
	CLRF	t4	
	CLRF	t5
	CLRF	t0
	BSF	t0,4
DVLP1:	BCF	STATUS,C
	RLF	t4,F
	RLF	t5,F		
	RLF	t6,F
	RLF	t7,F
	RLF	t8,F
	MOVF	t2,W
	SUBWF	t8,W
	BTFSS	bitc
	GOTO	DVLP
	BTFSS	bitz
	GOTO	DVLP2
	MOVF	t1,W
	SUBWF	t7,W
	BTFSS	bitc
	GOTO	DVLP
DVLP2:	MOVF	t1,W
	SUBWF	t7,F
	BTFSS	bitc
	DECF	t8,F
	MOVF	t2,W
	SUBWF	t8,F	
	BSF	t4,0
	GOTO	DVLP
DVLP:	DECFSZ	t0,W
	GOTO	DVLP1
	GOTO	;NEXT FUNC
