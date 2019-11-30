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
    LEA STR_DATA, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR PrintASCIIWord          ; print the input word to output
    BRA Opcode_Finish

SUB:
    LEA STR_SUB, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE SUB_EA_DN_EA
SUB_DN_EA_DN:                   ; case  Dn + <ea> -> Dn
    JSR EA_AppendMXn
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish
SUB_EA_DN_EA:                   ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish

SUBQ:
    LEA STR_SUBQ, A2
    JSR AppendOutput            ; write SUBQ to the output string
    JSR Opcode_AppendSizeSuffix
    JSR Data11109
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish

MULS:
    LEA STR_MULS, A2
    JSR AppendOutput            ; write MULS to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish

ORI:
    LEA STR_ORI, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Opcode_AppendSizeSuffix
    JSR EA_AppendMXn
    ;todo
    ; if size == byte then fetch next byte
    ; if size == word then fetch next word
    ; if size == long then fetch next long
    BRA Opcode_Finish

CMPI:
    LEA STR_CMPI, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Opcode_AppendSizeSuffix
    JSR EA_AppendMXn
    ;todo
    ; if size == byte then fetch next byte
    ; if size == word then fetch next word
    ; if size == long then fetch next long
    BRA Opcode_Finish

BCLR:
    LEA STR_BCLR, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Dn 
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish

BCLR_I:
    LEA STR_BCLR, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    ;todo
    ; jsr get_immedate_in_next_byte
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish


ADDA:
    LEA STR_ADDA, A2
    JSR AppendOutput            ; write ADDA to the output string
    JSR Size8
    JSR EA_AppendMXn
    JSR AppendComma
    JSR An
    BRA Opcode_Finish

ADD:
    LEA STR_ADD, A2
    JSR AppendOutput            ; write ADD to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE ADD_EA_DN_EA
ADD_DN_EA_DN:                   ; case  Dn + <ea> -> Dn
    JSR EA_AppendMXn
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish
ADD_EA_DN_EA:                   ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish

DIVS:
    LEA STR_DIVS, A2
    JSR AppendOutput            ; write DIVS to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish

OR: 
    LEA         STR_OR, A2
    JSR         AppendOutput            ; write OR to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3               ; move word value into D3
    
    MOVEM.L     D0-D7/A0-A6,-(SP)
    JSR EA_AppendMXn

    AND         #MASK_8, D3             ; mask bit 8
    ;CMP.W #$0000,D3             ; compare with 0
    ;BNE OR_EA_DN_EA       
    
    CMP.W #$0010,D3             ; compare with 0
    BEQ OR_DN_EA_DN
    
    MOVE.L      D6,D3                       ; move EA string from D6 (dest) to D3 (src)
    MOVE.L      D7,D4                       ; move EA value from D7 (dest value) to D4 (src value)    
  
    
OR_DN_EA_DN:                    ; case  Dn + <ea> -> Dn
    
    LEA         EA_StrArray_Dn,A0           ; A0 -> to the Dn string list 
    MOVE.L      (SP),D3                     ; copy to word value to D3 
    AND.L       #MASK_11109,D3              ; mask the source 
    ASR         #8,D3   
    ASR         #1,D3
    MOVE.L      (A0,D3),D3      
  
    ADDA        #02,SP                  ; clear backup 'd6' off the stack
    MOVEM.L     (SP)+,D0-D2/A0-A7       ; restore temps to registers
    
    
    ;JSR EA_AppendMXn
    MOVE.L      D6,A2
    JSR         AppendOutput
    
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish
OR_EA_DN_EA:                    ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish

CMP:
    LEA STR_CMP, A2
    JSR AppendOutput            ; write CMP to the output string
    JSR Opcode_AppendSizeSuffix
    JSR EA_AppendMXn
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish

EOR: 
    LEA STR_EOR, A2
    JSR AppendOutput            ; write EOR to the output string
    JSR Opcode_AppendSizeSuffix
    JSR Dn
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish

MOVEA_B:
    LEA STR_MOVEA_B, A2
    JSR AppendOutput            ; write MOVEA.B to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR An
    BRA Opcode_Finish

MOVE_B:
    LEA STR_MOVE_B, A2
    JSR AppendOutput            ; write MOVE.B to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR XnM
    BRA Opcode_Finish

MOVEA_W:
    LEA STR_MOVEA_W, A2
    JSR AppendOutput            ; write MOVEA.W to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR An
    BRA Opcode_Finish

MOVE_W:
    LEA STR_MOVE_W, A2
    JSR AppendOutput            ; write MOVE.W to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR XnM
    BRA Opcode_Finish

MOVEA_L:
    LEA STR_MOVEA_L, A2
    JSR AppendOutput            ; write MOVEA.L to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR An
    BRA Opcode_Finish

MOVE_L:
    LEA STR_MOVE_L, A2
    JSR AppendOutput            ; write MOVE.L to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR XnM
    BRA Opcode_Finish

ROL:
    ;LEA STR_ROL, A2
    JSR AppendOutput            ; write ROL to the output string
    JSR EA_AppendMXn
    BRA Opcode_Finish

ROR:
    ;LEA STR_ROR, A2
    JSR AppendOutput            ; write ROR to the output string
    JSR EA_AppendMXn
    BRA Opcode_Finish

LSL:
    ;LEA STR_LSL, A2
    JSR AppendOutput            ; write LSL to the output string
    JSR EA_AppendMXn
    BRA Opcode_Finish

LSR:
    ;LEA STRINGLSR, A2
    JSR AppendOutput            ; write LSR to the output string
    JSR EA_AppendMXn
    BRA Opcode_Finish

ASL:
    ;LEA STR_ASL, A2
    JSR AppendOutput            ; write ASL to the output string
    JSR EA_AppendMXn
    BRA Opcode_Finish

ASR:
    ;LEA STR_ASR, A2
    JSR AppendOutput            ; write ASR to the output string
    JSR EA_AppendMXn
    BRA Opcode_Finish

ROL_I:
    ;LEA STR_ROL, A2
    JSR AppendOutput            ; write ROL to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ROL_I_DN
ROL_I_I:                        ; case of immediate input
    JSR Data11109
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish
ROL_I_DN:                       ; case of data register input
    JSR Dn
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish

ROR_I:
    ;LEA STR_ROR, A2
    JSR AppendOutput            ; write ROR to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ROR_I_DN
ROR_I_I:                        ; case of immediate input
    JSR Data11109
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish
ROR_I_DN:                       ; case of data register input
    JSR Dn
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish

LSL_I:
    ;LEA STR_LSL, A2
    JSR AppendOutput            ; write LSL to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE LSL_I_DN
LSL_I_I:                        ; case of immediate input
    JSR Data11109
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish
LSL_I_DN:                       ; case of data register input
    JSR Dn
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish

LSR_I:
    ;LEA STR_LSR, A2
    JSR AppendOutput            ; write LSR to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE LSR_I_DN
LSR_I_I:                        ; case of immediate input
    JSR Data11109
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish
LSR_I_DN:                       ; case of data register input
    JSR Dn
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish

ASL_I:
    ;LEA STR_ASL, A2
    JSR AppendOutput            ; write ASL to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ASL_I_DN
ASL_I_I:                        ; case of immediate input
    JSR Data11109
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish
ASL_I_DN:                       ; case of data register input
    JSR Dn
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish

ASR_I:
    ;LEA STR_ASR, A2
    JSR AppendOutput            ; write ASR to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_5, D3             ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE ASR_I_DN
ASR_I_I:                        ; case of immediate input
    JSR Data11109
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish
ASR_I_DN:                       ; case of data register input
    JSR Dn
    JSR AppendComma
    JSR Dn210
    BRA Opcode_Finish

BRA:
    LEA STR_BRA, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BCS:
    LEA STR_BCS, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BGE:
    LEA STR_BGE, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BLT:
    LEA STR_BLT, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

BVC:
    LEA STR_BVC, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR Displacement
    BRA Opcode_Finish

RTS:
    LEA STR_RTS, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    BRA Opcode_Finish

LEA:
    LEA STR_LEA, A2
    JSR AppendOutput            ; write the current string in A2 to the output string
    JSR EA_AppendMXn
    JSR AppendComma
    JSR An
    BRA Opcode_Finish

NEG:
    LEA         STR_NEG, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    JSR         Opcode_AppendSizeSuffix
    JSR         EA_AppendMXn
    BRA         Opcode_Finish
    
MOVEM:
    LEA STR_MOVEM, A2
    JSR AppendOutput            ; write the current string in A2
    JSR Size6                   
    MOVE.W  D6,D3               ; move word value into working register D3
    AND #MASK_10, D3            ; mask bit 5
    CMP.W #$0000,D3             ; compare with 0
    BNE MOVEM_EA_RL
MOVEM_RL_EA:                    ; case of registers to memory
    JSR RegisterList
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish
MOVEM_EA_RL:                    ; case of memory to registers
    JSR EA_AppendMXn
    JSR AppendComma
    JSR RegisterList
    BRA Opcode_Finish

JSR:
    LEA         STR_JSR, A2
    JSR         AppendOutput
    
    JSR         EA_AppendMXn                    ; Sets D4 & 5 to Src Name & Value; Sets D6 & 7 to Dest Name & Value
 
    BRA         Opcode_Finish

SIMHALT:
    LEA         STR_SIMHALT, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    BRA         Opcode_Finish

Opcode_Finish: 
    LEA OUTPUT, A1              ; Load Output into A1
    JSR TrapTask13              ; Send it to the printer


    ;Set Current String Length Back to Zero
    LEA     CURRENT_STR_LENGTH, A2
    CLR.B   (A2)


    MOVEM.L (SP)+, D2-D3/A4     ; return registers to their previous state
    RTS                         ; return from function

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
