*-----------------------------------------------------------
* Title      :  AppendAddress.X68
* Written by :  Colton Sellers
* Date       :
* Description:  Takes address and appends it to the output buffer
*
* Preconditions: A3 Contains the address
*
* TODO: APPEND THAT ADDRESS BITCH
*   This is just a copy of append output that needs to be worked on.
*
*-----------------------------------------------------------

    SaveItFam REG A1-A3/D1-D2

    ;Save context
    MOVEM.L SaveItFam, -(SP)

    ;Clear the registers I plan on using
    CLR     D1
    CLR     D2

    ;Load Current Output into A1
    LEA       OUTPUT, A1

    ;Counter D1, Must be set to -1 to deal with incrementing before moving bytes!
    MOVE.B    #-1, D1

    ;Set D2 as Current String Length
    LEA      CURRENT_STR_LENGTH, A3
    MOVE.B   (A3), D2

    ;Get to the current position of the string 
    ADD     D2, A1

    ;Now that we are in position, start appending the string in A2
APPENDLOOP:
    ADDI.B  #1, D1                      ;Increment Current Length by 1
    MOVE.B  (A2)+, (A1)+                ;Move the Byte in A2 to our Output
    BNE     APPENDLOOP                  ; If zero has not been reached, Loop Back


    ; Update the current string length with the counter
    ADD.B     D1, (A3)

    ; restore context
    MOVEM.L (SP)+, SaveItFam
    
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
