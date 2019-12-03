Disassembler Project for 422

TODO:
------------------------
    * Main() does not return when A3 >= A4(END_ADDRESS) 
    * RegisterList_Preincrement
    * RegisterList failing
	* Displacement needs to be interpreted (we are printing 0006 when it should be '3', printing 00FA when it should be '-4')
    * Function headers 
    * Required Documentation
    * Unsolved bug(s):
Input				        Output  				Comment
DIVS        #01,D1		    DIVS    #$83F9, D1 		DIVS #IMM should pull next word from memory and interpret that as Immediate
                                                    EA_AppendModeRegister does not know size (OpcodeSize_GetSize) because Opcode_AppendSizeSuffix is not called in this context
                                                    This bug also messes up the next line

EOR         D0,-(A7)		EOR.W   D0, -(A7)
EOR.W       #$AAFF,D0		CMPI.W  #$AAFF, D0		Predecrement A7 messes up the next line?

ADD         -(A7),D1		ADD.W   -(A7), D1
ADD         #02,D1		    SUBQ.W  2, D1			Possible problem with predecrement A7 ?

ADDA        -(A7),A1		ADDA.W  -(A7), A1
ADDA        #02,A1		    SUBQ.W  2, A1			Same issue as above

Low priority:
------------------------
    extra credit stuff


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
