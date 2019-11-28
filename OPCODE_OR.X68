*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

    ; D3 = OPCODE String
    ; D4 = Src EA string
    ; D5 = Src EA value
    ; D6 = Dest EA string
    ; D7 = Dest EA value


OR_GetOPCODE 
    MOVEM.L D0-D5/D7/A0-A7,-(SP)
    MOVE.L  D6,-(SP)
    
  
   
    
    MOVE.L  (SP),D3       ; move the word value into D3
    AND.L   MASK_76,D3  
    
    CMP     #$0000,D3           ; check for byte-size
    BEQ     OR_Store_Byte
    
    CMP     #$0040,D3           ; check for word-size
    BEQ     OR_Store_Word
    
    MOVE.L  STR_OR_L,D3         ; store 'OR.L' in D3
    BRA     Get_EffectiveAddressing 

OR_Store_Byte
    MOVE.L  STR_OR_B,D3         ; store 'OR.B' in D3
    BRA     Get_EffectiveAddressing  
 
OR_Store_Word
    MOVE.L  STR_OR_W,D3         ; store 'OR.W' in D3
    BRA     Get_EffectiveAddressing  
   

OR_Return
    MOVE.L  (SP)+,D6
    MOVEM.L (SP)+,D0-D5/D7/A0-A7
    

   MOVE.L   (SP),D3         ;move the word value into D3
   AND.L    MASK_8,D3
   
   CMP      #$0000,D3       ; 
   BEQ      
   

   
   
   ; if(b.8 == 1) { EA = dest} 
   ; if(b.8 == 0) { EA = dest, Src = Imm}
   ; else 
   


OR_SkipSrcSwap
       
   
    
    RTS


* sets the value in D6 point to address of the EA Type string
Get_EffectiveAddressing
    MOVE.L  (SP),D6
    
    AND.L   #MASK_543,D6
    
    CMP     #$0000,D6
    BEQ     Get_EA_Dn
    
    CMP     #$0008,D6
    BEQ     Get_EA_An
    
    CMP     #$0010,D6
    BEQ     Get_EA_AnInd 
    
    CMP     #$0018,D6
    BEQ     Get_EA_AnPostInc
        
    CMP     #$0020,D6
    BEQ     Get_EA_An_AnPreDec


    CMP     #$0038,D6
    BEQ     Get_EA_Else   

    
Get_EA_Dn    
    LEA     EA_StrArray_Dn,A0
    BRA     Get_Register
  
Get_EA_An    
    LEA     EA_StrArray_An,A0
    BRA     Get_Register
    
Get_EA_AnInd   
    LEA     EA_StrArray_AnInd,A0
    BRA     Get_Register

Get_EA_An_AnPreDec
    LEA     EA_StrArray_AnPreDec,A0
    BRA     Get_Register

Get_EA_AnPostInc    
    LEA     EA_StrArray_AnPostInc,A0
    BRA     Get_Register

Get_EA_Else    
    LEA     EA_StrArray_Else,A0
    BRA     Get_ImmOrAbsolute


  
  
  
Get_Register
    MOVE.L  (SP),D6
    AND.L   #MASK_210,D6
    MULU    #02,D6          ; multiply by 2 because the string arrays are word-ordered
    MOVE.L  (A0,D6),D6
    BRA     GetEA_Return

Get_ImmOrAbsolute
    MOVE.L  (SP),D6
    AND.L   #MASK_210,D6
    
    CMP     #$0004,D6
    BEQ     Get_Immediate
    
    CMP     #$0001,D6
    BEQ     Get_Word

    MOVE.L  (A0,2),D6   ; move the '#$' value into D6
    BRA 
    
Get_Immediate
    MOVE.L  (A0,0),D6   ; move the '#' value into D6
    BRA 
    
Get_Word
    MOVE.L  (A0,1),D6   ; move the '#$' value into D6       
    BRA

GetEA_Return
    RTS

    
    
    
    ;LEA STR_OR, A2
    JSR AppendOutput            ; write OR to the output string
    JSR Size76
    MOVE.W  D6,D3               ; move word value into D3
    AND #MASK_8, D3             ; mask bit 8
    CMP.W #$0000,D3             ; compare with 0
    BNE OR_EA_DN_EA
    
    
    MOVEM.L D0-D7/A0-A7,-(SP)
    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
