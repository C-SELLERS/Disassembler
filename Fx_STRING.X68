*-----------------------------------------------------------
* Title      : 'String' Pseudo-class
* Written by : Howie Catlin
* Date       : 10-Nov-2019
* 
* Description:
*   Provides functionality with a look-and-feel of the 
*   'String' classes we all know and love. Functions are 
*   added on an as-needed bases rather than trying to be 
*   comprehensive.
*-----------------------------------------------------------




*********************************************************************************
* String_GetLength 
* 
* Description: 
*   Reads a null-terminated string from A1, and stores the length 
*   in D1. This mimics the behavior seen by Trap 15 subtask #2. 
*
* Preconditions:  A1 -> null terminated string
* Postconditions: D1 contains String.Length
* 
* References: 
*  Easy68k Discussion regarding this topic: 
*  http://www.easy68k.com/EASy68Kforum/viewtopic.php?f=6&t=1072
*
*********************************************************************************
String_GetLength:
    CLR.L   D1                          ; set length = 0
    WHILE.B (A1,D1) <NE> #0 DO.S        ; While (char != NULL)
    ADDQ.L  #1,D1                       ; length += 1
    ENDW
    RTS
    
    
*********************************************************************************
* String_IsEmpty 
* 
* Description: 
*   Checks the strig length loaed in D1 to test if it is Zero (#00). Sets the 
*   status register 'z' as a result, which can be used for branching as needed. 
* 
* Preconditions:  D1 contains String.length
* 
* Postconditions: 
*   Status Register 'Z' is 0/1, depending on whether string.length = 0
* 
*********************************************************************************    
String_IsEmpty:
    CMP #00,D1      ; compare D1 to '0'
    RTS             ; return 

*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~
