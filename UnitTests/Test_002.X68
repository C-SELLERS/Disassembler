*-----------------------------------------------------------
* Title      : Test_002
* Written by : CSS 422 Best Group
*              
*   The CSS 422 Best Group is composed of: 
*       - Howie Catlin
*       - Kyle Dukart
*       - Colton Sellers 
*
*
* Date       : 10-Nov-2019
*
* Description:
*   Test input file used to perform software verification 
*   and validation (i.e.: validation that the disassembler
*   is capable of converting hexidecimal to English,
*   verification that the the strings being translated are 
*   in fact correct). 
* 
*   First parts of this file attempt to prove that each 
*   operation code is capable of being translated. The  
*   registers D0, D7, A0, & A7 and hex values '0', '1', '5', 
*   'A', and 'F' as edge cases most likely to uncover early 
*   programming errors. This method exercises all opcodes, 
*   but performs less addressing. 
* 
*   Later in the file, a brute-force matrix of every-register
*   to-every-register is employed to verify the Effective 
*   Addressing code paths. This method uses fewer op codes, 
*   but performs more addressing. 
*
*   Refer to the Test Plan and test matrix for more 
*   information. 
*-----------------------------------------------------------







   

TESTIO

*-----------------------------------------------------------
* BCLR
*-----------------------------------------------------------
    BCLR        D0,D7
    BCLR        D7,(A7)
    BCLR        D0,(A0)+
    BCLR        D7,-(A7)
    BCLR        D0,$FFFF
    BCLR        D7,$55555
    
*-----------------------------------------------------------
* ORI
*-----------------------------------------------------------
    ORI.W       #$1111,D0
    ORI.W       #$AAAA,(A0)+
    ORI.W       #$0000,-(A0)
    ORI.L       #$FFFFF,D0
    ORI.L       #$55555,(A0)+
    ORI.L       #$AAAAA,-(A0)

*-----------------------------------------------------------
* CMPI
*-----------------------------------------------------------
    CMPI.W      #$1111,D0
    CMPI.W      #$AAAA,(A0)+
    CMPI.W      #$0000,-(A0)
    CMPI.L      #$FFFFF,D0
    CMPI.L      #$55555,(A0)+
    CMPI.L      #$AAAAA,-(A0)  

*-----------------------------------------------------------
* MOVE.B
*-----------------------------------------------------------
    MOVE.B      #$FF,D0
    ;MOVE.B     D0,A0
    MOVE.B      D7,(A7)
    MOVE.B      D7,(A0)+
    MOVE.B      D0,-(A7)
    MOVE.B      $1000,D0
    MOVE.B      $10000,D0
     
    MOVE.W      #$AA,D0
    MOVE.W      D7,A0
    MOVE.W      D7,(A7)
    MOVE.W      D0,(A0)+
    MOVE.W      D7,-(A7)
    MOVE.W      $5555,D0
    MOVE.W      $AAAAA,D0

    MOVE.L      #$AA,D0
    MOVE.L      D0,A0
    MOVE.L      D0,(A0)
    MOVE.L      D0,(A0)+
    MOVE.L      D0,-(A0)
    MOVE.L      $1000,D0
    MOVE.L      $10000,D0

     
*-----------------------------------------------------------
* MOVEA.W
*-----------------------------------------------------------
    ;MOVEA.B    #$11,D0
    ;MOVEA.B    D7,A0
    ;MOVEA.B    (A0),A7
    ;MOVEA.B    (A0)+,A7
    ;MOVEA.B    -(A7),A0
    ;MOVEA.B    $AAAA,A0
    ;MOVEA.B    $55555,A0     

    ;MOVEA.W    #$11,D0
    MOVEA.W     D7,A0
    MOVEA.W     (A0),A7
    MOVEA.W     (A0)+,A7
    MOVEA.W     -(A7),A0
    MOVEA.W     $AAAA,A0
    MOVEA.W     $55555,A0     

    ;MOVEA.L    #$00,D0
    MOVEA.L     D0,A0
    MOVEA.L     D7,A0
    MOVEA.L     (A7),A0
    MOVEA.L     (A0)+,A7
    MOVEA.L     -(A7),A0
    MOVEA.L     $FFAA,A7
    MOVEA.L     $FFAA5,A0     


*-----------------------------------------------------------
* NOP, RTS, ILLEGAL
*-----------------------------------------------------------
    NOP
    
    RTS
    
    ILLEGAL

*-----------------------------------------------------------
* LEA
*-----------------------------------------------------------
    LEA         (A7),A0        
    LEA         $FFAA,A0
    LEA         $AA551,A7

*-----------------------------------------------------------
* NEG
*-----------------------------------------------------------
    NEG         D0
    NEG         (A6)
    NEG         (A0)+
    NEG         -(A1)
    NEG         $AAFF
    NEG         $55FAA
    
*-----------------------------------------------------------
* JSR
*-----------------------------------------------------------
    JSR         (A6)
    JSR         $AAFF
    JSR         $55FAA
    
*-----------------------------------------------------------
* MOVEM
*-----------------------------------------------------------
    MOVEM       (A6),A0
    MOVEM       (A0)+,A1
    MOVEM       A2,-(A1)
    MOVEM       $AAFF,A3
    MOVEM       $55FAA,A4

*-----------------------------------------------------------
* SUBQ.x 
*-----------------------------------------------------------
    SUBQ.B      #1,D0
    ;SUBQ.B     #2,A0
    SUBQ.B      #3,(A7)
    SUBQ.B      #4,(A0)+
    SUBQ.B      #5,-(A0)  
    SUBQ.B      #6,$AAFF
    SUBQ.B      #7,$AFAF5
    
    SUBQ.W      #1,D0
    ;SUBQ.W     #2,A0
    SUBQ.W      #3,(A7)
    SUBQ.W      #4,(A0)+
    SUBQ.W      #5,-(A0)  
    SUBQ.W      #6,$AAFF
    SUBQ.W      #7,$AFAF5


    SUBQ.L      #1,D0
    ;SUBQ.L     #2,A0
    SUBQ.L      #3,(A7)
    SUBQ.L      #4,(A0)+
    SUBQ.L      #5,-(A0)  
    SUBQ.L      #6,$AAFF
    SUBQ.L      #7,$AFAF5

*-----------------------------------------------------------
* DIVS
*-----------------------------------------------------------
    DIVS        D0,D1
    ;DIVS        A1,D0
    DIVS        (A1)+,D1
    DIVS        -(A2),D2
    DIVS        #01,D1
    DIVS        $AAFF,D1
    DIVS        $FFAA5,D2

*-----------------------------------------------------------
* OR
*-----------------------------------------------------------
    OR          D0,D1
    ;OR          A0,D0
    ;OR          D0,A0
    OR          (A0),D0
    OR          (A0)+,D7
    OR          -(A7),D0
    OR          #02,D1
   ;OR          $AFAF,A0
   ;OR          $5F5FA,A1

*-----------------------------------------------------------
* SUB
*-----------------------------------------------------------
    SUB         D0,D1
    SUB         A0,D0
    SUB         (A0),D0
    SUB         (A0)+,D0
    SUB         -(A7),D1
    SUB         #02,D1
    SUB         $AAFF,D0
    SUB         $AFAF5,D1

*-----------------------------------------------------------
* CMP
*-----------------------------------------------------------
    CMP         D0,D1
    CMP         A0,D0
    CMP         (A0),D0
    CMP         (A0)+,D0
    CMP         -(A7),D1
    CMP         #02,D1
    CMP         $AAFF,D0
    CMP         $AFAF5,D1

*-----------------------------------------------------------
* EOR
*-----------------------------------------------------------
    EOR         D0,D1
    ;EOR         A0,D0
    EOR         D0,(A0)
    EOR         D0,(A0)+
    EOR         D0,-(A7)
    ;EOR         #02,D1
    EOR.W       #$AAFF,D0
    EOR.L       #$AFAF5,D1
    
*-----------------------------------------------------------
* MULS
*-----------------------------------------------------------
    MULS        D0,D1
    ;MULS        D0,A0
    MULS        (A0),D0
    MULS        (A0)+,D0
    MULS        -(A7),D1
    MULS        #02,D1
    MULS        $AAFF,D0
    MULS        $AFAF5,D1

*-----------------------------------------------------------
* ADD
*-----------------------------------------------------------
    ADD         D0,D1
    ADD         D0,A0
    ADD         (A0),D0
    ADD         (A0)+,D0
    ADD         -(A7),D1
    ADD         #02,D1
    ADD         $AAFF,D0
    ADD         $AFAF5,D1

*-----------------------------------------------------------
* ADDA
*-----------------------------------------------------------
    ADDA        D0,A0
    ADDA        D0,A0
    ADDA        (A0),A0
    ADDA        (A0)+,A0
    ADDA        -(A7),A1
    ADDA        #02,A1
    ADDA        $AAFF,A0
    ADDA        $AFAF5,A7

*-----------------------------------------------------------
* ASR
*-----------------------------------------------------------
    ASR         (A0)
    ASR         (A7)+
    ASR         -(A0)
    ASR         $AFAF
    ASR         $FFAA550

*-----------------------------------------------------------
* ASL
*-----------------------------------------------------------
    ASL         (A0)
    ASL         (A7)+
    ASL         -(A0)
    ASL         $AFAF
    ASL         $FFAA550
  
*-----------------------------------------------------------
* LSR
*-----------------------------------------------------------
    LSR         (A0)
    LSR         (A7)+
    LSR         -(A0)
    LSR         $AFAF
    LSR         $FFAA550

*-----------------------------------------------------------
* LSL
*-----------------------------------------------------------
    LSL         (A0)
    LSL         (A7)+
    LSL         -(A0)
    LSL         $AFAF
    LSL         $FFAA550

*-----------------------------------------------------------
* ROL
*-----------------------------------------------------------
    ROL         (A0)
    ROL         (A7)+
    ROL         -(A0)
    ROL         $AFAF
    ROL         $FFAA550

*-----------------------------------------------------------
* ROR
*-----------------------------------------------------------
    ROR         (A0)
    ROR         (A7)+
    ROR         -(A0)
    ROR         $AFAF
    ROR         $FFAA550

*-----------------------------------------------------------
* BRUTE-FORCE VERIFICATION
*-----------------------------------------------------------
    ADD         D0,D0   ; D0 to all other data registers
    ADD         D0,D1
    ADD         D0,D2
    ADD         D0,D3
    ADD         D0,D4
    ADD         D0,D5
    ADD         D0,D6
    ADD         D0,D7

    ADD         D1,D0   ; D1 to all other data registers
    ADD         D1,D1
    ADD         D1,D2
    ADD         D1,D3
    ADD         D1,D4
    ADD         D1,D5
    ADD         D1,D6
    ADD         D1,D7

    ADD         D2,D0   ; D2 to all other data registers
    ADD         D2,D1
    ADD         D2,D2
    ADD         D2,D3
    ADD         D2,D4
    ADD         D2,D5
    ADD         D2,D6
    ADD         D2,D7

    ADD         D3,D0   ; D3 to all other data registers
    ADD         D3,D1
    ADD         D3,D2
    ADD         D3,D3
    ADD         D3,D4
    ADD         D3,D5
    ADD         D3,D6
    ADD         D3,D7

    ADD         D4,D0   ; D4 to all other data registers
    ADD         D4,D1
    ADD         D4,D2
    ADD         D4,D3
    ADD         D4,D4
    ADD         D4,D5
    ADD         D4,D6
    ADD         D4,D7

    ADD         D5,D0   ; D5 to all other data registers
    ADD         D5,D1
    ADD         D5,D2
    ADD         D5,D3
    ADD         D5,D4
    ADD         D5,D5
    ADD         D5,D6
    ADD         D5,D7

    ADD         D6,D0   ; D6 to all other data registers
    ADD         D6,D1
    ADD         D6,D2
    ADD         D6,D3
    ADD         D6,D4
    ADD         D6,D5
    ADD         D6,D6
    ADD         D6,D7

    ADD         D7,D0   ; D7 to all other data registers
    ADD         D7,D1
    ADD         D7,D2
    ADD         D7,D3
    ADD         D7,D4
    ADD         D7,D5
    ADD         D7,D6
    ADD         D7,D7

    ADD         D0,A0   ; D0 to all other address registers
    ADD         D0,A1
    ADD         D0,A2
    ADD         D0,A3
    ADD         D0,A4
    ADD         D0,A5
    ADD         D0,A6
    ADD         D0,A7

    ADD         D1,A0   ; D1 to all other address registers
    ADD         D1,A1
    ADD         D1,A2
    ADD         D1,A3
    ADD         D1,A4
    ADD         D1,A5
    ADD         D1,A6
    ADD         D1,A7

    ADD         D2,A0   ; D2 to all other address registers
    ADD         D2,A1
    ADD         D2,A2
    ADD         D2,A3
    ADD         D2,A4
    ADD         D2,A5
    ADD         D2,A6
    ADD         D2,A7

    ADD         D3,A0   ; D3 to all other address registers
    ADD         D3,A1
    ADD         D3,A2
    ADD         D3,A3
    ADD         D3,A4
    ADD         D3,A5
    ADD         D3,A6
    ADD         D3,A7

    ADD         D4,A0   ; D4 to all other address registers
    ADD         D4,A1
    ADD         D4,A2
    ADD         D4,A3
    ADD         D4,A4
    ADD         D4,A5
    ADD         D4,A6
    ADD         D4,A7

    ADD         D5,A0   ; D5 to all other address registers
    ADD         D5,A1
    ADD         D5,A2
    ADD         D5,A3
    ADD         D5,A4
    ADD         D5,A5
    ADD         D5,A6
    ADD         D5,A7

    ADD         D6,A0   ; D6 to all other address registers
    ADD         D6,A1
    ADD         D6,A2
    ADD         D6,A3
    ADD         D6,A4
    ADD         D6,A5
    ADD         D6,A6
    ADD         D6,A7

    ADD         D7,A0   ; D7 to all other address registers
    ADD         D7,A1
    ADD         D7,A2
    ADD         D7,A3
    ADD         D7,A4
    ADD         D7,A5
    ADD         D7,A6
    ADD         D7,A7

    ADD         (A0),A0   ; values from all address registers to A0
    ADD         (A1),A0
    ADD         (A2),A0
    ADD         (A3),A0
    ADD         (A4),A0
    ADD         (A5),A0
    ADD         (A6),A0
    ADD         (A7),A0

    ADD         (A0),A1   ; values from all address registers to A1
    ADD         (A1),A1
    ADD         (A2),A1
    ADD         (A3),A1
    ADD         (A4),A1
    ADD         (A5),A1
    ADD         (A6),A1
    ADD         (A7),A1
                    
    ADD         (A0),A2   ; values from all address registers to A2
    ADD         (A1),A2
    ADD         (A2),A2
    ADD         (A3),A2
    ADD         (A4),A2
    ADD         (A5),A2
    ADD         (A6),A2
    ADD         (A7),A2
                    
    ADD         (A0),A3   ; values from all address registers to A3
    ADD         (A1),A3
    ADD         (A2),A3
    ADD         (A3),A3
    ADD         (A4),A3
    ADD         (A5),A3
    ADD         (A6),A3
    ADD         (A7),A3
                    
    ADD         (A0),A4   ; values from all address registers to A4
    ADD         (A1),A4
    ADD         (A2),A4
    ADD         (A3),A4
    ADD         (A4),A4
    ADD         (A5),A4
    ADD         (A6),A4
    ADD         (A7),A4
                    
    ADD         (A0),A5   ; values from all address registers to A5
    ADD         (A1),A5
    ADD         (A2),A5
    ADD         (A3),A5
    ADD         (A4),A5
    ADD         (A5),A5
    ADD         (A6),A5
    ADD         (A7),A5
                    
    ADD         (A0),A6   ; values from all address registers to A6
    ADD         (A1),A6
    ADD         (A2),A6
    ADD         (A3),A6
    ADD         (A4),A6
    ADD         (A5),A6
    ADD         (A6),A6
    ADD         (A7),A6
                    
    ADD         (A0),A7   ; values from all address registers to A7
    ADD         (A1),A7
    ADD         (A2),A7
    ADD         (A3),A7
    ADD         (A4),A7
    ADD         (A5),A7
    ADD         (A6),A7
    ADD         (A7),A7    
    
    ADD         (A0)+,A0   ; post-increment from all address registers to A0
    ADD         (A1)+,A0
    ADD         (A2)+,A0
    ADD         (A3)+,A0
    ADD         (A4)+,A0
    ADD         (A5)+,A0
    ADD         (A6)+,A0
    ADD         (A7)+,A0
                      
    ADD         (A0)+,A1   ; post-increment from all address registers to A1
    ADD         (A1)+,A1
    ADD         (A2)+,A1
    ADD         (A3)+,A1
    ADD         (A4)+,A1
    ADD         (A5)+,A1
    ADD         (A6)+,A1
    ADD         (A7)+,A1
                      
    ADD         (A0)+,A2   ; post-increment from all address registers to A2
    ADD         (A1)+,A2
    ADD         (A2)+,A2
    ADD         (A3)+,A2
    ADD         (A4)+,A2
    ADD         (A5)+,A2
    ADD         (A6)+,A2
    ADD         (A7)+,A2
                      
    ADD         (A0)+,A3   ; post-increment from all address registers to A3
    ADD         (A1)+,A3
    ADD         (A2)+,A3
    ADD         (A3)+,A3
    ADD         (A4)+,A3
    ADD         (A5)+,A3
    ADD         (A6)+,A3
    ADD         (A7)+,A3
                      
    ADD         (A0)+,A4   ; post-increment from all address registers to A4
    ADD         (A1)+,A4
    ADD         (A2)+,A4
    ADD         (A3)+,A4
    ADD         (A4)+,A4
    ADD         (A5)+,A4
    ADD         (A6)+,A4
    ADD         (A7)+,A4
                      
    ADD         (A0)+,A5   ; post-increment from all address registers to A5
    ADD         (A1)+,A5
    ADD         (A2)+,A5
    ADD         (A3)+,A5
    ADD         (A4)+,A5
    ADD         (A5)+,A5
    ADD         (A6)+,A5
    ADD         (A7)+,A5
                      
    ADD         (A0)+,A6   ; post-increment from all address registers to A6
    ADD         (A1)+,A6
    ADD         (A2)+,A6
    ADD         (A3)+,A6
    ADD         (A4)+,A6
    ADD         (A5)+,A6
    ADD         (A6)+,A6
    ADD         (A7)+,A6
                      
    ADD         (A0)+,A7   ; post-increment from all address registers to A7
    ADD         (A1)+,A7
    ADD         (A2)+,A7
    ADD         (A3)+,A7
    ADD         (A4)+,A7
    ADD         (A5)+,A7
    ADD         (A6)+,A7
    ADD         (A7)+,A7
    
    ADD         -(A0),A0   ; pre-decrement from all address registers to A0
    ADD         -(A1),A0
    ADD         -(A2),A0
    ADD         -(A3),A0
    ADD         -(A4),A0
    ADD         -(A5),A0
    ADD         -(A6),A0
    ADD         -(A7),A0
                      
    ADD         -(A0),A1   ; pre-decrement from all address registers to A1
    ADD         -(A1),A1
    ADD         -(A2),A1
    ADD         -(A3),A1
    ADD         -(A4),A1
    ADD         -(A5),A1
    ADD         -(A6),A1
    ADD         -(A7),A1
                      
    ADD         -(A0),A2   ; pre-decrement from all address registers to A2
    ADD         -(A1),A2
    ADD         -(A2),A2
    ADD         -(A3),A2
    ADD         -(A4),A2
    ADD         -(A5),A2
    ADD         -(A6),A2
    ADD         -(A7),A2
                      
    ADD         -(A0),A3   ; pre-decrement from all address registers to A3
    ADD         -(A1),A3
    ADD         -(A2),A3
    ADD         -(A3),A3
    ADD         -(A4),A3
    ADD         -(A5),A3
    ADD         -(A6),A3
    ADD         -(A7),A3
                      
    ADD         -(A0),A4   ; pre-decrement from all address registers to A4
    ADD         -(A1),A4
    ADD         -(A2),A4
    ADD         -(A3),A4
    ADD         -(A4),A4
    ADD         -(A5),A4
    ADD         -(A6),A4
    ADD         -(A7),A4
                      
    ADD         -(A0),A5   ; pre-decrement from all address registers to A5
    ADD         -(A1),A5
    ADD         -(A2),A5
    ADD         -(A3),A5
    ADD         -(A4),A5
    ADD         -(A5),A5
    ADD         -(A6),A5
    ADD         -(A7),A5
                      
    ADD         -(A0),A6   ; pre-decrement from all address registers to A6
    ADD         -(A1),A6
    ADD         -(A2),A6
    ADD         -(A3),A6
    ADD         -(A4),A6
    ADD         -(A5),A6
    ADD         -(A6),A6
    ADD         -(A7),A6
                      
    ADD         -(A0),A7   ; pre-decrement from all address registers to A7
    ADD         -(A1),A7
    ADD         -(A2),A7
    ADD         -(A3),A7
    ADD         -(A4),A7
    ADD         -(A5),A7
    ADD         -(A6),A7
    ADD         -(A7),A7
    
    ADD         #01,D0   ; immediate to all data registers
    ADD         #01,D1
    ADD         #01,D2
    ADD         #01,D3
    ADD         #01,D4
    ADD         #01,D5
    ADD         #01,D6
    ADD         #01,D7

    ADD         #01,A0   ; immediate to all address register
    ADD         #01,A1
    ADD         #01,A2
    ADD         #01,A3
    ADD         #01,A4
    ADD         #01,A5
    ADD         #01,A6
    ADD         #01,A7

    ADD         #01,(A0)   ; immediate to all address register values
    ADD         #01,(A1)
    ADD         #01,(A2)
    ADD         #01,(A3)
    ADD         #01,(A4)
    ADD         #01,(A5)
    ADD         #01,(A6)
    ADD         #01,(A7)

    ADD         #01,(A0)+   ; immediate to all address register with post increment
    ADD         #01,(A1)+
    ADD         #01,(A2)+
    ADD         #01,(A3)+
    ADD         #01,(A4)+
    ADD         #01,(A5)+
    ADD         #01,(A6)+
    ADD         #01,(A7)+

    ADD         #01,-(A0)   ; immediate to all address register with pre-decrement
    ADD         #01,-(A1)
    ADD         #01,-(A2)
    ADD         #01,-(A3)
    ADD         #01,-(A4)
    ADD         #01,-(A5)
    ADD         #01,-(A6)
    ADD         #01,-(A7)


    ADD         $01,D0      ; absolute short to all data registers
    ADD         $01,D1
    ADD         $01,D2
    ADD         $01,D3
    ADD         $01,D4
    ADD         $01,D5
    ADD         $01,D6
    ADD         $01,D7

    ADD         $0A05,A0    ; absolute long to all data registers
    ADD         $0A05,A1
    ADD         $0A05,A2
    ADD         $0A05,A3
    ADD         $0A05,A4
    ADD         $0A05,A5
    ADD         $0A05,A6
    ADD         $0A05,A7









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
