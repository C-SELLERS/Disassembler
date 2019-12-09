*=====================================================================================================================
* Title      :  AppendOutput.X68
* Written by : CSS 422 Best Group
*              
*   The CSS 422 Best Group is: 
*       - Howie Catlin
*       - Kyle Dukart
*       - Colton Sellers 
*
* Date       : 10-Nov-2019
*
* Description:
* This file will be included in Main.X68 disassembler program when opcodes is being broken down we will be actively 
* appending the output string to prepare for TrapTask13.
*
* Preconditions: 
*   - Appending String is in A2 and must end in null
*                
* Notes: 
*   - string constants are in Gbl_CONST.X68
*
*=====================================================================================================================
SaveItFam REG A1-A3/D1-D2
    ;Save context
    MOVEM.L SaveItFam, -(SP)

        ;Clear the registers I plan on using
    CLR     D1
    CLR     D2


    ;Load Current Output into A1
    LEA OUTPUT, A1

    ;Counter D1, Must be set to -1 to deal with null termination of strings
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
