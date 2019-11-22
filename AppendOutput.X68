*-----------------------------------------------------------
* Title      :  AppendOutput.X68
* Written by :  Colton Sellers
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       When opcodes is being broken down we will be actively appending the
*       output string to prepare for TrapTask13
* Preconditions: Appending String is in A2 and must end in null
*                string constants are in Gbl_CONST.X68
*-----------------------------------------------------------
SaveItFam REG A1

    ;Save context
    MOVEM.L SaveItFam, -(SP)

    ;Load Current Output into A1
    LEA OUTPUT, A1

    ;Get to the current position of the string 
    ADD     CURRENT_STR_LENGTH, A1

    ;Now that we are in position, start appending the string in A2
APPENDLOOP:
    MOVE.B  (A2)+, (A1)+
    ADDI    #1, CURRENT_STR_LENGTH
    CMP     #00,(A2)      ;If we are at the null end of the string being added
    BNE     APPENDLOOP

    ;Put a null terminator at the end of the appended string
    MOVE.B  0,(A1)

    ; restore context
    MOVEM.L (SP)+, SaveItFam
    
    RTS
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
