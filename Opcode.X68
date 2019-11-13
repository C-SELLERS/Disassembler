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
    MOVEM.L D2-D3, -(SP)            ; MOVEM all registers used
    
    MOVE.W D6,D2         ; copy current word (D6) into opcode mask register (D2)
    AND MASK_OPCODE,D2   ; apply mask to first 4 bits
    
    CMP.W #$9000,D2      ; compare with 1001
    BEQ SUB              ; if equal jump to SUB
    
    CMP.W #$5000,D2      ; compare with 1010
    BEQ SUBQ             ; if equal jump to SUBQ
    
    CMP.W #$C000,D2      ; compare with 1100
    BEQ MULS             ; if equal jump to MULS
    
    CMP.W #$0000,D2      ; compare with 0000
    BNE Skip_0000        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_1110,D3     ; mask bits 11, 10
    CMP.W #$0000,D3      ; compare with 00
    BEQ ORI              ; if equal jump to ORI
    CMP.W #$0C00         ; compare with 11
    BEQ CMPI             ; if equal jump to CMPI
    CMP.W #$0800         ; compare with 10
    BEQ BCLR             ; if equal jump to BCLR
Skip_0000:
    
    CMP.W #$D000,D2      ; compare with 1101
    BNE Skip_1101        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_76,D3       ; mask bits 7, 6
    CMP.W #$00C0,D3      ; compare with 11
    BEQ ADDA             ; if equal jump to ADDA
    BNE ADD              ; if not equal jump to ADD
Skip_1101:

    CMP.W #$8000,D2      ; compare with 1000
    BNE Skip_1000        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_76,D3       ; mask bits 7, 6
    CMP.W #$00C0,D3      ; compare with 11
    BEQ DIVS             ; if equal jump to DIVS
    BNE OR               ; if not equal jump to OR
Skip_1000:
 
    CMP.W #$B000,D2      ; compare with 1011
    BNE Skip_1011        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_8,D3        ; mask bit 8
    CMP.W #$0000,D3      ; compare with 0
    BEQ CMP              ; if equal jump to CMP
    BNE EOR              ; if not equal jump to EOR
Skip_1011:

    CMP.W #$1000,D2      ; compare with 0001
    BNE Skip_0001        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_876,D3      ; mask bits 8, 7, 6
    CMP.W #$0040,D3      ; compare with 001
    BEQ MOVEA_B          ; if equal jump to MOVEA_B
    BNE MOVE_B           ; if not equal jump to MOVE_B
Skip_0001:

    CMP.W #$3000,D2      ; compare with 0011
    BNE Skip_0011        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_876,D3      ; mask bits 8, 7, 6
    CMP.W #$0040,D3      ; compare with 001
    BEQ MOVEA_W          ; if equal jump to MOVEA_W
    BNE MOVE_W           ; if not equal jump to MOVE_W
Skip_0011:

    CMP.W #$2000,D2      ; compare with 0010
    BNE Skip_0010        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_876,D3      ; mask bits 8, 7, 6
    CMP.W #$0040,D3      ; compare with 001
    BEQ MOVEA_L          ; if equal jump to MOVEA_L
    BNE MOVE_L           ; if not equal jump to MOVE_L
Skip_0010:

    CMP.W #$E000,D2      ; compare with 1110
    BNE Skip_1110        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_843,D3      ; mask bits 8, 4, 3
    CMP.W #$0118,D3      ; compare with 111
    BEQ ROL              ; if equal jump to ROL
    CMP.W #$0018,D3      ; compare with 011
    BEQ ROR              ; if equal jump to ROR
    CMP.W #$0108,D3      ; compare with 101
    BEQ LSL              ; if equal jump to LSL
    CMP.W #$0008,D3      ; compare with 001
    BEQ LSR              ; if equal jump to LSR
    CMP.W #$0100,D3      ; compare with 100
    BEQ ASL              ; if equal jump to ASL
    CMP.W #$0000,D3      ; compare with 000
    BEQ ASR              ; if equal jump to ASR
Skip_1110:

    CMP.W #$6000,D2      ; compare with 0110
    BNE Skip_0110        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    AND MASK_111098,D3   ; mask bits 11, 10, 9, 8
    CMP.W #$0000,D3      ; compare with 0000
    BEQ BRA              ; if equal jump to BRA
    CMP.W #$0500,D3      ; compare with 0101
    BEQ BCS              ; if equal jump to BCS
    CMP.W #$0C00,D3      ; compare with 1100
    BEQ BGE              ; if equal jump to BGE
    CMP.W #$0D00,D3      ; compare with 1101
    BEQ BLT              ; if equal jump to BLT
    CMP.W #$0800,D3      ; compare with 1000
    BEQ BVC              ; if equal jump to BVC
Skip_0110:

    CMP.W #$4000,D2      ; compare with 0100
    BNE Skip_0100        ; if not equal then skip
    MOVE.W D6,D3         ; move current word into working register (D3)
    CMP.W #$4E75,D3      ; check against constant RTS code
    BEQ RTS              ; if equal jump to RTS
    AND MASK_8,D3        ; mask bit 8
    CMP #$0100,D3        ; compare with 1
    BEQ LEA              ; if equal jump to LEA
    MOVE.W D6,D3         ; refresh current word into D3
    AND MASK_11,D3       ; mask bit 11
    CMP #$0000,D3        ; compare with 0
    BEQ NEG              ; if equal jump to NEG
    MOVE.W D6,D3         ; refresh current word into D3
    AND MASK_9,D3        ; mask bit 9
    CMP #$0000,D3        ; compare with 0
    BEQ MOVEM            ; if equal jump to MOVEM
    BNE JSR              ; if not equal jump to JSR  
Skip_0100:

DATA:
    ; print
    MOVEM.L (SP)+, D2-D3
    RTS

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
BCS:
BGE:
BLT:
BVC:
RTS:
LEA:
NEG:
MOVEM:
JSR:

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
