Disassembler Project for 422

TODO:
------------------------
    * Main() does not return when A3 >= A4(END_ADDRESS) 
    * RegisterList_Preincrement
    * RegisterList failing
	* Displacement needs to be interpreted (we are printing 0006 when it should be '3', printing 00FA when it should be '-4')
    * Function headers 

Low priority:
------------------------
    extra credit stuff
    print '#' in Data11109?


Completed: 
------------------------
    * ROLs interpreted as RORs and vice-versa
    * Created STACK_LOCATION, and LEA'd A7 to it in DissassemblerSetup.x68 [crashing error]; 
         - STACK_LOCATION is set to $0070000, but feel free to change that
    * Added NOP and ILLEGAL commands
    * Immediate values should be interpreted correctly based on the sized of the opcodes (e.g.: "Move.B #imm" vs. "Move.L #imm")
    * Added function header stubs above all main functions
    * Renamed Opcode strings slightly more informative (e.g.: EA_STR_0F -> EA_STR_A7; EA_STR_18 -> EA_Str_AInd7)
    * Cleaned up Test_002.x68 so the comparison should be easier to interpret 
    * Changed Config.cfg to end a few "SIMHALT"s after TEST_002.x68 

