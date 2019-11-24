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
    ; append ASCII to A1
    RTS

* Size76 deals with bit values in positions 7,6
* Positions 76 contain size values
*   76      Size
*   00      .B
*   01      .W
*   10      .L
Size76:
    ; mask 76
    ; check value against 3 possible sizes
    ; append ASCII to A1
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
    MOVE.W  D6,D3           ; move word into D3
    AND.W   #MASK_11109, D3  ; mask bits 11, 10, 9 
    ROL.W   #7,D3           ; rotate so bits are in least significant spot
    MULU.W  #2,D3           ; multiply by 2 so offset is measured in words not bytes
    LEA     EA_StrArray_Dn, A4       
    MOVE.W  (A4,D3),A2   ; move string value from StrArray_Dn with offset D3 into A2
    JSR     AppendOutput    ; print string in A2
    RTS

* An deals with bit values in positions 11,10,9
* Value in this position will correspond to a A register
* Value 000 is A0, value 001 is A1, etc
An:
    MOVE.W  D6,D3           ; move word into D3
    AND.W   #MASK_11109, D3  ; mask bits 11, 10, 9 
    ROL.W   #7,D3           ; rotate so bits are in least significant spot
    MULU.W  #2,D3           ; multiply by 2 so offset is measured in words not bytes
    LEA     EA_StrArray_An, A4       
    MOVE.W  (A4,D3),A2   ; move string value from StrArray_An with offset D3 into A2
    JSR     AppendOutput    ; print string in A2
    RTS

* The comma function appends a comma and a space ', ' to the output
Comma:
    MOVE.W STRCOMMA, A2     ; move string comma into A2
    JSR     AppendOutput    ; print string in A2
    RTS