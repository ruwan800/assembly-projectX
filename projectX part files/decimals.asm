


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
