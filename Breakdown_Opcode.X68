*-----------------------------------------------------------
* Title      :  Breakdown_Opcode.X68
* Written by :  Kyle Dukart
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       Once the Determine_Opcode has run, it will break to one of these subroutines
*       corresponding to each of the valid opcodes.  These subroutines will put the 
*       correct ASCII values in (A1) for each opcode and address.
* Preconditions: D6 contains word length opcode
*                string constants are in Gbl_CONST.X68
*-----------------------------------------------------------

DATA:
    LEA STRINGDATA, A1
    ; print ASCII value of opcode in D6
    BRA Opcode_Finish

SUB:
SUBQ:
MULS:
ORI:
CMPI:
BCLR:
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
ROL:
ROR:
LSL:
LSR:
ASL:
ASR:
BRA:
    LEA STRINGBRA, A1
    JSR Displacement
    BRA Opcode_Finish
BCS:
    LEA STRINGBCS, A1
    JSR Displacement
    BRA Opcode_Finish
BGE:
    LEA STRINGBGE, A1
    JSR Displacement
    BRA Opcode_Finish
BLT:
    LEA STRINGBLT, A1
    JSR Displacement
    BRA Opcode_Finish
BVC:
    LEA STRINGBVC, A1
    JSR Displacement
    BRA Opcode_Finish
RTS:
    LEA STRINGRTS, A1
    BRA Opcode_Finish
LEA:
NEG:
    LEA STRINGNEG, A1
    JSR S76
    JSR MXn
    BRA Opcode_Finish
MOVEM:
JSR:
    LEA STRINGJSR, A1
    JSR MXn
    BRA Opcode_Finish

Opcode_Finish: 
    ; append a1 with 0
    MOVEM.L (SP)+, D2-D3        ; return registers to their previous state
    RTS                         ; return from function