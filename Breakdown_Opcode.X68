*-----------------------------------------------------------
* Title      :  Breakdown_Opcode.X68
* Written by :  Kyle Dukart
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       Once the Determine_Opcode has run, it will break to one of these subroutines
*       corresponding to each of the valid opcodes.  These subroutines will put the 
*       correct ASCII values in (A2)
* Preconditions: D6 contains word length opcode
*                string constants are in Gbl_CONST.X68
*-----------------------------------------------------------

DATA:
    LEA STRINGDATA, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    ; print ASCII value of opcode in D6
    BRA Opcode_Finish

SUB:
SUBQ:
MULS:
ORI:
    LEA STRINGORI, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    JSR MXn
    ; if size == byte then fetch next byte
    ; if size == word then fetch next word
    ; if size == long then fetch next long
    BRA Opcode_Finish

CMPI:
    LEA STRINGCMPI, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    JSR MXn
    ; if size == byte then fetch next byte
    ; if size == word then fetch next word
    ; if size == long then fetch next long
    BRA Opcode_Finish

BCLR:
BCLR_I:
ADDA:
ADD:
DIVS:
OR: 
CMP:
EOR:  
MOVEA_B:
MOVE_B:
MOVEA_W:
MOVE_W:
MOVEA_L:
MOVE_L:
ROL:
ROR:
LSL:
LSR:
ASL:
ASR:
ROL_I:
ROR_I:
LSL_I:
LSR_I:
ASL_I:
ASR_I:
BRA_I:
    LEA STRINGBRA, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BCS:
    LEA STRINGBCS, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BGE:
    LEA STRINGBGE, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BLT:
    LEA STRINGBLT, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BVC:
    LEA STRINGBVC, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

RTS:
    LEA STRINGRTS, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    BRA Opcode_Finish

LEA:
NEG:
    LEA STRINGNEG, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    JSR MXn
    BRA Opcode_Finish
    
MOVEM:
JSR:
    LEA STRINGJSR, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR MXn
    BRA Opcode_Finish

SIMHALT:
    LEA STRINGSIMHALT, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    BRA Opcode_Finish

Opcode_Finish: 
    LEA OUTPUT, A1              ; Load Output into A1
    JSR TrapTask13              ; Send it to the printer
    MOVE #0, CURRENT_STR_LENGTH   ;Set current string length back to zero to be written over
    MOVEM.L (SP)+, D2-D3        ; return registers to their previous state
    RTS                         ; return from function



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
