*=====================================================================================================================
* Title      :  Breakdown_Opcode.X68
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
*   This file will be included in Main.X68 disassembler program Once the Determine_Opcode has run, it will break 
*   to one of these subroutines corresponding to each of the valid opcodes.  These subroutines will put the  correct 
*   ASCII values in (A2).
*
* Preconditions: 
*   - D6: contains word length opcode string constants are in Gbl_CONST.X68
*=====================================================================================================================


*---------------------------------------------------------------------------------------------------------------------
* Opcode_DATA:
* 
* Appends the string 'DATA' to the output buffer along with the address. This is the default when no other Opcodes fit.
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_DATA:
    LEA         STR_DATA, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         PrintASCIIWord          ; print the input word to output
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_SUB:
* 
* Differentiates between various versions of the 'SUB' opcode and the way that they are printed depending on the 
* effective addressing scheme 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_SUB:
    LEA         STR_SUB, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3                   ; move word value into D3
    AND         #MASK_8, D3             ; mask bit 8
    CMP.W       #$0000,D3             ; compare with 0
    BNE         SUB_EA_DN_EA
SUB_DN_EA_DN:                   ; case  Dn + <ea> -> Dn
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         Dn
    BRA         Opcode_Finish
SUB_EA_DN_EA:                   ; case <ea> + Dn -> <ea>
    JSR         Dn
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_SUBQ:
* 
* Disassembles the SUBQ operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_SUBQ:
    LEA         STR_SUBQ, A2
    JSR         AppendOutput            ; write SUBQ to the output string
    JSR         Opcode_AppendSizeSuffix
    JSR         Data11109
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_ADDQ:
* 
* Disassembles the ADDQ operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_SUBQ:
    LEA         STR_ADDQ, A2
    JSR         AppendOutput            ; write ADDQ to the output string
    JSR         Opcode_AppendSizeSuffix
    JSR         Data11109
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_MULS:
* 
*  Disassembles the MULS operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_MULS:
    LEA         STR_MULS, A2
    JSR         AppendOutput            ; write MULS to the output string
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         Dn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_ORI:
* 
*  Differenetiates between the various versions of ORI and prints the appropriate data to the output buffer depending 
*   on the type of effective addressing 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ORI:
    LEA         STR_ORI, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Opcode_AppendSizeSuffix
    CMP.W       #$0000, D4
    BEQ         ORI_B                   ; if size == byte then fetch next byte
    CMP.W       #$0001, D4          
    BEQ         ORI_W                   ; if size == word then fetch next word
ORI_L:                          ; if size == long then fetch next long
    JSR         Get_Next_Long_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.L      D7, D6              ; move long immediate into D6
    JSR         PrintASCIILong
    JSR         OpcodeSize_SetToLong
    BRA         ORI_END
ORI_B:
    JSR         Get_Next_Word_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.W      D7, D6              ; move word immediate into D6
    JSR         PrintASCIIWord
    JSR         OpcodeSize_SetToByte
    BRA         ORI_END
ORI_W:
    JSR         Get_Next_Word_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.W      D7, D6              ; move word immediate into D6
    JSR         PrintASCIIWord
    JSR         OpcodeSize_SetToWord
    BRA         ORI_END
ORI_END:

    MOVE.W      D4, D6              ; revert word to D6
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_CMPI:
* 
*  Differenetiates between the various versions of CMPI and prints the appropriate data to the output buffer depending 
*   on the type of effective addressing 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_CMPI:
    LEA         STR_CMPI, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Opcode_AppendSizeSuffix
    CMP.W       #$0000, D4
    BEQ         CMPI_B                  ; if size == byte then fetch next byte
    CMP.W       #$0001, D4          
    BEQ         CMPI_W                  ; if size == word then fetch next word
CMPI_L:                         ; if size == long then fetch next long
    JSR         Get_Next_Long_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.L      D7, D6              ; move long immediate into D6
    JSR         PrintASCIILong
    JSR         OpcodeSize_SetToLong
    BRA         CMPI_END
CMPI_B:
    JSR         Get_Next_Word_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.W      D7, D6              ; move word immediate into D6
    JSR         PrintASCIIWord
    JSR         OpcodeSize_SetToByte
    BRA         CMPI_END
CMPI_W:
    JSR         Get_Next_Word_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.W      D7, D6              ; move word immediate into D6
    JSR         PrintASCIIWord
    JSR         OpcodeSize_SetToWord
    BRA         CMPI_END
CMPI_END:
    MOVE.W      D4, D6              ; revert word to D6
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_BCLR:
* 
*  Disassembles the BCLR operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_BCLR:
    LEA         STR_BCLR, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Dn 
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish

BCLR_I:
    LEA         STR_BCLR, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Get_Next_Word_D7
    LEA         STRINGPOUNDHEX, A2
    JSR         AppendOutput            ; print "#$"
    MOVE.W      D6, D4              ; temp store word in D4
    MOVE.W      D7, D6              ; move word immediate into D6
    JSR         PrintASCIIWord
    MOVE.W      D4, D6              ; revert word to D6
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_ADDA:
* 
*  Disassembles the ADDA operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ADDA:
    LEA         STR_ADDA, A2
    JSR         AppendOutput            ; write ADDA to the output string
    JSR         Size8
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         An
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_ADD:
* 
*  Differenetiates between the various versions of ADD and prints the appropriate data to the output buffer depending 
*   on the type of effective addressing 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ADD:
    LEA         STR_ADD, A2
    JSR         AppendOutput            ; write ADD to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3                   ; move word value into D3
    AND         #MASK_8, D3             ; mask bit 8
    CMP.W       #$0000,D3               ; compare with 0
    BNE         ADD_EA_DN_EA
ADD_DN_EA_DN:                   ; case  Dn + <ea> -> Dn
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         Dn
    BRA         Opcode_Finish
ADD_EA_DN_EA:                   ; case <ea> + Dn -> <ea>
    JSR         Dn
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_DIVS:
* 
*  Disassembles the DIVS operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_DIVS:
    LEA         STR_DIVS, A2
    JSR         AppendOutput                ; write DIVS to the output string
    JSR         OpcodeSize_SetToWord        ; set the flag for .W
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         Dn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_OR:
* 
*  Differenetiates between the various versions of OR and prints the appropriate data to the output buffer depending 
*   on the type of effective addressing 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_OR: 
    LEA STR_OR, A2
    JSR AppendOutput            ; write OR to the output string
    JSR Opcode_AppendSizeSuffix
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE OR_EA_DN_EA
OR_DN_EA_DN:                    ; case  Dn + <ea> -> Dn
    JSR EA_AppendMXn
    JSR AppendComma
    JSR Dn
    BRA Opcode_Finish
OR_EA_DN_EA:                    ; case <ea> + Dn -> <ea>
    JSR Dn
    JSR AppendComma
    JSR EA_AppendMXn
    BRA Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_CMP:
* 
*  Disassembles the CMP operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_CMP:
    LEA         STR_CMP, A2
    JSR         AppendOutput            ; write CMP to the output string
    JSR         Opcode_AppendSizeSuffix
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         Dn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_EOR:
* 
*  Disassembles the ADDA operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_EOR: 
    LEA         STR_EOR, A2
    JSR         AppendOutput            ; write EOR to the output string
    JSR         Opcode_AppendSizeSuffix
    JSR         Dn
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* MOVEA_B:
* 
*  Disassembles the MOVEA.B operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
MOVEA_B:
    LEA         STR_MOVEA_B, A2
    JSR         AppendOutput            ; write MOVEA.B to the output string
    JSR         OpcodeSize_SetToByte
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         An
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* MOVE_B:
* 
*  Disassembles the MOVE.B operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
MOVE_B:
    LEA         STR_MOVE_B, A2
    JSR         AppendOutput            ; write MOVE.B to the output string
    JSR         OpcodeSize_SetToByte
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         EA_AppendXnM
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* MOVEA_W:
* 
*  Disassembles the MOVE.W operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
MOVEA_W:
    LEA         STR_MOVEA_W, A2
    JSR         AppendOutput            ; write MOVEA.W to the output string
    JSR         OpcodeSize_SetToWord
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         An
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* MOVE_W:
* 
*  Disassembles the MOVE_W operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
MOVE_W:
    LEA         STR_MOVE_W, A2
    JSR         AppendOutput            ; write MOVE.W to the output string
    JSR         OpcodeSize_SetToWord
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         EA_AppendXnM
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* MOVEA_L:
* 
*  Disassembles the MOVEA.L operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
MOVEA_L:
    LEA         STR_MOVEA_L, A2
    JSR         AppendOutput            ; write MOVEA.L to the output string
    JSR         OpcodeSize_SetToLong
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         An
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* MOVE_L:
* 
*  Disassembles the MOVE.L operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
MOVE_L:
    LEA         STR_MOVE_L, A2
    JSR         AppendOutput            ; write MOVE.L to the output string
    JSR         OpcodeSize_SetToLong
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         EA_AppendXnM
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_ROL:
* 
*  Disassembles the ROL operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ROL:
    LEA         STR_ROL, A2
    JSR         AppendOutput            ; write ROL to the output string
    JSR         EA_AppendMXn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_ROR:
* 
*  Disassembles the ADDA operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ROR:
    LEA         STR_ROR, A2
    JSR         AppendOutput            ; write ROR to the output string
    JSR         EA_AppendMXn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_LSL:
* 
*  Disassembles the LSL operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_LSL:
    LEA         STR_LSL, A2
    JSR         AppendOutput            ; write LSL to the output string
    JSR         EA_AppendMXn
    BRA         Opcode_Finish



*---------------------------------------------------------------------------------------------------------------------
* Opcode_LSR:
* 
*  Disassembles the LSR operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_LSR:
    LEA         STR_LSR, A2
    JSR         AppendOutput            ; write LSR to the output string
    JSR         EA_AppendMXn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_ASL:
* 
*  Disassembles the LSR operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ASL:
    LEA         STR_ASL, A2
    JSR         AppendOutput            ; write ASL to the output string
    JSR         EA_AppendMXn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_ASR:
* 
*  Disassembles the ASR operation code and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ASR:
    LEA         STR_ASR, A2
    JSR         AppendOutput            ; write ASR to the output string
    JSR         EA_AppendMXn
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* ROL_I:
* 
*  Disassembles the various versions of the ROL opcode and prints the data to the output buffer depending on the size
*   of the data and the effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
ROL_I:
    LEA         STR_ROL, A2
    JSR         AppendOutput            ; write ROL to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3               ; move word value into working register D3
    AND         #MASK_5, D3             ; mask bit 5
    CMP.W       #$0000,D3             ; compare with 0
    BNE         ROL_I_DN
ROL_I_I:                        ; case of immediate input
    JSR         Data11109
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish
ROL_I_DN:                       ; case of data register input
    JSR         Dn
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* ROR_I:
* 
*  Disassembles the various versions of the ROR opcode and prints the data to the output buffer depending on the size
*   of the data and the effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
ROR_I:
    LEA         STR_ROR, A2
    JSR         AppendOutput            ; write ROR to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3               ; move word value into working register D3
    AND         #MASK_5, D3             ; mask bit 5
    CMP.W       #$0000,D3             ; compare with 0
    BNE         ROR_I_DN
ROR_I_I:                        ; case of immediate input
    JSR         Data11109
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish
ROR_I_DN:                       ; case of data register input
    JSR         Dn
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* LSL_I:
* 
*  Disassembles the various versions of the LSL opcode and prints the data to the output buffer depending on the size
*   of the data and the effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
LSL_I:
    LEA         STR_LSL, A2
    JSR         AppendOutput            ; write LSL to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3               ; move word value into working register D3
    AND         #MASK_5, D3             ; mask bit 5
    CMP.W       #$0000,D3             ; compare with 0
    BNE         LSL_I_DN
LSL_I_I:                        ; case of immediate input
    JSR         Data11109
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish
LSL_I_DN:                       ; case of data register input
    JSR         Dn
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* LSR_I:
* 
*  Disassembles the various versions of the LSR opcode and prints the data to the output buffer depending on the size
*   of the data and the effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
LSR_I:
    LEA         STR_LSR, A2
    JSR         AppendOutput                ; write LSR to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3                       ; move word value into working register D3
    AND         #MASK_5, D3                 ; mask bit 5
    CMP.W       #$0000,D3                   ; compare with 0
    BNE         LSR_I_DN
LSR_I_I:                        ; case of immediate input
    JSR         Data11109
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish
LSR_I_DN:                       ; case of data register input
    JSR         Dn
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* ASL_I:
* 
*  Disassembles the various versions of the ASL opcode and prints the data to the output buffer depending on the size
*   of the data and the effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
ASL_I:
    LEA         STR_ASL, A2
    JSR         AppendOutput                ; write ASL to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3                       ; move word value into working register D3
    AND         #MASK_5, D3                 ; mask bit 5
    CMP.W       #$0000,D3                   ; compare with 0
    BNE         ASL_I_DN
ASL_I_I:                        ; case of immediate input
    JSR         Data11109
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish
ASL_I_DN:                       ; case of data register input
    JSR         Dn
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* ASR_I:
* 
*  Disassembles the various versions of the ASR opcode and prints the data to the output buffer depending on the size
*   of the data and the effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
ASR_I:
    LEA         STR_ASR, A2
    JSR         AppendOutput                ; write ASR to the output string
    JSR         Opcode_AppendSizeSuffix
    MOVE.W      D6,D3                       ; move word value into working register D3
    AND         #MASK_5, D3                 ; mask bit 5
    CMP.W       #$0000,D3                   ; compare with 0
    BNE         ASR_I_DN
ASR_I_I:                        ; case of immediate input
    JSR         Data11109
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish
ASR_I_DN:                       ; case of data register input
    JSR         Dn
    JSR         AppendComma
    JSR         Dn210
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_BRA:
* 
*  Disassembles the BRA opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_BRA:
    LEA         STR_BRA, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Displacement
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_BCA:
* 
*  Disassembles the BRA opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_BCS:
    LEA         STR_BCS, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Displacement
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_BGE:
* 
*  Disassembles the BRA opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_BGE:
    LEA         STR_BGE, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Displacement
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_BLT:
* 
*  Disassembles the BLT opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_BLT:
    LEA         STR_BLT, A2
    JSR         AppendOutput            ; write the current string in A2 to the output string
    JSR         Displacement
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_BVC:
* 
*  Disassembles the BRA opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_BVC:
    LEA         STR_BVC, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    JSR         Displacement
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_NOP:
* 
*  Disassembles the NOP opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_NOP:
    LEA         STR_NOP, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    BRA         Opcode_Finish
    
*---------------------------------------------------------------------------------------------------------------------
* Opcode_ILLEGAL:
* 
*  Disassembles the ILLEGAL opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_ILLEGAL:
    LEA         STR_ILLEGAL, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_RTS:
* 
*  Disassembles the BRA opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_RTS:
    LEA         STR_RTS, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    BRA         Opcode_Finish


*---------------------------------------------------------------------------------------------------------------------
* Opcode_LEA:
* 
*  Disassembles the LEA opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_LEA:
    LEA         STR_LEA, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         An
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_NEG:
* 
*  Disassembles the NEG opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_NEG:
    LEA         STR_NEG, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    JSR         Opcode_AppendSizeSuffix
    JSR         EA_AppendMXn
    BRA         Opcode_Finish
    
*---------------------------------------------------------------------------------------------------------------------
* Opcode_MOVEM:
* 
*  Disassembles the various vesrions of the MOVEM opcode and prints the data to the output buffer depending on the 
*   size of the data and effective addressing scheme
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_MOVEM:
    LEA         STR_MOVEM, A2
    JSR         AppendOutput                    ; write the current string in A2
    JSR         Size6                   
    MOVE.W      D6,D3                           ; move word value into working register D3
    AND         #MASK_10, D3                    ; mask bit 5
    CMP.W       #$0000,D3                       ; compare with 0
    BNE         MOVEM_EA_RL
MOVEM_RL_EA:                    ; case of registers to memory
    JSR         RegisterList_Predecrement
    JSR         AppendComma
    JSR         EA_AppendMXn
    BRA         Opcode_Finish
MOVEM_EA_RL:                    ; case of memory to registers
    JSR         EA_AppendMXn
    JSR         AppendComma
    JSR         RegisterList_PostIncrement
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_JSR:
* 
*  Disassembles the JSR opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_JSR:
    LEA         STR_JSR, A2
    JSR         AppendOutput
    JSR         EA_AppendMXn                    ; Sets D4 & 5 to Src Name & Value; Sets D6 & 7 to Dest Name & Value
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_SIMHALT:
* 
*  Disassembles the SIMHALT opcode and prints the data to the output buffer 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_SIMHALT:
    LEA         STR_SIMHALT, A2
    JSR         AppendOutput                    ; write the current string in A2 to the output string
    BRA         Opcode_Finish

*---------------------------------------------------------------------------------------------------------------------
* Opcode_Finish:
* 
*  Performs routine cleanup tasks following the successful disassembly of an opcode, including reloading the output
*   buffer, printing via TrapTask13, resetting the string length counter, and restoring any registers that may have 
*   been modified in the process. 
* 
* Pre: 
*   - D6: current opcode
*---------------------------------------------------------------------------------------------------------------------
Opcode_Finish: 
    LEA         OUTPUT, A1                      ; Load Output into A1
    JSR         TrapTask13                      ; Send it to the printer
    LEA         CURRENT_STR_LENGTH, A2
    CLR.B       (A2)                            ; Set Current String Length Back to Zero
    JSR         OpcodeSize_SetToElse            ; reset Opcode Size
    MOVEM.L     (SP)+, D2-D4/A4                 ; return registers to their previous state
    RTS                                         ; return from function


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
