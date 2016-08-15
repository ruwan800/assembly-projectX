varible list

finalmean,finalmeanf	;used to save final result of 'getmean' [finalmean.finalmeanf]
reporter 	;state report byte{4,3,2 used}

tcounth,tcountl	;clock counter values saved for further usage
counth,countl	;clock counter values
meancount	;8bit counter
tdatah,tdatal	;a/d converted values
decerr		;error count in high pulse check
margin		;saves the median voltage
t8,t7,t6,m1,m0	;divide func t8:t7:t6/tcounth:tcountl=[m1.m0]
txchk		;counter
msgptr



statics list

#define	bitz		STATUS,Z
#define	bitc		STATUS,C
#define	interren	INTCON,T0IE		;timer interrupt enable bit
#define	dataen					;select instruction registry
#define	signalen				;signal enable bit
#define	dataport	PORT			;PORT used to send data
#define	bitbuzz					;port bit of buzzer pwr
macro

signal	MACRO
	BSF	signalen
	NOP
	BCF	signalen
	ENDM

message list + msg func


