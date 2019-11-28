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
MXn:
    MOVEM.L  D0-D5/A0,-(SP)
    MOVE.L  D6,-(SP)
    
    AND.L   #MASK_543,D6
    
    CMP     #$0000,D6
    BEQ     MXn_SetDn
    
    CMP     #$0008,D6
    BEQ     MXn_SetAn
    
    CMP     #$0010,D6
    BEQ     MXn_SetAnInd 
    
    CMP     #$0018,D6
    BEQ     MXn_SetAnPostInc
        
    CMP     #$0020,D6
    BEQ     MXn_SetAnPreDec

    CMP     #$0038,D6
    BEQ     MXn_SetElse   
 
MXn_SetDn    
    LEA     EA_StrArray_Dn,A0
    BRA     MXn_GetRegister
  
MXn_SetAn    
    LEA     EA_StrArray_An,A0
    BRA     MXn_GetRegister
    
MXn_SetAnInd   
    LEA     EA_StrArray_AnInd,A0
    BRA     MXn_GetRegister

MXn_SetAnPreDec
    LEA     EA_StrArray_AnPreDec,A0
    BRA     MXn_GetRegister

MXn_SetAnPostInc    
    LEA     EA_StrArray_AnPostInc,A0
    BRA     MXn_GetRegister

MXn_SetElse    
    LEA     EA_StrArray_Else,A0
    BRA     MXn_GetImmOrAbs


MXn_GetRegister
    MOVE.L  (SP),D6
    AND.L   #MASK_210,D6
    MULU    #02,D6          ; multiply by 2 because the string arrays are word-ordered
    MOVE.W  (A0,D6),D6      ; D6 stores destination EA String
    MOVE.L  #$FFFFFFFF,D7       ; set the destination value to null 
    BRA     MXn_Return

MXn_GetImmOrAbs
    CLR.L        D7                  ; clear D7 to make way for what's about to happen
    MOVE.L      (SP),D6
    AND.L       #MASK_210,D6
 
   
    CMP         #$0004,D6
    BEQ         MXn_GetImmediate
    
    CMP         #$0001,D6
    BEQ         MXn_GetLong


    
    MOVE.W      4(A0),D6            ; move the '#$' value into D6
    MOVE.W      2(A3),D7            ; store the next word in D7
    ADDA        #02,A3              ; increment A3 to skip the word we just processed
    BRA         MXn_Return
    
    
MXn_GetLong
    MOVE.W      2(A0),D6            ; move the '#$' value into D6 
    MOVE.L      2(A3),D7            ; store the next long in D7
    ADDA        #04,A3              ; increment A3 to skip the long we just processed
    BRA         MXn_Return
  
MXn_GetImmediate
    MOVE.W      (A0),D6             ; move the '#' value into D6
    MOVE.W      2(A3),D7            ; move the next word into D7
    AND.W       #$0F,D7             ; mask the word in D7 to a byte       
    ADDA        #02,A3              ; increment A3 to skip the word we just processed
    BRA         MXn_Return
        
MXn_Return
    ADDA        #04,SP
    MOVEM.L     (SP)+,D0-D5/A0
    RTS


    ; mask 543
    ; check value against 8 possible addressing methods
    ; mask 210
    ; interpret
    ; append ASCII to output string
    RTS

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
* Positions 76 contain size values
*   76      Size
*   00      .B
*   01      .W
*   10      .L
Size76:
    MOVE.W   D6, D3             ; move current word into working register
    AND.W    #MASK_76, D3       ; mask bits 7, 6
    CMP.W   #$0000, D3          ; compare with 00
    BEQ     Size76_B            ; if equal goto B 
    CMP.W   #$0040, D3          ; compare with 01
    BEQ     Size76_W            ; if equal goto W
    CMP.W   #$0080, D3          ; compare with 10
    BEQ     Size76_L            ; if equal goto L
                                ; if bytes are 11 there is an error, not handling this currently
Size76_B:
    LEA STRING_B, A2
    JSR AppendOutput            ; write '.B' to the output string
    RTS

Size76_W:
    LEA STRING_W, A2
    JSR AppendOutput            ; write '.W' to the output string
    RTS

Size76_L:
    LEA STRING_L, A2
    JSR AppendOutput            ; write '.L' to the output string
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

* Displacement deals with bit values in positions 76543210
* This value will be interpreted as a numerical displacement
* If this value is 00000000, then the next word will be the numerical displacement
Displacement:
    ; mask 76543210
    ; check against 00000000
    ; if 0 then get next word
    ; append ASCII to A1
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
    MOVE.W  STRINGCOMMA, A2     ; move string comma into A2
    JSR     AppendOutput        ; print string in A2
    RTS

* Data11109 checks the bits 11, 10, 9 and interprets them as a immediate value
* Possible output values are 1-8 (001 = 1, 010 = 2 ... 000 = 8)
* Value will be appended with '#' and appended to the output string
Data11109:
    ; mask bits 11, 10, 9
    ; convert to decimal?  (possible values are 1-8)
    ; output '#'
    ; output numeric value
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
