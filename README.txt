Disassembler Project for 422

TODO:
    RegisterList_Preincrement
    RegisterList failing
	lea address into A7 at beginning of program?
    when MOVE gets a 2 digit immediate value such as $AA or $FF, it incorrectly prints #$000A, #$000F
    EA_AppendXnM incorrectly prints D registers when it should be printing other EA modes
    Displacement needs to be interpreted (we are printing 0006 when it should be '3', printing 00FA when it should be '-4')

low priority:
    When printing hex values they are padded with 0s
    extra credit stuff
