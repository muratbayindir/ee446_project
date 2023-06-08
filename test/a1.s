	LDR R1, =0x00
	LDR R2, =0x00
	LDR R3, =0x20
loop:	ADD R2, R2, #4
	STR R2, [R1]
	CMP R2, #20
	BEQ loop
	ADD R1, R1, #4
	ADD R3, R2, #4
	STR R3, [R1]
