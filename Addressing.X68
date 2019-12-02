*=====================================================================================================================
* Title      :  Addressing.X68
* Written by :  Kyle Dukart
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       Once the Determine_Opcode and Breakdown_Opcode has run, it will jump to
*       one or more of these subroutines to process the addressing information.
*       These subroutines will append the correct ASCII values in (A1).
* Preconditions: D6 contains word length opcode
*                string constants are in Gbl_CONST.X68
*=====================================================================================================================

*=====================================================================================================================

*---------------------------------------------------------------------------------------------------------------------
* EA_AppendMXn
* 
* MXn deals with bit values in positions 5,4,3,2,1,0. Positions 543 contain addressing methods. 
* This processing is delegated to EA_AppendModeRegister using the flag 'isMXn'. 
*
* Pre: 
*   - D6 contains the current opcode 
*   - 
*   
* Post: 
*   - 
*   
* Notes: 
*   
* Positions 210 contain register number or hard coded value
*   543     Addr. Method    Xn
*   000     Dn              Register #
*   001     An              Register #
*   010     (An)            Register #
*   011     (An)+           Register #
*   100     -(An)           Register #
*   111     #               100
*   111     .W              000
*   111     .L              001
*---------------------------------------------------------------------------------------------------------------------
EA_AppendMXn:
    JSR         EA_SetIsMXn
    JSR         EA_AppendModeRegister
    RTS


*---------------------------------------------------------------------------------------------------------------------
* EA_AppendMXn
* 
* XnM deals with bit values in positions 11,10,9,8,7,6. Positions 876 contain addressing methods.
* This processing is delegated to EA_AppendModeRegister using the flag 'isXnM'. 
*
* Pre: 
*   - D6 contains the current opcode 
*   
* Post: 
*   - 
*   
* Notes: 
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
*---------------------------------------------------------------------------------------------------------------------
EA_AppendXnM:
    JSR         EA_SetIsXnM
    JSR         EA_AppendModeRegister
    JSR         EA_SetIsMXn
    RTS



*---------------------------------------------------------------------------------------------------------------------
* EA_AppendModeRegister
* 
* AppendModeRegister actually does the work that MXn and XnM claim to do. It uses MXn as the base fuctionality to read
* bits and make decisions about the mode and register reported by the opcode. A pair of flags ('isMXn' and 'isXnM') 
* are used to perform bit shifting when appropriate so that the same functionality can be shared between the 543 and 
* 543 register 
*
* Pre: 
*   - D6
*   - 
*   
* Post: 
*   - Mode and register information appended to the output buffer
*   - 
*   
* Notes: 
*   
* Positions 210 contain register number or hard coded value
*   543     Addr. Method    Xn
*   000     Dn              Register #
*   001     An              Register #
*   010     (An)            Register #
*   011     (An)+           Register #
*   100     -(An)           Register #
*   111     #               100
*   111     .W              000
*   111     .L              001
*---------------------------------------------------------------------------------------------------------------------
EA_AppendModeRegister:
    MOVEM.L     D0-D5/A1,-(SP)
    MOVE.L      D6,-(SP)
    MOVE.L      D6,D3                           ; copy the current address into d3 for processing
    
    JSR         EA_GetStandardModeInD3
    
    CMP         #MODE_Dn,D3                     ; check if mode = Dn, data reg direct
    BEQ         EA_SetStrArray_Dn
    
    CMP         #Mode_An,D3                     ; check if mode = An, address reg direct
    BEQ         EA_SetStrArray_An
    
    CMP         #Mode_AnInd,D3                  ; check if mode = (An), address reg indirect
    BEQ         EA_SetStrArray_AnInd 
    
    CMP         #Mode_AnPostInc,D3              ; check if mode = -(An), address reg post increment
    BEQ         EA_SetStrArray_AnPostInc
        
    CMP         #Mode_AnPreDec,D3               ; chec if mode = (An)+, address reg pre decrement
    BEQ         EA_SetStrArray_AnPreDec

    BRA         EA_ProcessElse
    

EA_SetStrArray_Dn    
    LEA         EA_StrArray_Dn,A2
    BRA         EA_AppendRegisterName
  
EA_SetStrArray_An    
    LEA         EA_StrArray_An,A2
    BRA         EA_AppendRegisterName
    
EA_SetStrArray_AnInd   
    LEA         EA_StrArray_AnInd,A2
    BRA         EA_AppendRegisterName

EA_SetStrArray_AnPreDec
    LEA         EA_StrArray_AnPreDec,A2
    BRA         EA_AppendRegisterName    

EA_SetStrArray_AnPostInc    
    LEA         EA_StrArray_AnPostInc,A2
    BRA         EA_AppendRegisterName


EA_AppendRegisterName
    JSR         EA_GetStandardRegInD3
    MULU        #ARRAY_ELEMENT_WIDTH,D3         ; multiply by 2 because the string arrays are word-ordered
    MOVE.W      (A2,D3),A2                      ; A2 stores destination EA String
    JSR         AppendOutput                    ; AppendOutput prints the MXn result 
    BRA         EA_Return


EA_ProcessElse
    JSR         EA_GetStandardRegInD3
    
    CMP         #MODE_Imm,D3
    BEQ         EA_ProcessImmediate
    
    CMP         #MODE_AbsWord,D3
    BEQ         EA_ProcessAbsoluteWord
        
    BRA         EA_ProcessAbsoluteLong 

EA_ProcessImmediate
    JSR         OpcodeSize_GetSize
    
    CMP         #OPCODESIZE_BYTE,D0
    BEQ         EA_ProcessImmediateByte

    CMP         #OPCODESIZE_WORD,D0
    BEQ         EA_ProcessImmediateWord

    BRA         EA_ProcessImmediateLong


EA_ProcessImmediateByte
    LEA         EA_Str_Hash,A2                  ; move the '#' value into A2
    JSR         AppendOutput
    
    JSR         Get_Next_Word_D6                ; pull the next word into D3
    AND.W       #$0F,D6                         ; mask the word in D6 to a byte
    JSR         PrintASCIIWord                  ; PrintAsciiWord uses d6 as input
    BRA         EA_Return

EA_ProcessImmediateWord
    LEA         EA_Str_HashDollar,A2                  ; move the '#' value into A2
    JSR         AppendOutput
    
    JSR         Get_Next_Word_D6                ; pull the next word into D3
    JSR         PrintASCIIWord                  ; PrintAsciiWord uses d6 as input
    BRA         EA_Return
     
EA_ProcessImmediateLong    
    LEA         EA_Str_HashDollar,A2                  ; move the '#' value into A2
    JSR         AppendOutput
    
    JSR         Get_Next_Long_D7                ; pull the next word into D3
    MOVE.L      D7,D6
    JSR         PrintASCIIWord                  ; PrintAsciiWord uses d6 as input
    BRA         EA_Return



EA_ProcessAbsoluteWord
    LEA         EA_Str_Dollar,A2            ; move the '#$' value into A2
    JSR         AppendOutput
   
    JSR         Get_Next_Word_D6                ; pull the next word into D3
    JSR         PrintASCIIWord                  ; PrintAsciiWord uses d6 as input
    BRA         EA_Return


EA_ProcessAbsoluteLong
    LEA         EA_Str_Dollar,A2            ; move the '#$' value into A2
    JSR         AppendOutput

    JSR         Get_Next_Long_D7                ; pull the next word into D3
    MOVE.L      D7,D6
    JSR         PrintASCIILong                  ; PrintAsciiWord uses d6 as input
    BRA         EA_Return


EA_Return    
    MOVE.L      (SP)+,D6
    MOVEM.L     (SP)+,D0-D5/A1                  ; clean up the other stack storage
    RTS





*---------------------------------------------------------------------------------------------------------------------
* EA_GetStandardModeInD3
* 
* Masks and shifts the opcode until the bits specify the Effective Addressing mode are located in bit 
* position 5/4/3. Uses EA_GetIsXnM to determine if the whether shifting is necessary. 
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - D3 contains the EA Mode-identifying bits in position 5/4/3
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
EA_GetStandardModeInD3
    MOVE.L      D4,-(SP)
    MOVE.L      D6,D3                           ; copy the current address into d3 for processing
    JSR         EA_GetIsXnM                     ; determine if this is MXn, or XnM, 
                                                ; which determines which bits we inspect
    CMP         #IsTrue,D0                      ; if MXn, no bit shifting is required
    BEQ         EA_ShiftXnM_Mode
    BNE         EA_Mask_Mode             ; if XnM, shift over 3 bits so bits 8/7/6 can be treated like 5/4/3
    
EA_ShiftXnM_Mode
    MOVE.L      #EA_MODE_ASRL_DISTANCE,D4
    ASR.L       D4,D3                           ; shift to the right so the MODE masks align
      
EA_Mask_Mode  
    AND.L       #MASK_543,D3
    MOVE.L      (SP)+,D4
    RTS

    
*---------------------------------------------------------------------------------------------------------------------
* EA_GetStandardRegInD3
* 
* Masks and shifts the opcode until the bits specify the Effective Addressing register are located in bit 
* positions 2/1/0. Uses EA_GetIsXnM to determine if the whether shifting is necessary. 
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - D3 contains the EA register-identifying bits in position 2/1/0
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
EA_GetStandardRegInD3
    MOVE.L      D4,-(SP)   
    MOVE.L      D6,D3                           ; copy the current address into d3 for processing
    JSR         EA_GetIsXnM                     ; determine if this is MXn, or XnM, 
                                                ; which determines which bits we inspect
    CMP         #IsTrue,D0                      ; if MXn, no bit shifting is required
    BEQ         EA_ShiftXnM_Register            ; if XnM, shift over 3 bits so bits 8/7/6 can be treated like 5/4/3
    BNE         EA_Mask_Register
    
EA_ShiftXnM_Register
    MOVE.L      #EA_REGISTER_ASRL_DISTANCE,D4
    ASR.L       D4,D3                           ; shift to 543 for use with the standar MODE masks
    
EA_Mask_Register    
    AND.L       #MASK_210,D3
    MOVE.L      (SP)+,D4
    RTS



*---------------------------------------------------------------------------------------------------------------------
* Opcode_AppendSizeSuffix
* 
* Reads the Opcode size from bits 7/6 and appends the size suffix to the output buffer
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - D4: size of opcode (see below) 
*   - Output buffer: appended with opcode size suffix (.B, .W, or .L)
*   
* Notes: 
* Positions 76 contain size values, function will set D4
*   76      Size    D4
*   00      .B      00
*   01      .W      01
*   10      .L      10
*---------------------------------------------------------------------------------------------------------------------
Opcode_AppendSizeSuffix:
    MOVE.W      D6, D3                              ; move current word into working register
    AND.W       #MASK_76, D3                        ; mask bits 7, 6
    
    CMP.W       #$0000, D3                          ; compare with 00
    BEQ         Opcode_AppendSizeSuffix_B           ; if equal goto B 
    
    CMP.W       #$0040, D3                          ; compare with 01
    BEQ         Opcode_AppendSizeSuffix_W           ; if equal goto W
    
    CMP.W       #$0080, D3                          ; compare with 10
    BEQ         Opcode_AppendSizeSuffix_L           ; if equal goto L
                                                    ; if bytes are 11 there is an error, not handling this currently
Opcode_AppendSizeSuffix_B:
    LEA         STRING_B, A2
    JSR         AppendOutput                        ; write '.B' to the output string
    MOVE.W      #$0000, D4                          ; set D4 to 00
    JSR         OpcodeSize_SetToByte
    RTS

Opcode_AppendSizeSuffix_W:
    LEA         STRING_W, A2
    JSR         AppendOutput                        ; write '.W' to the output string
    MOVE.W      #$0001, D4                          ; set D4 to 01
    JSR         OpcodeSize_SetToWord
    RTS

Opcode_AppendSizeSuffix_L:
    LEA         STRING_L, A2
    JSR         AppendOutput                        ; write '.L' to the output string
    MOVE.W      #$0002, D4                          ; set D4 to 10
    JSR         OpcodeSize_SetToLong
    RTS

*---------------------------------------------------------------------------------------------------------------------
* Opcode_AppendSizeSuffix
* 
* Reads the Opcode size from bits 7/6 and appends the size suffix to the output buffer
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - D4: size of opcode (see below) 
*   - Output buffer: appended with opcode size suffix (.B, .W, or .L)
*   
* Notes: 
* Positions 76 contain size values, function will set D4
*   76      Size    D4
*   00      .B      00
*   01      .W      01
*   10      .L      10
*---------------------------------------------------------------------------------------------------------------------
* Size8 checks bit 8 and interprets it as a Word or Long
* Corresponding ASCII value will be appended to the output string
Size8:
    MOVE.W      D6, D3              ; move current word into working register
    AND.W       #MASK_8, D3         ; mask bit 8
    CMP.W       #$0000, D3          ; compare with D3
    BEQ         Size8_W             ; if equal goto W
Size8_L:                        ; if not equal fall through to L
    LEA         STRING_L, A2
    JSR         AppendOutput            ; write '.L' to the output string
    JSR         OpcodeSize_SetToLong
    RTS
Size8_W:                
    LEA         STRING_W, A2
    JSR         AppendOutput            ; write '.W' to the output string
    JSR         OpcodeSize_SetToWord
    RTS

* Size6 checks bit 6 and interprets it as a Word or Long
* Corresponding ASCII value will be appended to the output string
Size6:
    MOVE.W      D6, D3                  ; move current word into working register
    AND.W       #MASK_6, D3             ; mask bit 8
    CMP.W       #$0000, D3              ; compare with D3
    BEQ         Size6_W                 ; if equal goto W
Size6_L:                                ; if not equal fall through to L
    LEA         STRING_L, A2
    JSR         AppendOutput            ; write '.L' to the output string
    JSR         OpcodeSize_SetToLong
    RTS
Size6_W:                
    LEA         STRING_W, A2
    JSR         AppendOutput            ; write '.W' to the output string
    JSR         OpcodeSize_SetToWord
    RTS

    
*---------------------------------------------------------------------------------------------------------------------
* Displacement
* 
* Displacement deals with bit values in positions 76543210
* This value will be interpreted as a numerical displacement
* If this value is 00000000, then the next word will be the numerical displacement
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - 
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
Displacement:
    MOVE.W      D6, D3              ; move current word into working register
    AND.W       #MASK_76543210, D3  ; mask so only the bottom byte is available
    CMP.W       #$0000, D3          ; compare with 0
    BEQ         Displacement_Fetch_Word
    MOVE.L      D6,-(SP)        ; move D6 to stack for preservation
    MOVE.W      D3, D6          ; move masked value into D6 for printing
    JSR         PrintASCIIWord          
    MOVE.L      (SP)+,D6        ; pop D6 from stack
    RTS
Displacement_Fetch_Word:
    JSR         Get_Next_Word_D7
    MOVE.W      D6,-(SP)        ; move D6 to stack for preservation
    MOVE.W      D7, D6          ; move value into D6 for printing
    JSR         PrintASCIIWord
    MOVE.W      (SP)+,D6        ; pop D6 from stack
    RTS

    
    
*---------------------------------------------------------------------------------------------------------------------
* Dn
* 
* Dn deals with bit values in positions 11,10,9
* Value in this position will correspond to a D register
* Value 000 is D0, value 001 is D1, etc
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - 
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
Dn:
    MOVE.W      D6,D3               ; move word into D3
    AND.W       #MASK_11109, D3     ; mask bits 11, 10, 9 
    ROL.W       #7,D3               ; rotate so bits are in least significant spot
    MULU.W      #2,D3               ; multiply by 2 so offset is measured in words not bytes
    LEA         EA_StrArray_Dn, A4       
    MOVE.W      (A4,D3),A2          ; move string value from StrArray_Dn with offset D3 into A2
    JSR         AppendOutput        ; print string in A2
    RTS

    
*---------------------------------------------------------------------------------------------------------------------
* Dn210
* 
* Dn210 deals with bit values in positions 2,1,0
* Value in this position will correspond to a D register
* Value 000 is D0, value 001 is D1, etc
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - 
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
Dn210:
    MOVE.W      D6,D3               ; move word into D3
    AND.W       #MASK_210, D3       ; mask bits 2, 1, 0
    MULU.W      #2,D3               ; multiply by 2 so offset is measured in words not bytes
    LEA         EA_StrArray_Dn, A4       
    MOVE.W      (A4,D3),A2          ; move string value from StrArray_Dn with offset D3 into A2
    JSR         AppendOutput        ; print string in A2
    RTS


    
*---------------------------------------------------------------------------------------------------------------------
* An
* 
* An deals with bit values in positions 11,10,9
* Value in this position will correspond to a A register
* Value 000 is A0, value 001 is A1, etc
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - 
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
An:
    MOVE.W      D6,D3               ; move word into D3
    AND.W       #MASK_11109, D3     ; mask bits 11, 10, 9 
    ROL.W       #7,D3               ; rotate so bits are in least significant spot
    MULU.W      #2,D3               ; multiply by 2 so offset is measured in words not bytes
    LEA         EA_StrArray_An, A4       
    MOVE.W      (A4,D3),A2          ; move string value from StrArray_An with offset D3 into A2
    JSR         AppendOutput        ; print string in A2
    RTS

*---------------------------------------------------------------------------------------------------------------------
* AppendComma
* 
* The comma function appends a comma and a space ', ' to the output
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - 
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
AppendComma:
    LEA         STRINGCOMMA, A2     ; move string comma into A2
    JSR         AppendOutput        ; print string in A2
    RTS


*---------------------------------------------------------------------------------------------------------------------
* Data11109
* 
* Data11109 checks the bits 11, 10, 9 and interprets them as a immediate value
* Possible output values are 1-8 (001 = 1, 010 = 2 ... 000 = 8)
* Value will be appended with '#' and appended to the output string
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - 
*   
* Notes: 
*---------------------------------------------------------------------------------------------------------------------
Data11109:
    MOVE.W  D6, D3              ; move current word into working register
    AND.W   #MASK_11109, D3      ; mask bits 11, 10, 9
    MOVEA   Hex_StrArray, A4    ; Move the base array into A4
    ROL     #7, D3              ; rotate left 7 so bits are in least significant position
    CMP.W   #0, D3              ; check if D3 is 0
    BNE     Data11109_NOT_ZERO  ; if D3 is not zero, jump ahead
    ADD.W   #8, D3              ; if D3 is zero, add 8
Data11109_NOT_ZERO:
    MULS    #2, D3              ; multiply by 2 for correct array offset
    LEA     (A4,D3), A2         ; move ASCII char into A2
    JSR     AppendOutput
    RTS

* RegisterList will ask for a new word from input, and interpret it as a register list
* It will then output the corresponding registers to the output string
RegisterList_Predecrement:
    JSR         Get_Next_Word_D7        ; get next word into D7
    MOVEA       EA_StrArray_Dn, A4  ; move the base array into A4
    MOVE.W      #16, D4             ; move counter into D4 and set to 15
RL_LOOP:
    CMP.W       #0, D4              ; check for end of loop
    BEQ         RL_LOOP_END
    SUBQ        #1, D4                 ; decrement D4
    BTST        D4, D7                 ; test bit in position D4
    BNE         RL_LOOP
    MULU        #2, D4              ; multiply D4 by 2 for offset
    LEA         (A4, D4), A2
    JSR         AppendOutput            ; print register
    DIVS        #2, D4                  ; divide D4 by 2 for counter
    LEA         STRINGSLASH, A2       
    JSR         AppendOutput            ; print '/'
    BRA         RL_LOOP
RL_LOOP_END:
    LEA         OUTPUT, A1
    LEA         CURRENT_STR_LENGTH, A2
    ADD         (A2), A1
    MOVE.B      #00, (A1)
    RTS

RegisterList_Postincrement:
    ;todo
    RTS




    





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
