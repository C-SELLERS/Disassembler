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

STRINGDATA  DC.B    TAB,'DATA',0
STRINGRTS  DC.B    TAB,'RTS',0
STRINGJSR  DC.B    TAB,'JSR',0
STRINGNEG  DC.B    TAB,'NEG',0
STRINGBRA  DC.B    TAB,'BRA',0
STRINGBCS  DC.B    TAB,'BCS',0
STRINGBGE  DC.B    TAB,'BGE',0
STRINGBLT  DC.B    TAB,'BLT',0
STRINGBVC  DC.B    TAB,'BVC',0
STRINGORI  DC.B    TAB,'ORI',0
STRINGCMPI  DC.B    TAB,'CMPI',0
STRINGSIMHALT DC.B   TAB,'SIMHALT',0



*********************************************************************************
* Mask Constants
*********************************************************************************
MASK_OPCODE 	EQU 	$F000
MASK_111098 	EQU 	$0F00
MASK_1110 		EQU 	$0C00
MASK_11 		EQU 	$0800
MASK_876 		EQU 	$01C0
MASK_8 			EQU 	$0100
MASK_76 		EQU 	$00C0
MASK_43 		EQU 	$0018

   
   
   ; mask 4,3 
   ; compare 01 
   ; BEQ LSX subroutine 
   ; BLT ASX subroutine 
   ; BRA ROX subroutine 
   ;RTS 
   
    ; LSX subroutine
    ;mask 8
    ;if equals 0 lsr
    ; equals lsl 
    ;RTS
    
    ; ROX subroutine
    ;mask 8
    ;if equals 0 rsr
    ; equals rsl 
    ;RTS
    
    ; ASX subroutine
    ;mask 8
    ;if equals 0 asr
    ; equals asl 
    ;RTS
    



*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~
