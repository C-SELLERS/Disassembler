*-----------------------------------------------------------
* Title      : MOVEM Demo
* Written by : Kyle Dukart
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

toSave REG D0-D2/A2-A3

    MOVE    #$1000, D0
    MOVE    #$2000, D1
    MOVE    #$3000, D2
    MOVEA   #$AAAA, A2
    MOVEA   #$BBBB, A3      ; fill registers
    
    MOVEM.L toSave, -(SP)   ; push specified registers to stack
    
    MOVE    #$1111, D0
    MOVE    #$2222, D1
    MOVE    #$3333, D2
    MOVEA   #$CCCC, A2
    MOVEA   #$DDDD, A3      ; fill registers
    
    MOVEM.L (SP)+, toSave   ; pop registers from stack


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
