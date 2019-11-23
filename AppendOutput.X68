*-----------------------------------------------------------
* Title      :  AppendOutput.X68
* Written by :  Colton Sellers
* Date       :
* Description:  This file will be included in Main.X68 disassembler program
*       When opcodes is being broken down we will be actively appending the
*       output string to prepare for TrapTask13
*
* Preconditions: Appending String is in A2 and must end in null
*                string constants are in Gbl_CONST.X68
*
*TODO: 
*   1)  I believe there is issues with CURRENT_STR_LENGTH as it is set to 0
*       but when loaded into a register comes up as FFFF????
*       Good thing is that it does work with add operations so using it as a variable is good!
*       
*   2) Address where it starts writting the next sequence in string, might work fine but has only
*       been tested with RTS so we need to use a two word opcode or something to know for sure.
*-----------------------------------------------------------
SaveItFam REG A1/D1

    ;Save context
    MOVEM.L SaveItFam, -(SP)

    ;Load Current Output into A1
    LEA OUTPUT, A1

    ;Counter D1, Must be set to -1 to deal with incrementing before moving bytes!
    MOVE    #-1, D1

    ;Get to the current position of the string 
    ADD     CURRENT_STR_LENGTH, A1

    ;Now that we are in position, start appending the string in A2
APPENDLOOP:
    ADDI    #1, D1                      ;Increment Current Length by 1
    MOVE.B  (A2)+, (A1)+                ;Move the Byte in A2 to our Output
    BNE     APPENDLOOP                  ; If zero has not been reached, Loop Back

    ;Update Current String Length with our counter
    ADD     D1, CURRENT_STR_LENGTH

    ; restore context
    MOVEM.L (SP)+, SaveItFam
    
    RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
