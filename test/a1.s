main:
	LDR R1, =0x00
	LDR R2, =0x00
	LDR R3, =0x00
	ADD R2, R2, #4
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ADD R2, R2, #8
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ADD R3, R2, #4
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	STR R3, [R1]
	nop
	nop
	nop
	nop
	nop
