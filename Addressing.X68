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
    MOVE.M  D6, D3              ; move current word into working register
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
    MOVE.W  STRINGCOMMA, A2     ; move string comma into A2
    JSR     AppendOutput        ; print string in A2
    RTS

* Data11109 checks the bits 11, 10, 9 and interprets them as a immediate value
* Possible output values are 1-8 (001 = 1, 010 = 2 ... 000 = 8)
* Value will be appended with '#' and appended to the output string
Data11109:
    MOVE.W  D6, D3              ; move current word into working register
    AND     MASK_11109, D3      ; mask bits 11, 10, 9
    MOVEA   Immediate_StrArray, A4    ; Move the base array into A4
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