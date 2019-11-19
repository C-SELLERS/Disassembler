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

FILE_DEFAULT_READ_BYTES  EQU 1024


*********************************************************************************
* String Constants
*********************************************************************************

ERROR_CODE_FILE_0  DC.W    'Success',0
ERROR_CODE_FILE_1  DC.W    'EOF Encountered',0
ERROR_CODE_FILE_2  DC.W    'Error',0
ERROR_CODE_FILE_3  DC.W    'File is Read only',0

FILE_ERROR_ARRAY   DC.W    'Success','EOF Encountered','Error','File is Read only',0

STRINGDATA  DC.B    '    DATA '
STRINGRTS  DC.B    '    RTS'
STRINGJSR  DC.B    '    JSR '
STRINGNEG  DC.B    '    NEG'
STRINGBRA  DC.B    '    BRA '
STRINGBCS  DC.B    '    BCS '
STRINGBGE  DC.B    '    BGE '
STRINGBLT  DC.B    '    BLT '
STRINGBVC  DC.B    '    BVC '

   
   
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
