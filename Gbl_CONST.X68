*=====================================================================================================================
* Title      : Global Constants
* Written by : CSS 422 Best Group
*              
*   The CSS 422 Best Group is: 
*       - Howie Catlin
*       - Kyle Dukart
*       - Colton Sellers 
*
* Date       : 10-Nov-2019
*
* Description:
*   File of global constants that are shared across all
*   files and classes (e.g.: BYTE_LENGTH)
*
*   Constants are differentiated from other variables and 
*   functions by being written UNDERSCORE_SEPARATED_CAPITALS,
*   while other objects are CamelCase. 
*
*=====================================================================================================================

* returns opcode size in D0



ARRAY_ELEMENT_WIDTH     EQU     2
    

*********************************************************************************
* FLAGS - Always return in D0
*********************************************************************************
IsTrue      EQU     1
IsFalse     EQU     0

*********************************************************************************
* Opcode Properties
*********************************************************************************
OpcodeSize_Current DC.B    1

OPCODESIZE_BYTE    EQU 0
OPCODESIZE_WORD    EQU 1
OPCODESIZE_LONG    EQU 2
OPCODESIZE_ELSE    EQU 3


*********************************************************************************
* Effective Addressing Properties
*********************************************************************************
EA_IsMXn            DS.B    1
EA_IsXnM            DS.B    1

EA_REGISTER_ASRL_DISTANCE  EQU 9
EA_MODE_ASRL_DISTANCE      EQU 3


*********************************************************************************
* File Constants
*********************************************************************************
inFile          DC.B 'Config.cfg',0
BEGIN_ADDRESS_STR   DS.B 8
END_ADDRESS_STR     DS.B 8



STACK_LOCATION      EQU     $0070000



*********************************************************************************
* Numeric Constants
*********************************************************************************
EMPTY_ADDRESS   EQU    $00000000

BYTE_LENGTH     EQU     1
WORD_LENGTH     EQU     2
LONG_LENGTH     EQU     4 

TAB     EQU     $09

FILE_DEFAULT_READ_BYTES  EQU 1024

*********************************************************************************
* String Constants
*********************************************************************************
CURRENT_STR_LENGTH  DS.B    1
OUTPUT_LENGTH       EQU     40
OUTPUT              DS.B    OUTPUT_LENGTH
OUTPUT_TEMP         DS.B    OUTPUT_LENGTH

ERROR_CODE_FILE_0  DC.W    'Success',0
ERROR_CODE_FILE_1  DC.W    'EOF Encountered',0
ERROR_CODE_FILE_2  DC.W    'Error',0
ERROR_CODE_FILE_3  DC.W    'File is Read only',0

FILE_ERROR_ARRAY   DC.W    'Success','EOF Encountered','Error','File is Read only',0

STRINGCOMMA     DC.B    ', ',0 
STRINGPOUND     DC.B    '#',0
STRINGPOUNDHEX  DC.B    '#$',0 
STRINGSLASH     DC.B    '/',0  

STRING_B        DC.B    '.B',TAB,0
STRING_W        DC.B    '.W',TAB,0
STRING_L        DC.B    '.L',TAB,0

STR_DATA        DC.B    TAB,'DATA',TAB,0
STR_NOP         DC.B    TAB,'NOP',TAB,TAB,0
STR_ILLEGAL     DC.B    TAB,'ILLEGAL',TAB,0
STR_RTS         DC.B    TAB,'RTS',TAB,TAB,0
STR_JSR         DC.B    TAB,'JSR',TAB,TAB,0
STR_NEG         DC.B    TAB,'NEG',0
STR_BRA         DC.B    TAB,'BRA',TAB,0
STR_BCS         DC.B    TAB,'BCS',TAB,0
STR_BGE         DC.B    TAB,'BGE',TAB,0
STR_BLT         DC.B    TAB,'BLT',TAB,0
STR_BVC         DC.B    TAB,'BVC',TAB,0
STR_ORI         DC.B    TAB,'ORI',0
STR_CMPI        DC.B    TAB,'CMPI',0
STR_SUB         DC.B    TAB,'SUB',0
STR_SUBQ        DC.B    TAB,'SUBQ',0
STR_MULS        DC.B    TAB,'MULS',TAB,0
STR_ADDA        DC.B    TAB,'ADDA',0
STR_ADD         DC.B    TAB,'ADD',0
STR_DIVS        DC.B    TAB,'DIVS',TAB,0
STR_OR          DC.B    TAB,'OR',0
STR_CMP         DC.B    TAB,'CMP',0
STR_EOR         DC.B    TAB,'EOR',0
STR_MOVE_B      DC.B    TAB,'MOVE.B',TAB,0
STR_MOVE_W      DC.B    TAB,'MOVE.W',TAB,0
STR_MOVE_L      DC.B    TAB,'MOVE.L',TAB,0
STR_MOVEA_B     DC.B    TAB,'MOVEA.B',TAB,0
STR_MOVEA_W     DC.B    TAB,'MOVEA.W',TAB,0
STR_MOVEA_L     DC.B    TAB,'MOVEA.L',TAB,0
STR_MOVEM       DC.B    TAB,'MOVEM',TAB,0
STR_MOVEM_W     DC.B    TAB,'MOVEM.W',TAB,0
STR_MOVEM_L     DC.B    TAB,'MOVEM.L',TAB,0
STR_ROR         DC.B    TAB,'ROR',TAB,0 
STR_ROL         DC.B    TAB,'ROL',TAB,0
STR_LSR         DC.B    TAB,'LSR',TAB,0
STR_LSL         DC.B    TAB,'LSL',TAB,0
STR_ASL         DC.B    TAB,'ASL',TAB,0
STR_ASR         DC.B    TAB,'ASR',TAB,0
STR_BCLR        DC.B    TAB,'BCLR',TAB,0
STR_LEA         DC.B    TAB,'LEA',TAB,TAB,0
STR_SIMHALT     DC.B    TAB,'SIMHALT',TAB,0

*********************************************************************************
* Mask Constants
*********************************************************************************
MASK_OPCODE 	EQU 	$F000
MASK_111098 	EQU 	$0F00
MASK_1110876    EQU     $0DC0
MASK_1110 		EQU 	$0C00
MASK_11109      EQU     $0E00
MASK_11108      EQU     $0D00
MASK_11 		EQU 	$0800
MASK_10 		EQU 	$0400
MASK_1098       EQU     $0700
MASK_9          EQU     $0200
MASK_876 		EQU 	$01C0
MASK_843        EQU     $0118
MASK_8 			EQU 	$0100
MASK_76543210   EQU     $00FF
MASK_7654       EQU     $00F0
MASK_76 		EQU 	$00C0
MASK_6          EQU     $0020
MASK_5          EQU     $0040
MASK_43 		EQU 	$0018
MASK_3210       EQU     $000F
MASK_210        EQU     $0007
MASK_543        EQU     $0038

MODE_Dn         EQU     $0000
MODE_An         EQU     $0008
MODE_AnInd      EQU     $0010
MODE_AnPostInc  EQU     $0018
MODE_AnPreDec   EQU     $0020
MODE_Else       EQU     $0038
MODE_Imm        EQU     $0004
MODE_AbsLong    EQU     $0001
MODE_AbsWord    EQU     $0000




*********************************************************************************
* Effective Addressing Constants
*********************************************************************************
EA_Str_D0       DC.B    'D0',0
EA_Str_D1       DC.B    'D1',0
EA_Str_D2       DC.B    'D2',0
EA_Str_D3       DC.B    'D3',0
EA_Str_D4       DC.B    'D4',0
EA_Str_D5       DC.B    'D5',0
EA_Str_D6       DC.B    'D6',0
EA_Str_D7       DC.B    'D7',0

EA_Str_A0       DC.B    'A0',0
EA_Str_A1       DC.B    'A1',0
EA_Str_A2       DC.B    'A2',0
EA_Str_A3       DC.B    'A3',0
EA_Str_A4       DC.B    'A4',0
EA_Str_A5       DC.B    'A5',0
EA_Str_A6       DC.B    'A6',0
EA_Str_A7       DC.B    'A7',0

EA_Str_AInd0       DC.B    '(A0)',0
EA_Str_AInd1       DC.B    '(A1)',0
EA_Str_AInd2       DC.B    '(A2)',0
EA_Str_AInd3       DC.B    '(A3)',0
EA_Str_AInd4       DC.B    '(A4)',0
EA_Str_AInd5       DC.B    '(A5)',0
EA_Str_AInd6       DC.B    '(A6)',0
EA_Str_AInd7       DC.B    '(A7)',0

EA_Str_APostInc0       DC.B    '(A0)+',0
EA_Str_APostInc1       DC.B    '(A1)+',0
EA_Str_APostInc2       DC.B    '(A2)+',0
EA_Str_APostInc3       DC.B    '(A3)+',0
EA_Str_APostInc4       DC.B    '(A4)+',0
EA_Str_APostInc5       DC.B    '(A5)+',0
EA_Str_APostInc6       DC.B    '(A6)+',0
EA_Str_APostInc7       DC.B    '(A7)+',0

EA_Str_APreDec0       DC.B    '-(A0)',0
EA_Str_APreDec1       DC.B    '-(A1)',0
EA_Str_APreDec2       DC.B    '-(A2)',0
EA_Str_APreDec3       DC.B    '-(A3)',0
EA_Str_APreDec4       DC.B    '-(A4)',0
EA_Str_APreDec5       DC.B    '-(A5)',0
EA_Str_APreDec6       DC.B    '-(A6)',0
EA_Str_APreDec7       DC.B    '-(A7)',0


EA_Str_Hash             DC.B    '#',0
EA_Str_HashDollar       DC.B    '#$',0
EA_Str_Dollar           DC.B    '$',0


EA_StrArray_Dn          DC.W    EA_Str_D0,        EA_Str_D1,        EA_Str_D2,        EA_Str_D3,        EA_Str_D4,        EA_Str_D5,        EA_Str_D6,        EA_Str_D7
EA_StrArray_An          DC.W    EA_Str_A0,        EA_Str_A1,        EA_Str_A2,        EA_Str_A3,        EA_Str_A4,        EA_Str_A5,        EA_Str_A6,        EA_Str_A7
EA_StrArray_AnInd       DC.W    EA_Str_AInd0,     EA_Str_AInd1,     EA_Str_AInd2,     EA_Str_AInd3,     EA_Str_AInd4,     EA_Str_AInd5,     EA_Str_AInd6,     EA_Str_AInd7
EA_StrArray_AnPostInc   DC.W    EA_Str_APostInc0, EA_Str_APostInc1, EA_Str_APostInc2, EA_Str_APostInc3, EA_Str_APostInc4, EA_Str_APostInc5, EA_Str_APostInc6, EA_Str_APostInc7
EA_StrArray_AnPreDec    DC.W    EA_Str_APreDec0,  EA_Str_APreDec1,  EA_Str_APreDec2,  EA_Str_APreDec3,  EA_Str_APreDec4,  EA_Str_APreDec5,  EA_Str_APreDec6,  EA_Str_APreDec7


EA_ModeArray_Dn         DC.W    $00,$01,$02,$03,$04,$05,$06,$07
EA_ModeArray_AnArray    DC.W    $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
EA_ModeArray_AnInd      DC.W    $10,$11,$12,$13,$14,$15,$16,$17
EA_ModeArray_AnPostInc  DC.W    $18,$19,$1A,$1B,$1C,$1D,$1E,$1F
EA_ModeArray_AnPreDec   DC.W    $20,$21,$22,$23,$24,$25,$26,$27
EA_ModeArray_Else       DC.W    $3C,$39,$38


Hex_Str_00              DC.B    '0',0
Hex_Str_01              DC.B    '1',0
Hex_Str_02              DC.B    '2',0
Hex_Str_03              DC.B    '3',0
Hex_Str_04              DC.B    '4',0
Hex_Str_05              DC.B    '5',0
Hex_Str_06              DC.B    '6',0
Hex_Str_07              DC.B    '7',0
Hex_Str_08              DC.B    '8',0
Hex_Str_09              DC.B    '9',0
Hex_Str_10              DC.B    'A',0
Hex_Str_11              DC.B    'B',0
Hex_Str_12              DC.B    'C',0
Hex_Str_13              DC.B    'D',0
Hex_Str_14              DC.B    'E',0
Hex_Str_15              DC.B    'F',0

Hex_StrArray         DC.W       Hex_Str_00, Hex_Str_01, Hex_Str_02, Hex_Str_03, Hex_Str_04, Hex_Str_05, Hex_Str_06, Hex_Str_07
                     DC.W       Hex_Str_08, Hex_Str_09, Hex_Str_10, Hex_Str_11, Hex_Str_12, Hex_Str_13, Hex_Str_14, Hex_Str_15










*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~
