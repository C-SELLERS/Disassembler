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
    ;todo
    ; print ASCII value of opcode in D6
    BRA Opcode_Finish

SUB:
    LEA STRINGSUB, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE SUB_EA_DN_EA
SUB_DN_EA_DN:                   ; case  Dn + <ea> -> Dn
    JSR MXn
    JSR Comma
    JSR Dn
    BRA Opcode_Finish
SUB_EA_DN_EA:                   ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

SUBQ:
    LEA STRINGSUBQ, A2
    JSR AppendOutput            ; write SUBQ to the output string
    JSR Size76
    JSR Data11109
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

MULS:
    LEA STRINGMULS, A2
    JSR AppendOutput            ; write MULS to the output string
    JSR MXn
    JSR Comma
    JSR Dn
    BRA Opcode_Finish

ORI:
    LEA STRINGORI, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    JSR MXn
    ;todo
    ; if size == byte then fetch next byte
    ; if size == word then fetch next word
    ; if size == long then fetch next long
    BRA Opcode_Finish

CMPI:
    LEA STRINGCMPI, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    JSR MXn
    ;todo
    ; if size == byte then fetch next byte
    ; if size == word then fetch next word
    ; if size == long then fetch next long
    BRA Opcode_Finish

BCLR:
    LEA STRINGBCLR, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Dn 
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

BCLR_I:
    LEA STRINGBCLR, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    ;todo
    ; jsr get_immedate_in_next_byte
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

ADDA:
    LEA STRINGADDA, A2
    JSR AppendOutput            ; write ADDA to the output string
    JSR Size8
    JSR MXn
    JSR Comma
    JSR An
    BRA Opcode_Finish

ADD:
    LEA STRINGADD, A2
    JSR AppendOutput            ; write ADD to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE ADD_EA_DN_EA
ADD_DN_EA_DN:                   ; case  Dn + <ea> -> Dn
    JSR MXn
    JSR Comma
    JSR Dn
    BRA Opcode_Finish
ADD_EA_DN_EA:                   ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

DIVS:
    LEA STRINGDIVS, A2
    JSR AppendOutput            ; write DIVS to the output string
    JSR MXn
    JSR Comma
    JSR Dn
    BRA Opcode_Finish

OR: 
    LEA STRINGOR, A2
    JSR AppendOutput            ; write OR to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE OR_EA_DN_EA
OR_DN_EA_DN:                    ; case  Dn + <ea> -> Dn
    JSR MXn
    JSR Comma
    JSR Dn
    BRA Opcode_Finish
OR_EA_DN_EA:                    ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

CMP:
    LEA STRINGCMP, A2
    JSR AppendOutput            ; write CMP to the output string
    JSR Size76
    JSR MXn
    JSR Comma
    JSR Dn
    BRA Opcode_Finish

EOR: 
    LEA STRINGEOR, A2
    JSR AppendOutput            ; write EOR to the output string
    JSR Size76
    JSR Dn
    JSR Comma
    JSR MXn
    BRA Opcode_Finish

MOVEA_B:
    LEA STRINGMOVEA_B, A2
    JSR AppendOutput            ; write MOVEA.B to the output string
    JSR MXn
    JSR Comma
    JSR An
    BRA Opcode_Finish

MOVE_B:
    LEA STRINGMOVE_B, A2
    JSR AppendOutput            ; write MOVE.B to the output string
    JSR MXn
    JSR Comma
    JSR XnM
    BRA Opcode_Finish

MOVEA_W:
    LEA STRINGMOVEA_W, A2
    JSR AppendOutput            ; write MOVEA.W to the output string
    JSR MXn
    JSR Comma
    JSR An
    BRA Opcode_Finish

MOVE_W:
    LEA STRINGMOVE_W, A2
    JSR AppendOutput            ; write MOVE.W to the output string
    JSR MXn
    JSR Comma
    JSR XnM
    BRA Opcode_Finish

MOVEA_L:
    LEA STRINGMOVEA_L, A2
    JSR AppendOutput            ; write MOVEA.L to the output string
    JSR MXn
    JSR Comma
    JSR An
    BRA Opcode_Finish

MOVE_L:
    LEA STRINGMOVE_L, A2
    JSR AppendOutput            ; write MOVE.L to the output string
    JSR MXn
    JSR Comma
    JSR XnM
    BRA Opcode_Finish

ROL:
    LEA STRINGROL, A2
    JSR AppendOutput            ; write ROL to the output string
    JSR MXn
    BRA Opcode_Finish

ROR:
    LEA STRINGROR, A2
    JSR AppendOutput            ; write ROR to the output string
    JSR MXn
    BRA Opcode_Finish

LSL:
    LEA STRINGLSL, A2
    JSR AppendOutput            ; write LSL to the output string
    JSR MXn
    BRA Opcode_Finish

LSR:
    LEA STRINGLSR, A2
    JSR AppendOutput            ; write LSR to the output string
    JSR MXn
    BRA Opcode_Finish

ASL:
    LEA STRINGASL, A2
    JSR AppendOutput            ; write ASL to the output string
    JSR MXn
    BRA Opcode_Finish

ASR:
    LEA STRINGASR, A2
    JSR AppendOutput            ; write ASR to the output string
    JSR MXn
    BRA Opcode_Finish

ROL_I:
    LEA STRINGROL, A2
    JSR AppendOutput            ; write ROL to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ROL_I_DN
ROL_I_I:                        ; case of immediate input
    JSR Data11109
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish
ROL_I_DN:                       ; case of data register input
    JSR Dn
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish

ROR_I:
    LEA STRINGROR, A2
    JSR AppendOutput            ; write ROR to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ROR_I_DN
ROR_I_I:                        ; case of immediate input
    JSR Data11109
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish
ROR_I_DN:                       ; case of data register input
    JSR Dn
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish

LSL_I:
    LEA STRINGLSL, A2
    JSR AppendOutput            ; write LSL to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE LSL_I_DN
LSL_I_I:                        ; case of immediate input
    JSR Data11109
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish
LSL_I_DN:                       ; case of data register input
    JSR Dn
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish

LSR_I:
    LEA STRINGLSR, A2
    JSR AppendOutput            ; write LSR to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE LSR_I_DN
LSR_I_I:                        ; case of immediate input
    JSR Data11109
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish
LSR_I_DN:                       ; case of data register input
    JSR Dn
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish

ASL_I:
    LEA STRINGASL, A2
    JSR AppendOutput            ; write ASL to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ASL_I_DN
ASL_I_I:                        ; case of immediate input
    JSR Data11109
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish
ASL_I_DN:                       ; case of data register input
    JSR Dn
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish

ASR_I:
    LEA STRINGASR, A2
    JSR AppendOutput            ; write ASR to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ASR_I_DN
ASR_I_I:                        ; case of immediate input
    JSR Data11109
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish
ASR_I_DN:                       ; case of data register input
    JSR Dn
    JSR Comma
    JSR Dn210
    BRA Opcode_Finish

BRA:
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
    LEA STRINGLEA, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR MXn
    JSR Comma
    JSR An
    BRA Opcode_Finish

NEG:
    LEA STRINGNEG, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Size76
    JSR MXn
    BRA Opcode_Finish
    
MOVEM:
    ;todo

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
    MOVE #0, CURRENT_STR_LENGTH ;Set current string length back to zero to be written over
    MOVEM.L (SP)+, D2-D3/A4     ; return registers to their previous state
    RTS                         ; return from function

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
