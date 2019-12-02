Disassembler Project for 422

TODO:
    RegisterList_Preincrement
    RegisterList failing
	lea address into A7 at beginning of program?
    when MOVE gets a 2 digit immediate value such as $AA or $FF, it incorrectly prints #$000A, #$000F
    Displacement needs to be interpreted (we are printing 0006 when it should be '3', printing 00FA when it should be '-4')
    Test non-required opcodes (to see how it catches DATA)

low priority:
    extra credit stuff