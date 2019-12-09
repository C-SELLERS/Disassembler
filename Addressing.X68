*=====================================================================================================================
* Title      :  Addressing.X68
* Written by : CSS 422 Best Group
*              
*   The CSS 422 Best Group is composed of: 
*       - Howie Catlin
*       - Kyle Dukart
*       - Colton Sellers 
*
* Date       : 10-Nov-2019
*
* Description: 
*   This file will be included in Main.X68 disassembler program Once the Determine_Opcode and Breakdown_Opcode has 
*   run, it will jump to one or more of these subroutines to process the addressing information.
*   These subroutines will append the correct ASCII values in (A1).
* 
* Preconditions: 
*   - D6: contains word length opcode string constants are in Gbl_CONST.X68
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
* Size8
* 
* Reads the Opcode size from bit 8 and appends the size suffix to the output buffer
* 
* Pre: 
*   - D6: current opcode
*   
* Post:  
*   - Output buffer: appended with opcode size suffix (.W or .L)
*   
* Notes: 
* Position 8 contains size values
*   8      Size
*   0      .W
*   1      .L
*---------------------------------------------------------------------------------------------------------------------
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

*---------------------------------------------------------------------------------------------------------------------
* Size6
* 
* Reads the Opcode size from bit 6 and appends the size suffix to the output buffer
* 
* Pre: 
*   - D6: current opcode
*   
* Post:  
*   - Output buffer: appended with opcode size suffix (.W or .L)
*   
* Notes: 
* Position 6 contains size value
*   6      Size
*   0      .W
*   1      .L
*---------------------------------------------------------------------------------------------------------------------
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
* If this value is 00000000, then the function will pull the next word from input and interpret
* that word as a numerical displacement
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - Numerical displacement is added to the output buffer
*---------------------------------------------------------------------------------------------------------------------
Displacement:
    MOVE.W      D6, D3              ; move current word into working register
    AND.W       #MASK_76543210, D3  ; mask so only the bottom byte is available
    CMP.W       #$0000, D3          ; compare with 0
    BEQ         Displacement_Fetch_Word
    MOVE.L      D6,-(SP)            ; move D6 to stack for preservation
    MOVE.W      D3, D6              ; move masked value into D6 for printing
    LEA         EA_Str_Dollar, A2   
    JSR         AppendOutput        ; print '$'
    JSR         Displacement_Print_Byte         
    MOVE.L      (SP)+,D6            ; pop D6 from stack
    RTS
Displacement_Fetch_Word:
    JSR         Get_Next_Word_D7
    MOVE.W      D6,-(SP)            ; move D6 to stack for preservation
    MOVE.W      D7, D6              ; move value into D6 for printing
    LEA         EA_Str_Dollar, A2   
    JSR         AppendOutput        ; print '$'
    JSR         Displacement_Print_Word
    MOVE.W      (SP)+,D6            ; pop D6 from stack
    RTS

Displacement_Print_Byte:
    EXT.W	    D6		            ; extend to word size
Displacement_Print_Word:
    EXT.L	    D6		            ; extend to long size
    MOVE.L	    D6, D3		        ; move to working register
    AND.L	    #$80000000, D3	    ; mask bit 15
    CMP.L	    #$00000000, D3      ; test bit 15
    BNE	        Displacement_Case_Negative

Displacement_Case_Positive:
    SUB.L	    #2, D6		        ; add 1 to increment location
    ADD.L	    A3, D6		        ; add current location
    JSR	        PrintASCIILong
    RTS

Displacement_Case_Negative:
    MOVE.L	    #$FFFFFFFE, D3	    ; move $FFFFFFFE to working register
    SUB.L	    D6, D3		        ; convert by subtracting input from $FFFFFFFE
    MOVE.L	    A3, D6		        ; move current address to D6
    SUB.L       #2, D6              ; add 2 to increment location
    SUB.L	    D3, D6		        ; subtract converted input from current address
    JSR	        PrintASCIILong	    ; print displacement
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
*   - The correct ASCII string will be appended to the output buffer
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
*   - The correct ASCII string will be appended to the output buffer
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
*   - The correct ASCII string will be appended to the output buffer
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
*   - The correct ASCII string will be appended to the output buffer
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
*   - The correct ASCII string will be appended to the output buffer
*---------------------------------------------------------------------------------------------------------------------
Data11109:
    MOVE.W  D6, D3              ; move current word into working register
    AND.W   #MASK_11109, D3     ; mask bits 11, 10, 9
    MOVEA   Hex_StrArray, A4    ; Move the base array into A4
    ROL     #7, D3              ; rotate left 7 so bits are in least significant position
    CMP.W   #0, D3              ; check if D3 is 0
    BNE     Data11109_NOT_ZERO  ; if D3 is not zero, jump ahead
    ADD.W   #8, D3              ; if D3 is zero, add 8
Data11109_NOT_ZERO:
    MULS    #2, D3              ; multiply by 2 for correct array offset
    LEA     STRINGPOUND, A2     ; move string # into A2
    JSR     AppendOutput        ; print string # in A2
    LEA     (A4,D3), A2         ; move ASCII immediate into A2
    JSR     AppendOutput
    RTS


*---------------------------------------------------------------------------------------------------------------------
* RegisterList_Predecrement:
* 
* RegisterList will ask for a new word from input, and interpret it as a register list
* It will then output the corresponding registers to the output string
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - The correct ASCII string will be appended to the output buffer
*---------------------------------------------------------------------------------------------------------------------
RegisterList_Predecrement:
    JSR     EA_SetMovemToPreDec
    JSR     EA_GetRegisterList   
    RTS


*---------------------------------------------------------------------------------------------------------------------
* RegisterList_Postincrement:
* 
* RegisterList will ask for a new word from input, and interpret it as a register list
* It will then output the corresponding registers to the output string
* 
* Pre: 
*   - D6: current opcode
*   
* Post: 
*   - The correct ASCII string will be appended to the output buffer
*---------------------------------------------------------------------------------------------------------------------
RegisterList_Postincrement:
    JSR     EA_SetMovemToNotPreDec
    JSR     EA_GetRegisterList   
    RTS


*---------------------------------------------------------------------------------------------------------------------
* EA_GetRegisterList:
* 
* GetRegisterList reads the bits from word stored in D7 to establish a register list used by MOVEM.
* This list is reversed using ReverseBitsInD7Word depending on if the flag in EA_GetMovemIsPreDec is set. 
* 
* Pre: 
*   - D7: will receive a word with a bit-list of registers 
*   - EA_GetMovemIsPreDec set to IsTrue or IsFalse
* 
* Post: 
*   - A list of registers is written to the output buffer 
*---------------------------------------------------------------------------------------------------------------------
EA_GetRegisterList:
    MOVEM.L     D0-D4/D7/A4,-(SP)
    CLR         D1                      ; D1 = last bit found
    CLR         D2                      ; D2 = string array offset
    CLR         D3                      ; D3 = working register for comparisons
    CLR         D4                      ; D4 = flag for contigousness of registers  
    JSR         Get_Next_Word_D7        ; D7 = word bit list of registers 
    MOVEA       EA_StrArray_Dn, A4      ; A4 = Register string list 

    JSR         EA_GetMovemIsPreDec     ; by default, print bits according to pre-decrement sorting
    BNE         RL_SkipBitReversal
    
    JSR         ReverseBitsInD7Word     ; if not default, reverse bits to be read in pre-dec order
    
    
RL_SkipBitReversal
    MOVE.W      #16,D0                  ; D0 = iterator 
    

RL_LOOP:
    CMP.W       #00,D0                  ; check for end of loop
    BLT         RL_LOOP_END
    SUBQ        #1, D0                  ; decrement D4

        
    BTST        D0,D7                   ; test bit in position D4 ; test the register 
    BEQ         RL_LOOP                 ; if not value, continue           
    
    CMP.B       #00,D1                  ;test if this is the first register printed 
    BEQ         RL_Print1stReg

        ; if not the first 
            ; test if is last+1
            
    JSR         RL_CheckIsContiguous
    CMP         #IsTrue,D3
    BEQ         RL_CheckAnStart         ; test if A0

    BRA         RL_PrintSlashReg        ; if not n+1, print "/Xn" & archive

            ;test if last overall 
                ; print -
                ; print Dn
                ; return    

RL_Print1stReg                          
    ;JSR         RL_CalcOffset           ; if the first
    JSR         RL_PrintRegister        ; print Rn
    MOVE.B      D0,D1                   ; archive as most recent
    BRA         RL_LOOP                 ; continue to loop   

RL_CheckAnStart
    CMP.B       #07,D0
    BEQ         RL_Print1stAn           ; if first A0 number, print '-D7/A0'

    MOVE.B      D0,D1                   ; else increment D1
    BRA         RL_LOOP                 ; and continue to loop
    
RL_Print1stAn                           ; print -D7
    JSR         RL_PrintDash
    MOVE.B      D0,-(SP)                ; backup D0
    MOVE.B      D1,D0                   ; calculate offset from D1
    JSR         RL_PrintRegister        ; print d7
    MOVE.B      (SP)+,D0                ; restore D0
    ; intentional fall-through to slash-reg 
    
RL_PrintSlashReg
    JSR         RL_PrintSlash 
    JSR         RL_PrintRegister        ; print Rn
    MOVE.B      D0,D1                   ; archive as most recent
    BRA         RL_LOOP                 ; continue to loop   
                             
RL_LOOP_END:
    JSR         RL_CheckIsContiguous
    CMP         #IsFalse,D3
    BEQ         RL_SkipFinal

    JSR         RL_PrintDash
    JSR         RL_PrintRegister    

RL_SkipFinal
    MOVEM.L     (SP)+,D0-D4/D7/A4
    RTS


RL_PrintRegister
    JSR         RL_CheckForRollover
    MOVE.B      #15,D2                  ; 15 is the max # of bits
    SUB.B       D0,D2                   ; sub # bits remaining (e.g. 15-10 = 5)
    MULU        #3,D2                   ; x3 foreach char-digit-null combination
    MOVE.L      A4,-(SP)
    LEA         (A4,D2),A2
    JSR         AppendOutput
    MOVE.L      (SP)+,A4
    RTS

RL_PrintDash
    LEA         STR_DASH,A2
    JSR         AppendOutput            ; print -
    RTS

RL_PrintSlash
    LEA         STR_SLASH, A2       
    JSR         AppendOutput            ; print '/'
    RTS

RL_CheckIsContiguous
    JSR         RL_CheckForRollover
    MOVE.W      D0,D3                   ; copy current index to temp
    ADDI        #01,D3                  ; add one to current  
    CMP         D3,D1
    BEQ         RL_IsContiguous
    BRA         RL_IsDiscontiguous
RL_IsContiguous
    MOVE.W      #IsTrue,D3
    RTS
RL_IsDiscontiguous
    CMP.B       #$FF,D0
    BNE         RL_ReportDisContig
    
    
    
;RL_CheckRollover
;    CMP         #00,D3
;    BEQ         RL_IsContiguous
  
RL_ReportDisContig
    MOVE.W      #IsFalse,D3
    RTS


RL_CheckForRollover
    CMP.B       #$FF,D0
    BEQ         RL_FixRollover
    RTS
    
RL_FixRollover
    MOVE.W      #$0000,D0
    MOVE.W      #IsTrue,D3
    RTS    






*=====================================================================================================================
* MXn/XnM Helper Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* EA_GetIsMxN
* 
*   Reads the 'EA_IsMXn' storage space to determine if it has been set.
*   This is space acts as a flag that signifies whether the user is trying to read from a hex value in 
*   Mode-Register format, or Register-Mode format. This allows EA_AppendModeRegister to perform double-duty,
*   by ensuring the the bits in question are always shifted to align with the common masks and checks.  
* 
* Pre: 
*   - EA_IsMXn is defined in Gbl_CONST.x68 as 1 byte 
*   - 'IsTrue' is defined as a constant in Gbl_CONST.x68
*   - 'IsFalse' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   -  D0 contains a value matching IsTrue or IsFalse 
*---------------------------------------------------------------------------------------------------------------------
EA_GetIsMXn
    MOVE.L      A0,-(SP)           ; backup A0
    LEA         EA_IsMXn,A0        ; A0 -> the 'isMXn' flag
    MOVE.B      (A0),D0            ; copy the 'isMXn' flag into D0
    MOVE.L      (SP)+,A0           ; restore A0
    RTS
  
*---------------------------------------------------------------------------------------------------------------------
* EA_GetIsXnM
* 
*   Reads the 'EA_IsXnM' storage space to determine if it has been set. See the description above for 
*   'EA_GetIsMXn' for more information. 
* 
* Pre: 
*   - EA_IsXnM is defined in Gbl_CONST.x68 as 1 byte 
*   - 'IsTrue' is defined as a constant in Gbl_CONST.x68
*   - 'IsFalse' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   -  D0 contains a value matching IsTrue or IsFalse 
*---------------------------------------------------------------------------------------------------------------------
EA_GetIsXnM
    MOVE.L      A0,-(SP)           ; backup A0
    LEA         EA_IsXnM,A0        ; A0 -> the 'isXnM' flag
    MOVE.B      (A0),D0            ; copy the 'isXnM' flag into D0
    MOVE.L      (SP)+,A0           ; restore A0
    RTS
 

*---------------------------------------------------------------------------------------------------------------------
* EA_SetIsMXn
* 
*   Sets the value in 'EA_IsMXn' to 'IsTrue' and the value in 'EA_IsXnM' to 'IsFalse'. 
* 
* Pre: 
*   - EA_IsMXn is defined in Gbl_CONST.x68 as 1 byte 
*   - EA_IsXnM is defined in Gbl_CONST.x68 as 1 byte 
*   - 'IsTrue' is defined as a constant in Gbl_CONST.x68
*   - 'IsFalse' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   - EA_IsMXn is set to 'IsTrue'
*   - EA_IsXnM is set to 'IsFalse'
*---------------------------------------------------------------------------------------------------------------------
EA_SetIsMXn
    MOVE.L      A0,-(SP)            ; backup A0
    LEA         EA_IsMXn,A0         ; A0 -> isMXn flag
    MOVE.B      #IsTrue,(A0)        ; set isMXn = to isTrue 
    LEA         EA_IsXnM,A0         ; A0 -> isXnM
    MOVE.B      #IsFalse,(A0)       ; set isXnM = isFalse
    MOVE.L      (SP)+,A0            ; restore A0
    RTS


*---------------------------------------------------------------------------------------------------------------------
* EA_SetIsXnM
* 
*   Sets the value in 'EA_IsXnM' to 'IsTrue' and the value in 'EA_IsMXn' to 'IsFalse'. 
* 
* Pre: 
*   - EA_IsMXn is defined in Gbl_CONST.x68 as 1 byte 
*   - EA_IsXnM is defined in Gbl_CONST.x68 as 1 byte 
*   - 'IsTrue' is defined as a constant in Gbl_CONST.x68
*   - 'IsFalse' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   - EA_IsXnM is set to 'IsTrue'
*   - EA_IsMXn is set to 'IsFalse'
*---------------------------------------------------------------------------------------------------------------------       
EA_SetIsXnM
    MOVE.L      A0,-(SP)            ; backup A0
    LEA         EA_IsXnM,A0         ; A0 -> XnM
    MOVE.B      #IsTrue,(A0)        ; XnM set to isTrue
    LEA         EA_IsMXn,A0         ; A0 -> MXn
    MOVE.B      #IsFalse,(A0)       ; MXn set to isFalse
    MOVE.L      (SP)+,A0            ; restore A0
    RTS
    


*=====================================================================================================================
* Opcode Size Helper Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_SetToByte
* 
*   Sets the value in 'OpcodeSize_Current' to OPCODESIZE_BYTE.
*   This is space acts as a flag that signifies the size of the current opcode, regardless of the mechanism used to 
*   establish that size (some codes use bit 8, some use bits 7/6, some use 13/12). This flag persists until it is 
*   overwritten by another operation code. 
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 
*   - 'OPCODESIZE_BYTE' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   - 'OpcodeSize_Current' is set to 'OPCODESIZE_BYTE'
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_SetToByte
    MOVE.L      A0,-(SP)
    LEA         OpcodeSize_Current,A0
    MOVE.B      #OPCODESIZE_BYTE,(A0)
    MOVE.L      (SP)+,A0
    RTS


*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_SetToWord
* 
*   Sets the value in 'OpcodeSize_Current' to OPCODESIZE_WORD. See 'OpcodeSize_SetToByte' for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 
*   - 'OPCODESIZE_WORD' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   - 'OpcodeSize_Current' is set to 'OPCODESIZE_WORD'
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_SetToWord
    MOVE.L      A0,-(SP)
    LEA         OpcodeSize_Current,A0
    MOVE.B      #OPCODESIZE_WORD,(A0)
    MOVE.L      (SP)+,A0
    RTS



*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_SetToLong
* 
*   Sets the value in 'OpcodeSize_Current' to OPCODESIZE_LONG. See 'OpcodeSize_SetToByte' for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 
*   - 'OPCODESIZE_LONG' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   - 'OpcodeSize_Current' is set to 'OPCODESIZE_LONG'
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_SetToLong
    MOVE.L      A0,-(SP)
    LEA         OpcodeSize_Current,A0
    MOVE.B      #OPCODESIZE_LONG,(A0)
    MOVE.L      (SP)+,A0
    RTS

*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_SetToElse
* 
*   Sets the value in 'OpcodeSize_Current' to OPCODESIZE_ELSE. See 'OpcodeSize_SetToByte' for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 
*   - 'OPCODESIZE_ELSE' is defined as a constant in Gbl_CONST.x68
*  
* Post: 
*   - 'OpcodeSize_Current' is set to 'OPCODESIZE_ELSE'
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_SetToElse
    MOVE.L      A0,-(SP)
    LEA         OpcodeSize_Current,A0
    MOVE.B      #OPCODESIZE_ELSE,(A0)
    MOVE.L      (SP)+,A0
    RTS



*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_GetSize
* 
*   Sets the value in 'OpcodeSize_Current'. See 'OpcodeSize_SetToByte' for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 

* Post: 
*   - D0 contains a copy of the value stored in OpcodeSize_Current
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_GetSize
    MOVE.L      A0,-(SP)
    LEA         OpcodeSize_Current,A0
    MOVE.B      (A0),D0
    MOVE.L      (SP)+,A0
    RTS
   
*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_IsByte
* 
*   Sets D0 to 'IsTrue' if the value in 'OpcodeSize_Current' is OPCODESIZE_BYTE. See 'OpcodeSize_SetToByte' 
*   for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 

* Post: 
*   - D0 'IsTrue' if 'OpcodeSize_Current' is 'OPCODESIZE_BYTE' 
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_IsByte
    JSR         OpcodeSize_GetSize
    CMP.B       #OPCODESIZE_BYTE,D0
    BEQ         Flag_IsTrue
    BRA         Flag_IsFalse
        

*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_IsWord
* 
*   Sets D0 to 'IsTrue' if the value in 'OpcodeSize_Current' is OPCODESIZE_WORD. See 'OpcodeSize_SetToByte' 
*   for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 

* Post: 
*   - D0 'IsTrue' if 'OpcodeSize_Current' is 'OPCODESIZE_WORD' 
*---------------------------------------------------------------------------------------------------------------------          
OpcodeSize_IsWord
    JSR         OpcodeSize_GetSize
    CMP.B       #OPCODESIZE_WORD,D0
    BEQ         Flag_IsTrue
    BRA         Flag_IsFalse


*---------------------------------------------------------------------------------------------------------------------
* OpcodeSize_IsLong
* 
*   Sets D0 to 'IsTrue' if the value in 'OpcodeSize_Current' is OPCODESIZE_LONG. See 'OpcodeSize_SetToByte' 
*   for more information.
* 
* Pre: 
*   - 'OpcodeSize_Current' is defined in Gbl_CONST.x68 as 1 byte 

* Post: 
*   - D0 'IsTrue' if 'OpcodeSize_Current' is 'OPCODESIZE_LONG' 
*---------------------------------------------------------------------------------------------------------------------  
OpcodeSize_IsLong
    JSR         OpcodeSize_GetSize
    CMP.B       #OPCODESIZE_LONG,D0
    BEQ         Flag_IsTrue
    BRA         Flag_IsFalse


*---------------------------------------------------------------------------------------------------------------------
* Flag_IsFalse
* 
*   Sets D0 to the constant 'IsFalse', for use in comparisons
* 
* Pre: 
*   - 'IsFalse' is defined in Gbl_CONST.x68 as 1 byte 

* Post: 
*   - D0 is set to 'IsFalse'
*---------------------------------------------------------------------------------------------------------------------  
Flag_IsFalse        
    CLR.L       D0
    MOVE.B      #IsFalse,D0
    RTS    


*---------------------------------------------------------------------------------------------------------------------
* Flag_IsTrue
* 
*   Sets D0 to the constant 'IsTrue', for use in comparisons
* 
* Pre: 
*   - 'IsTrue' is defined in Gbl_CONST.x68 as 1 byte 

* Post: 
*   - D0 is set to 'IsTrue'
*---------------------------------------------------------------------------------------------------------------------  
Flag_IsTrue        
    CLR.L       D0
    MOVE.B      #IsTrue,D0
    RTS    



*=====================================================================================================================
* Register List Helper Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* EA_GetMovemIsPreDec
* 
*   Sets D0 to the value stored in 'EA_MovemIsPreDec', for use in comparisons
* 
* Pre: 
*   - 'IsTrue' is defined in Gbl_CONST.x68
*   - 'IsFalse' is defined in Gbl_CONST.x68
*
* Post: 
*   - D0 is set to 'IsTrue' or 'IsFalse'
*---------------------------------------------------------------------------------------------------------------------
EA_GetMovemIsPreDec
    MOVE.L      A0,-(SP)                ; backup A0
    LEA         EA_MovemIsPreDec,A0     ; A0 -> 3+
    MOVE.B      (A0),D0                 ; copy the 'MoveM is Pre-Decrementing' flag into D0  
    MOVE.L      (SP)+,A0                ; restore A0
    RTS


*---------------------------------------------------------------------------------------------------------------------
* EA_SetMovemToNotPreDec
* 
*   Sets 'EA_MovemIsPreDec' to 'IsFalse'
* 
* Pre: 
*   - 'EA_MovemIsPreDec' is defined in Gbl_CONST.x68 as 1 byte
*   - 'IsFalse' is defined in Gbl_CONST.x68
*
* Post: 
*   - 'EA_MovemIsPreDec' is set to 'IsFalse'
*---------------------------------------------------------------------------------------------------------------------
EA_SetMovemToNotPreDec
    MOVE.L      A0,-(SP)                ; backup A0
    LEA         EA_MovemIsPreDec,A0     ; A0 -> 'MoveM is Pre-Decrementing'
    MOVE.B      #IsFalse,(A0)           ; 'MoveM is Pre-Decrementing' set to isFalse
    MOVE.L      (SP)+,A0                ; restore A0
    RTS
    

*---------------------------------------------------------------------------------------------------------------------
* EA_SetMovemToNotPreDec
* 
*   Sets 'EA_MovemIsPreDec' to 'IsTrue'
* 
* Pre: 
*   - 'EA_MovemIsPreDec' is defined in Gbl_CONST.x68 as 1 byte
*   - 'IsTrue' is defined in Gbl_CONST.x68
*
* Post: 
*   - 'EA_MovemIsPreDec' is set to 'IsTrue'
*---------------------------------------------------------------------------------------------------------------------    
EA_SetMovemToPreDec
    MOVE.L      A0,-(SP)                ; backup A0
    LEA         EA_MovemIsPreDec,A0     ; A0 -> 'MoveM is Pre-Decrementing'
    MOVE.B      #IsTrue,(A0)            ; 'MoveM is Pre-Decrementing' set to isTrue
    MOVE.L      (SP)+,A0                ; restore A0
    RTS
     

*---------------------------------------------------------------------------------------------------------------------
* ReverseBitsInD7Word
* 
*   Reverses the order of the bits stored in the lower-order word of the register D7 (e.g.: FF56 -> 6AFF)
* 
* Pre: 
*   - D7: contains a word value 
*
* Post: 
*   - D7 contains the same word value, in bitwise reverse order
*--------------------------------------------------------------------------------------------------------------------- 
ReverseBitsInD7Word
    MOVEM.L     D1-D5,-(SP)    
    MOVE.W      D7,-(SP)
    MOVE.W      #0,D1           ; D1 = iterator
    MOVE.W      #$8080,D2       ; D2 = bit mask (starting @ #$8080)
    MOVE.L      D7,D3           ; D3 = temporary value
    CLR.L       D5              ; D5 = working offset 
    CLR.L       D7              ; D7 = output value 
SWAP
    ADDI        #1,D1           ; increment iterator
    CMP         #9,D1           ; check if swapped 1/2 bit-length +1 
    BEQ         SWAP_Return     ; if swapped all upper & lower bits, return
    
    MOVE.W      (SP),D3         ; copy bits into temp
    AND.W       D2,D3           ; mask bits using D2
    
    MOVE.B      D1,D5           ; calculate offset = (i * 2) -1
    MULU        #2,D5           ; iterator * 2
    SUBQ        #1,D5           ; iterator * 2 - 1
    ROL.W       D5,D3           ; roll left offset # of times
    OR.W        D3,D7           ; OR value with output
    ROR.W       #1,D2           ; shift mask to the right to continue
    BRA         SWAP

SWAP_Return
    ADDA        #2,SP           ; advance SP +2 to discard the old D7     
    MOVEM.L     (SP)+,D1-D5     ; return results in D7
    RTS 