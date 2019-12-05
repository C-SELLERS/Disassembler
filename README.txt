Disassembler Project for 422

TODO:
------------------------
    * Function headers 
    * Required Documentation
    * Registerlist does not print dash and contiguous registers

Registerlist Test:

	Input	        				Output
    MOVEM   A2, -(SP)				MOVEM.L	A2, -(A7)
    MOVEM   D1-D6, -(SP)			MOVEM.L	D1, -(A7)
    MOVEM   D2/A5, -(SP)			MOVEM.L	D2/A5, -(A7)
    MOVEM   D3-D5/A2-A4, -(SP)		MOVEM.L	D3/A2, -(A7)
    MOVEM   D0-D7/A0-A2, -(SP)      MOVEM.L	D0-D7/A0, -(A7)
    
    MOVEM   (SP)+, A2				MOVEM.W	(A7)+, A2
    MOVEM   (SP)+, D1-D6			MOVEM.W	(A7)+, D1
    MOVEM   (SP)+, D2/A5			MOVEM.W	(A7)+, D2/A5
    MOVEM   (SP)+, D3-D5/A2-A4		MOVEM.W	(A7)+, D3/A2
    MOVEM   (SP)+, D0-D7/A0-A2      MOVEM.W	(A7)+, D0-D7/A0

Low priority:
------------------------
    extra credit stuff

Opcodes supported that are not required:
------------------------
    ADDQ, EORI

Completed: 
------------------------
	* Displacement needs to be interpreted (we are printing 0006 when it should be '3', printing 00FA when it should be '-4')
    * ROLs interpreted as RORs and vice-versa
    * Created STACK_LOCATION, and LEA'd A7 to it in DissassemblerSetup.x68 [crashing error]; 
         - STACK_LOCATION is set to $0070000, but feel free to change that
    * Added NOP and ILLEGAL commands
    * Immediate values should be interpreted correctly based on the sized of the opcodes (e.g.: "Move.B #imm" vs. "Move.L #imm")
    * Added function header stubs above all main functions
    * Renamed Opcode strings slightly more informative (e.g.: EA_STR_0F -> EA_STR_A7; EA_STR_18 -> EA_Str_AInd7)
    * Cleaned up Test_002.x68 so the comparison should be easier to interpret 
    * Changed Config.cfg to end a few "SIMHALT"s after TEST_002.x68 

            ¶¶¶
           ¶   ¶
            ¶¶¶
            ¶ ¶
            ¶ ¶
          ¶¶¶ ¶¶¶
        ¶¶  ¶¶¶  ¶¶¶
      ¶¶  ¶¶¶¶¶¶¶   ¶
     ¶               ¶
    ¶                 ¶
    ¶                 ¶
    ¶     ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
    ¶    ¶               ¶
    ¶    ¶   ¶¶¶¶¶¶¶¶¶¶¶¶¶
    ¶   ¶   ¶           ¶¶¶
    ¶   ¶   ¶ ¶¶¶   ¶¶¶  ¶¶
    ¶   ¶   ¶ ¶¶¶   ¶¶¶  ¶¶
    ¶   ¶   ¶           ¶¶¶
    ¶    ¶   ¶¶¶¶¶¶¶¶¶¶¶¶¶
    ¶     ¶¶¶¶¶¶¶¶¶¶¶¶¶¶
    ¶                 ¶
    ¶    ¶¶¶¶¶¶¶¶¶¶¶¶¶¶
    ¶   ¶  ¶  ¶  ¶  ¶
    ¶  ¶¶¶¶¶¶¶¶¶¶¶¶¶¶
    ¶  ¶   ¶  ¶  ¶  ¶
    ¶   ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
   ¶¶¶                 ¶¶¶
"HOW CAN I BE SO BAD AT EVERYTHING I TRY, AND STILL BE SO GREAT?"
