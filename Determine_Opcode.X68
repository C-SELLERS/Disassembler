*=====================================================================================================================
* Title      :  Determine_Opcode.X68
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
*   This file will be included in Main.X68 disassembler program It will take in a world-length value stored in D6 
*   and determine which  opcode it corresponds to.
* 
* Preconditions: 
*   - D6 contains word length opcode
*=====================================================================================================================

Opcode:
    MOVEM.L     D2-D4/A4, -(SP)         ; MOVEM all registers used
    
    MOVE.W      D6,D2                   ; copy current word (D6) into opcode mask register (D2)
    AND         #MASK_OPCODE,D2         ; apply mask to first 4 bits

    CMP.W       #$9000,D2               ; compare with 1001
    BEQ         Opcode_SUB              ; if equal jump to SUB
    
    CMP.W       #$5000,D2               ; compare with 1010
    BEQ         Opcode_SUBQ             ; if equal jump to SUBQ
    
    CMP.W       #$C000,D2               ; compare with 1100
    BEQ         Opcode_MULS             ; if equal jump to MULS
    
    CMP.W       #$0000,D2               ; compare with 0000
    BNE         Skip_0000               ; if not equal then skip    
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_1110876,D3        ; mask bits 11,10,8,7,6
    
    CMP.W       #$0880,D3               ; compare with 10010
    BEQ         BCLR_I                  ; if equal jump to BCLR
    MOVE.W      D6,D3                   ; reset current word in D3
    AND         #MASK_8,D3              ; mask bit 8
    
    CMP.W       #$0100,D3               ; compare with 1
    BEQ         Opcode_BCLR             ; if equal jump to BCLR
    MOVE.W      D6,D3                   ; reset current word in D3
    AND         #MASK_11,D3             ; mask bit 11
    
    CMP.W       #$0800,D3               ; compare with 1
    BEQ         Opcode_CMPI             ; if equal jump to CMPI
    MOVE.W      D6,D3                   ; reset current word in D3
    AND         #MASK_11108,D3          ; mask bit 11, 10,8
    
    CMP.W       #$0000,D3               ; compare with 000
    BEQ         Opcode_ORI              ; if equal jump to ORI

Skip_0000:    
    CMP.W       #$D000,D2               ; compare with 1101
    BNE         Skip_1101               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_76,D3             ; mask bits 7, 6    
    
    CMP.W       #$00C0,D3               ; compare with 11
    BEQ         Opcode_ADDA             ; if equal jump to ADDA
    BNE         Opcode_ADD              ; if not equal jump to ADD

Skip_1101:
    CMP.W       #$8000,D2               ; compare with 1000
    BNE         Skip_1000               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_76,D3             ; mask bits 7, 6
    
    CMP.W       #$00C0,D3               ; compare with 11
    BEQ         Opcode_DIVS             ; if equal jump to DIVS
    BNE         Opcode_OR               ; if not equal jump to OR

Skip_1000:
    CMP.W       #$B000,D2               ; compare with 1011
    BNE         Skip_1011               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_8,D3              ; mask bit 8
    
    CMP.W       #$0000,D3               ; compare with 0
    BEQ         Opcode_CMP              ; if equal jump to CMP
    BNE         Opcode_EOR              ; if not equal jump to EOR

Skip_1011:
    CMP.W       #$1000,D2               ; compare with 0001
    BNE         Skip_0001               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_876,D3            ; mask bits 8, 7, 6
    
    CMP.W       #$0040,D3               ; compare with 001
    BEQ         MOVEA_B                 ; if equal jump to MOVEA_B
    BNE         MOVE_B                  ; if not equal jump to MOVE_B

Skip_0001:
    CMP.W       #$3000,D2               ; compare with 0011
    BNE         Skip_0011               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_876,D3            ; mask bits 8, 7, 6
    
    CMP.W       #$0040,D3               ; compare with 001
    BEQ         MOVEA_W                 ; if equal jump to MOVEA_W
    BNE         MOVE_W                  ; if not equal jump to MOVE_W

Skip_0011:
    CMP.W       #$2000,D2               ; compare with 0010
    BNE         Skip_0010               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_876,D3            ; mask bits 8, 7, 6
    
    CMP.W       #$0040,D3               ; compare with 001
    BEQ         MOVEA_L                 ; if equal jump to MOVEA_L
    BNE         MOVE_L                  ; if not equal jump to MOVE_L

Skip_0010:
    CMP.W       #$E000,D2               ; compare with 1110
    BNE         Skip_1110               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_76,D3             ; mask bits 7, 6
    
    CMP.W       #$00C0,D3               ; compare with 11
    BNE         Branch_0110             ; branch to second half of check if not equal
    MOVE.W      D6,D3                   ; reset the word value in D3
    AND         #MASK_1098,D3           ; mask bits 10, 9, 8
    
    CMP.W       #$0600,D3               ; compare with 110
    BEQ         Opcode_ROL              ; if equal jump to ROL
    CMP.W       #$0700,D3               ; compare with 111
    BEQ         Opcode_ROR              ; if equal jump to ROR
    
    CMP.W       #$0300,D3               ; compare with 011
    BEQ         Opcode_LSL              ; if equal jump to LSL
    
    CMP.W       #$0200,D3               ; compare with 010
    BEQ         Opcode_LSR              ; if equal jump to LSR
    
    CMP.W       #$0100,D3               ; compare with 001
    BEQ         Opcode_ASL              ; if equal jump to ASL
    
    CMP.W       #$0000,D3               ; compare with 000
    BEQ         Opcode_ASR              ; if equal jump to ASR
    BRA         Skip_1110               ; no valid opcodes found, skip ahead

Branch_0110:
    MOVE.W      D6,D3                   ; reset the word value in D3
    AND         #MASK_843,D3            ; mask bits 8, 4, 3
    
    CMP.W       #$0118,D3               ; compare with 111
    BEQ         ROL_I                   ; if equal jump to ROL
    
    CMP.W       #$0018,D3               ; compare with 011
    BEQ         ROR_I                   ; if equal jump to ROR
    
    CMP.W       #$0108,D3               ; compare with 101
    BEQ         LSL_I                   ; if equal jump to LSL
    
    CMP.W       #$0008,D3               ; compare with 001
    BEQ         LSR_I                   ; if equal jump to LSR
    
    CMP.W       #$0100,D3               ; compare with 100
    BEQ         ASL_I                   ; if equal jump to ASL
    
    CMP.W       #$0000,D3               ; compare with 000
    BEQ         ASR_I                   ; if equal jump to ASR

Skip_1110:
    CMP.W       #$6000,D2               ; compare with 0110
    BNE         Skip_0110               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    AND         #MASK_111098,D3         ; mask bits 11, 10, 9, 8
        
    CMP.W       #$0000,D3               ; compare with 0000
    BEQ         Opcode_BRA              ; if equal jump to BRA
    
    CMP.W       #$0500,D3               ; compare with 0101
    BEQ         Opcode_BCS              ; if equal jump to BCS
    
    CMP.W       #$0C00,D3               ; compare with 1100
    BEQ         Opcode_BGE              ; if equal jump to BGE
    
    CMP.W       #$0D00,D3               ; compare with 1101
    BEQ         Opcode_BLT              ; if equal jump to BLT
    
    CMP.W       #$0800,D3               ; compare with 1000
    BEQ         Opcode_BVC              ; if equal jump to BVC

Skip_0110:
    CMP.W       #$4000,D2               ; compare with 0100
    BNE         Skip_0100               ; if not equal then skip
    MOVE.W      D6,D3                   ; move current word into working register (D3)
    
    CMP.W       #$4E71,D3               ; check against constant NOP code
    BEQ         Opcode_NOP              ; if equal jump to NOP

    CMP.W       #$4AFC,D3               ; check against constant ILLEGAL code
    BEQ         Opcode_ILLEGAL          ; if equal jump to ILLEGAL
    
    CMP.W       #$4E75,D3               ; check against constant RTS code
    BEQ         Opcode_RTS              ; if equal jump to RTS
    AND         #MASK_8,D3              ; mask bit 8
   

    CMP         #$0100,D3               ; compare with 1
    BEQ         Opcode_LEA              ; if equal jump to LEA
    MOVE.W      D6,D3                   ; refresh current word into D3
    AND         #MASK_11,D3             ; mask bit 11
    
    CMP         #$0000,D3               ; compare with 0
    BEQ         Opcode_NEG              ; if equal jump to NEG
    MOVE.W      D6,D3                   ; refresh current word into D3
    AND         #MASK_9,D3              ; mask bit 9
    
    CMP         #$0000,D3               ; compare with 0
    BEQ         Opcode_MOVEM            ; if equal jump to MOVEM
    BNE         Opcode_JSR              ; if not equal jump to JSR  

Skip_0100:
    CMP.W       #$FFFF,D6               ; compare with FFFF
    BEQ         Opcode_SIMHALT          ; if equal jump to SIMHALT
    
    BRA         Opcode_DATA             ; if no opcodes found jump to DATA



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
