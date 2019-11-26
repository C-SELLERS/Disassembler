Disassembler Project for 422

TODO:
documentation:
	add mask 210
	add mask 5

breakdown_opcode:
	bclr - handle fetching of next byte
	movem
	cmpi, ori - handle fetching of next byte
	data - print ASCII value of current word

addressing:
	MXn
	XnM
	Displacement
	Data11109

Main:
	lea address into A7 at beginning of program
    add functionality for fetching next word?

TEST ALL THE THINGS