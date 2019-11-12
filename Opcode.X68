*-----------------------------------------------------------
* Title      :  Opcode.X68
* Written by :  Kyle Dukart
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       It will take in a world-length value stored in D6 and determine which
*       opcode it corresponds to.
* Preconditions: D6 contains word length opcode
*-----------------------------------------------------------
Opcode:
; MOVEM D2-D3            ; MOVEM all registers used
    
    MOVE.W D6,D2         ; copy current word (D6) into working register (D2)
    AND MASK_OPCODE,D2   ; apply mask to first 4 bits
    
    CMP.W #$9000,D2      ; compare with 1001
    BEQ SUB              ; if equal jump to SUB
    
    CMP.W #$5000,D2      ; compare with 1010
    BEQ SUBQ             ; if equal jump to SUBQ
    
    CMP.W #$C000,D2      ; compare with 1100
    BEQ MULS             ; if equal jump to MULS
    
    CMP.W #$0000,D2      ; compare with 0000
    BNE 0000_SKIP        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register
    AND MASK_1110,D3     ; mask bits 11, 10
    CMP.W #$0000,D3      ; compare with 00
    BEQ ORI              ; if equal jump to ORI
    CMP.W #$0C00         ; compare with 11
    BEQ CMPI             ; if equal jump to CMPI
    CMP.W #$0800         ; compare with 10
    BEQ BCLR             ; if equal jump to BCLR
    BRA DATA
    
0000_SKIP:
    
    
DATA: 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
