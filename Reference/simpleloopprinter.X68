*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: Build a simple loop that just prints DATA 
*              (hard code start and end addresses for now)
*-----------------------------------------------------------
CR  EQU $0D             ; Carraige Return
LF  EQU $0A             ; Line Feed 
HT  EQU $09             ; Tab
FF  EQU $0C             ; Form Feed, always use when ending printing
STARTADDR   EQU $1000   ; Hard coded start address
ENDADDR EQU $1064       ; Hard coded address at which the loop ends

    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE STARTADDR,A0
LOOP: 
                        ; print address
                        
    MOVE STRINGDATA,A1  ; prepare DATA to be printed
    TRAP #14            ; print DATA
    
                        ; print operands with CR,LF
                        
    CMP (A0)+, ENDADDR  ; test exit condition, increment loop pointer
    BEQ END             ; end loop
    BNE LOOP            ; loop

    SIMHALT             ; halt simulator

* Put variables and constants here

STRINGDATA  DC.B    ' DATA ',0


    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
