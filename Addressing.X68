*-----------------------------------------------------------
* Title      :  Addressing.X68
* Written by :  Kyle Dukart
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       Once the Determine_Opcode and Breakdown_Opcode has run, it will jump to
*       one or more of these subroutines to process the addressing information.
*       These subroutines will append the correct ASCII values in (A1).
* Preconditions: D6 contains word length opcode
*                string constants are in Gbl_CONST.X68
*-----------------------------------------------------------



* MXn deals with bit values in positions 5,4,3,2,1,0
* Positions 543 contain addressing methods
* Positions 210 contain register number or hard coded value
*   543     Addr. Method    Xn
*   000     Dn              Register #
*   001     An              Register #
*   010     (An)            Register #
*   011     (An)+           Register #
*   100     -(An)           Register #
*   111     #               100
*   111     .L              001
*   111     .W              000
EA_AppendMXn:
    
    MOVEM.L  D0-D5/A1,-(SP)
    MOVE.L  D6,-(SP)
    
    MOVE.L  D6,D3                   ; copy the current address into d3 for processing
    AND.L   #MASK_543,D3
    
    
    CMP     #MODE_Dn,D3             ; check if mode = Dn, data reg direct
    BEQ     MXn_SetDn
    
    CMP     #Mode_An,D3             ; check if mode = An, address reg direct
    BEQ     MXn_SetAn
    
    CMP     #Mode_AnInd,D3          ; check if mode = (An), address reg indirect
    BEQ     MXn_SetAnInd 
    
    CMP     #Mode_AnPostInc,D3      ; check if mode = -(An), address reg post increment
    BEQ     MXn_SetAnPostInc
        
    CMP     #Mode_AnPreDec,D3       ; chec if mode = (An)+, address reg pre decrement
    BEQ     MXn_SetAnPreDec

    CMP     #Mode_Else,D3           ; check if mode = Immediate or Absolute word or long
    BEQ     MXn_SetElse   
 
MXn_SetDn    
    LEA     EA_StrArray_Dn,A2
    BRA     MXn_GetRegister
  
MXn_SetAn    
    LEA     EA_StrArray_An,A2
    BRA     MXn_GetRegister
    
MXn_SetAnInd   
    LEA     EA_StrArray_AnInd,A2
    BRA     MXn_GetRegister

MXn_SetAnPreDec
    LEA     EA_StrArray_AnPreDec,A2
    BRA     MXn_GetRegister

MXn_SetAnPostInc    
    LEA     EA_StrArray_AnPostInc,A2
    BRA     MXn_GetRegister

MXn_SetElse    
    LEA     EA_StrArray_Else,A2
    BRA     MXn_GetImmOrAbs


MXn_GetRegister
    MOVE.L      (SP),D3
    AND.L       #MASK_210,D3
    MULU        #02,D3              ; multiply by 2 because the string arrays are word-ordered
    MOVE.W      (A2,D3),A2          ; A2 stores destination EA String
    JSR         AppendOutput        ; AppendOutput prints the MXn result 
    
    BRA         MXn_Return

MXn_GetImmOrAbs
    CLR.L        D3                 ; clear D3 to prep for masking rightmost bits
    MOVE.L      (SP),D3             ; copy address into D3 for processing
    AND.L       #MASK_210,D3        ; mask to read addressin type
    
    CMP         #MODE_Imm,D3        ; check if address = Immediate (#)
    BEQ         MXn_GetImmediate
  
  
    CMP         #MODE_AbsLong,D3    ; check if address = Absolute Long (xxx.L)
    BEQ         MXn_GetLong


                                    ; address = Absolute Word (xxx.W)
    MOVE.W      4(A2),A2            ; move the '#$' value into A2
    JSR         AppendOutput        ; print 
    
    MOVE.W      2(A3),D6            ; store the next word in D6
    JSR         PrintASCIIWord      ; PrintAsciiWord uses d6 as input
           
    ADDA        #02,A3              ; increment A3 to skip the word we just processed
    BRA         MXn_Return
    
    
MXn_GetLong
    MOVE.W      2(A2),A2            ; move the '#$' value into A2 
    JSR         AppendOutput    
    MOVE.L      2(A3),D6            ; pull the next long in D6
    JSR         PrintASCIILong      ; PrintAsciiWord uses d6 as input
    
    ADDA        #04,A3              ; increment A3 to skip the long we just processed
    BRA         MXn_Return
  
MXn_GetImmediate
    MOVE.W      (A2),A2             ; move the '#' value into A2
    JSR         AppendOutput
    
    MOVE.W      2(A3),D3            ; pull the next word into D3
    AND.W       #$0F,D6             ; mask the word in D6 to a byte       
    JSR         PrintASCIIWord      ; PrintAsciiWord uses d6 as input
    
    ADDA        #02,A3              ; increment A3 to skip the word we just processed
    BRA         MXn_Return
        
MXn_Return    
    ADDA        #04,SP
    MOVEM.L     (SP)+,D0-D5/A1
    RTS


    ; mask 543
    ; check value against 8 possible addressing methods
    ; mask 210
    ; interpret
    ; append ASCII to output string
    ;RTS

* XnM deals with bit values in positions 11,10,9,8,7,6
* Positions 876 contain addressing methods
* Positions 11109 contain register number or hard coded value
*   876     Addr. Method    Xn
*   000     Dn              Register #
*   001     An              Register #
*   010     (An)            Register #
*   011     (An)+           Register #
*   100     -(An)           Register #
*   111     #               100
*   111     .L              001
*   111     .W              000
XnM:
    ; mask 876
    ; check value against 8 possible addressing methods
    ; mask 11109
    ; interpret
    ; append ASCII to output string
    RTS

* Size76 deals with bit values in positions 7,6
* Positions 76 contain size values, function will set D4
*   76      Size    D4
*   00      .B      00
*   01      .W      01
*   10      .L      10
Size76:
    MOVE.W   D6, D3             ; move current word into working register
    AND.W    #MASK_76, D3       ; mask bits 7, 6
    CMP.W   #$0000, D3          ; compare with 00
    BEQ     Opcode_AppendSizeSuffix_B            ; if equal goto B 
    CMP.W   #$0040, D3          ; compare with 01
    BEQ     Opcode_AppendSizeSuffix_W            ; if equal goto W
    CMP.W   #$0080, D3          ; compare with 10
    BEQ     Opcode_AppendSizeSuffix_L            ; if equal goto L
                                ; if bytes are 11 there is an error, not handling this currently
Opcode_AppendSizeSuffix_B:
    LEA STRING_B, A2
    JSR AppendOutput            ; write '.B' to the output string
    MOVE.W  #$0000, D4          ; set D4 to 00
    RTS

Opcode_AppendSizeSuffix_W:
    LEA STRING_W, A2
    JSR AppendOutput            ; write '.W' to the output string
    MOVE.W  #$0001, D4          ; set D4 to 01
    RTS

Opcode_AppendSizeSuffix_L:
    LEA STRING_L, A2
    JSR AppendOutput            ; write '.L' to the output string
    MOVE.W  #$0002, D4          ; set D4 to 10
    RTS

* Size8 checks bit 8 and interprets it as a Word or Long
* Corresponding ASCII value will be appended to the output string
Size8:
    MOVE.W  D6, D3              ; move current word into working register
    AND.W   #MASK_8, D3         ; mask bit 8
    CMP.W   #$0000, D3          ; compare with D3
    BEQ     Size8_W             ; if equal goto W
Size8_L:                        ; if not equal fall through to L
    LEA STRING_L, A2
    JSR AppendOutput            ; write '.L' to the output string
    RTS
Size8_W:                
    LEA STRING_W, A2
    JSR AppendOutput            ; write '.W' to the output string
    RTS

* Size6 checks bit 6 and interprets it as a Word or Long
* Corresponding ASCII value will be appended to the output string
Size6:
    MOVE.W  D6, D3              ; move current word into working register
    AND.W   #MASK_6, D3         ; mask bit 8
    CMP.W   #$0000, D3          ; compare with D3
    BEQ     Size6_W             ; if equal goto W
Size6_L:                        ; if not equal fall through to L
    LEA STRING_L, A2
    JSR AppendOutput            ; write '.L' to the output string
    RTS
Size6_W:                
    LEA STRING_W, A2
    JSR AppendOutput            ; write '.W' to the output string
    RTS

* Displacement deals with bit values in positions 76543210
* This value will be interpreted as a numerical displacement
* If this value is 00000000, then the next word will be the numerical displacement
Displacement:
    MOVE.W  D6, D3              ; move current word into working register
    AND.W   #MASK_76543210, D3  ; mask so only the bottom byte is available
    CMP.W   #$0000, D3          ; compare with 0
    BEQ Displacement_Fetch_Word
    MOVE.L      D6,-(SP)        ; move D6 to stack for preservation
    MOVE.W      D3, D6          ; move masked value into D6 for printing
    JSR PrintASCIIWord          
    MOVE.L      (SP)+,D6        ; pop D6 from stack
    RTS
Displacement_Fetch_Word:
    ; get next word from file
    ; convert to ASCII and print
    RTS

* Dn deals with bit values in positions 11,10,9
* Value in this position will correspond to a D register
* Value 000 is D0, value 001 is D1, etc
Dn:
    MOVE.W  D6,D3               ; move word into D3
    AND.W   #MASK_11109, D3     ; mask bits 11, 10, 9 
    ROL.W   #7,D3               ; rotate so bits are in least significant spot
    MULU.W  #2,D3               ; multiply by 2 so offset is measured in words not bytes
    LEA     EA_StrArray_Dn, A4       
    MOVE.W  (A4,D3),A2          ; move string value from StrArray_Dn with offset D3 into A2
    JSR     AppendOutput        ; print string in A2
    RTS

* Dn210 deals with bit values in positions 2,1,0
* Value in this position will correspond to a D register
* Value 000 is D0, value 001 is D1, etc
Dn210:
    MOVE.W  D6,D3               ; move word into D3
    AND.W   #MASK_210, D3       ; mask bits 2, 1, 0
    MULU.W  #2,D3               ; multiply by 2 so offset is measured in words not bytes
    LEA     EA_StrArray_Dn, A4       
    MOVE.W  (A4,D3),A2          ; move string value from StrArray_Dn with offset D3 into A2
    JSR     AppendOutput        ; print string in A2
    RTS

* An deals with bit values in positions 11,10,9
* Value in this position will correspond to a A register
* Value 000 is A0, value 001 is A1, etc
An:
    MOVE.W  D6,D3               ; move word into D3
    AND.W   #MASK_11109, D3     ; mask bits 11, 10, 9 
    ROL.W   #7,D3               ; rotate so bits are in least significant spot
    MULU.W  #2,D3               ; multiply by 2 so offset is measured in words not bytes
    LEA     EA_StrArray_An, A4       
    MOVE.W  (A4,D3),A2          ; move string value from StrArray_An with offset D3 into A2
    JSR     AppendOutput        ; print string in A2
    RTS

* The comma function appends a comma and a space ', ' to the output
Comma:
    LEA     STRINGCOMMA, A2     ; move string comma into A2
    JSR     AppendOutput        ; print string in A2
    RTS

* Data11109 checks the bits 11, 10, 9 and interprets them as a immediate value
* Possible output values are 1-8 (001 = 1, 010 = 2 ... 000 = 8)
* Value will be appended with '#' and appended to the output string
Data11109:
    MOVE.W  D6, D3              ; move current word into working register
    AND     MASK_11109, D3      ; mask bits 11, 10, 9
    MOVEA   Hex_StrArray, A4    ; Move the base array into A4
    LEA     OUTPUT, A2          ; move address of output into A2
    ROL     #7, D3              ; rotate left 7 so bits are in least significant position
    MULS    #2, D3              ; multiply by 2 for correct array offset
    MOVE.W  (A4,D3), (A2)       ; move ASCII char into A2
    JSR AppendOutput
    RTS

RegisterList:
    ; get next word
    ; interpret next word as list of registers
    ; print ASCII list of registers
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
