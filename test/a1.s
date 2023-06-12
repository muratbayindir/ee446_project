_start:
	LDR R1, =0x00
	LDR R2, =0x00
	LDR R3, =0x20
loop:	
	ADD R2, R2, #4
	nop
	nop
	nop
	STR R2, [R1]
	nop
	nop
	nop
	CMP R2, #20
	nop
	nop
	nop
	ADDEQ R3, R3, #324
	nop
	nop
	nop
	CMP R2, #28
	nop
	nop
	nop
	BNE loop
	nop
	nop
	nop
