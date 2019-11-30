*-----------------------------------------------------------
* Title      : Global Constants
* Written by : Howie Catlin
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
*-----------------------------------------------------------

*********************************************************************************
* File Constants
*********************************************************************************
inFile          DC.B 'Config.cfg',0
BEGIN_ADDRESS   DS.B 4
END_ADDRESS     DS.B 4

*********************************************************************************
* Numeric Constants
*********************************************************************************
EMPTY_ADDRESS   EQU    $00000000

BYTE_LENGTH     EQU     2
WORD_LENGTH     EQU     4
LONG_LENGTH     EQU     8 

TAB     EQU     $09

FILE_DEFAULT_READ_BYTES  EQU 1024

*********************************************************************************
* String Constants
*********************************************************************************
CURRENT_STR_LENGTH  SET     0
OUTPUT_LENGTH       EQU     40
OUTPUT              DS.B    OUTPUT_LENGTH

ERROR_CODE_FILE_0  DC.W    'Success',0
ERROR_CODE_FILE_1  DC.W    'EOF Encountered',0
ERROR_CODE_FILE_2  DC.W    'Error',0
ERROR_CODE_FILE_3  DC.W    'File is Read only',0

FILE_ERROR_ARRAY   DC.W    'Success','EOF Encountered','Error','File is Read only',0

STRINGCOMMA    DC.B    ', ',0    

STRING_B        DC.B    '.B',TAB,0
STRING_W        DC.B    '.W',TAB,0
STRING_L        DC.B    '.L',TAB,0

STRINGDATA      DC.B    TAB,'DATA',TAB,0
STRINGRTS       DC.B    TAB,'RTS',TAB,0
STRINGJSR       DC.B    TAB,'JSR',TAB,0
STRINGNEG       DC.B    TAB,'NEG',0
STRINGBRA       DC.B    TAB,'BRA',TAB,0
STRINGBCS       DC.B    TAB,'BCS',TAB,0
STRINGBGE       DC.B    TAB,'BGE',TAB,0
STRINGBLT       DC.B    TAB,'BLT',TAB,0
STRINGBVC       DC.B    TAB,'BVC',TAB,0
STRINGORI       DC.B    TAB,'ORI',0
STRINGCMPI      DC.B    TAB,'CMPI',0
STRINGSUB       DC.B    TAB,'SUB',0
STRINGSUBQ      DC.B    TAB,'SUBQ',0
STRINGMULS      DC.B    TAB,'MULS',TAB,0
STRINGADDA      DC.B    TAB,'ADDA',0
STRINGADD       DC.B    TAB,'ADD',0
STRINGDIVS      DC.B    TAB,'DIVS',TAB,0
STRINGOR        DC.B    TAB,'OR',0
STRINGCMP       DC.B    TAB,'CMP',0
STRINGEOR       DC.B    TAB,'EOR',0
STRINGMOVEA_B   DC.B    TAB,'MOVEA.B',TAB,0
STRINGMOVEA_W   DC.B    TAB,'MOVEA.W',TAB,0
STRINGMOVEA_L   DC.B    TAB,'MOVEA.L',TAB,0
STRINGMOVE_B    DC.B    TAB,'MOVE.B',TAB,0
STRINGMOVE_W    DC.B    TAB,'MOVE.W',TAB,0
STRINGMOVE_L    DC.B    TAB,'MOVE.L',TAB,0
STRINGROR       DC.B    TAB,'ROR',TAB,0
STRINGROL       DC.B    TAB,'ROL',TAB,0
STRINGLSL       DC.B    TAB,'LSL',TAB,0
STRINGLSR       DC.B    TAB,'LSR',TAB,0
STRINGASL       DC.B    TAB,'ASL',TAB,0
STRINGASR       DC.B    TAB,'ASR',TAB,0
STRINGBCLR      DC.B    TAB,'BCLR',TAB,0
STRINGLEA       DC.B    TAB,'LEA',TAB,0
STRINGSIMHALT   DC.B    TAB,'SIMHALT',TAB,0

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
MASK_1098       EQU     $0700
MASK_10         EQU     $0400
MASK_9          EQU     $0200
MASK_876 		EQU 	$01C0
MASK_843        EQU     $0118
MASK_8 			EQU 	$0100
MASK_76543210   EQU     $00FF
MASK_7654       EQU     $00F0
MASK_76 		EQU 	$00C0
MASK_6          EQU     $0040
MASK_5          EQU     $0020
MASK_43 		EQU 	$0018
MASK_3210       EQU     $000F
MASK_210        EQU     $0007

*********************************************************************************
* Effective Addressing Constants
*********************************************************************************
EA_Str_00    DC.B    TAB,'D0',0
EA_Str_01    DC.B    TAB,'D1',0
EA_Str_02    DC.B    TAB,'D2',0
EA_Str_03    DC.B    TAB,'D3',0
EA_Str_04    DC.B    TAB,'D4',0
EA_Str_05    DC.B    TAB,'D5',0
EA_Str_06    DC.B    TAB,'D6',0
EA_Str_07    DC.B    TAB,'D7',0

EA_Str_08    DC.B    TAB,'A0',0
EA_Str_09    DC.B    TAB,'A1',0
EA_Str_0A    DC.B    TAB,'A2',0
EA_Str_0B    DC.B    TAB,'A3',0
EA_Str_0C    DC.B    TAB,'A4',0
EA_Str_0D    DC.B    TAB,'A5',0
EA_Str_0E    DC.B    TAB,'A6',0
EA_Str_0F    DC.B    TAB,'A7',0

EA_Str_10    DC.B    TAB,'(A0)',0
EA_Str_11    DC.B    TAB,'(A1)',0
EA_Str_12    DC.B    TAB,'(A2)',0
EA_Str_13    DC.B    TAB,'(A3)',0
EA_Str_14    DC.B    TAB,'(A4)',0
EA_Str_15    DC.B    TAB,'(A5)',0
EA_Str_16    DC.B    TAB,'(A6)',0
EA_Str_17    DC.B    TAB,'(A7)',0

EA_Str_18    DC.B    TAB,'(A0)+',0
EA_Str_19    DC.B    TAB,'(A7)+',0
EA_Str_1A    DC.B    TAB,'(A7)+',0
EA_Str_1B    DC.B    TAB,'(A7)+',0
EA_Str_1C    DC.B    TAB,'(A7)+',0
EA_Str_1D    DC.B    TAB,'(A7)+',0
EA_Str_1E    DC.B    TAB,'(A7)+',0
EA_Str_1F    DC.B    TAB,'(A7)+',0

EA_Str_20    DC.B    TAB,'-(A0)',0
EA_Str_21    DC.B    TAB,'-(A1)',0
EA_Str_22    DC.B    TAB,'-(A2)',0
EA_Str_23    DC.B    TAB,'-(A3)',0
EA_Str_24    DC.B    TAB,'-(A4)',0
EA_Str_25    DC.B    TAB,'-(A5)',0
EA_Str_26    DC.B    TAB,'-(A6)',0
EA_Str_27    DC.B    TAB,'-(A7)',0

EA_Str_3C    DC.B    TAB,'#',0
EA_Str_39    DC.B    TAB,'#$',0
EA_Str_38    DC.B    TAB,'#$',0


EA_StrArray_Dn          DC.W    EA_Str_00, EA_Str_01, EA_Str_02, EA_Str_03, EA_Str_04, EA_Str_05, EA_Str_06, EA_Str_07
EA_StrArray_An          DC.W    EA_Str_08, EA_Str_09, EA_Str_0A, EA_Str_0B, EA_Str_0C, EA_Str_0D, EA_Str_0E, EA_Str_0F
EA_StrArray_AnInd       DC.W    EA_Str_10, EA_Str_11, EA_Str_12, EA_Str_13, EA_Str_14, EA_Str_15, EA_Str_16, EA_Str_17
EA_StrArray_AnPostInc   DC.W    EA_Str_18, EA_Str_19, EA_Str_1A, EA_Str_1B, EA_Str_1C, EA_Str_1D, EA_Str_1E, EA_Str_1F
EA_StrArray_AnPreDec    DC.W    EA_Str_20, EA_Str_21, EA_Str_22, EA_Str_23, EA_Str_24, EA_Str_25, EA_Str_26, EA_Str_27 
EA_StrArray_Else        DC.W    EA_Str_3C, EA_Str_39, EA_Str_38


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

Imm_Str_0              DC.B     '#8',0
Imm_Str_1              DC.B     '#1',0
Imm_Str_2              DC.B     '#2',0
Imm_Str_3              DC.B     '#3',0
Imm_Str_4              DC.B     '#4',0
Imm_Str_5              DC.B     '#5',0
Imm_Str_6              DC.B     '#6',0
Imm_Str_7              DC.B     '#7',0

Immediate_StrArray  DC.W        Imm_Str_0, Imm_Str_1, Imm_Str_2, Imm_Str_3, Imm_Str_4, Imm_Str_5, Imm_Str_6, Imm_Str_7

*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~
