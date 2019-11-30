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



* NOT CURRENT IN USE MAY BE DELETED LATERRRR
*
*-----------------------------------------------------------

    SaveItFam REG A1-A3/D1-D2

    ;Save context
    MOVEM.L SaveItFam, -(SP)

    ;Clear the registers I plan on using
    CLR     D1
    CLR     D2


    ; restore context
    MOVEM.L (SP)+, SaveItFam
    
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
