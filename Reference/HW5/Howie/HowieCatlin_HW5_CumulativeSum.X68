*-----------------------------------------------------------
* Title      : Cumulative Sum, HW5 Q5
* Written by : Howie Catlin
* Date       : 18-Nov-2019
* 
* Description:
*   Muliplies two M-by-N matrices and prints their results to screen. The matrices, and their properties, are defined 
*   at the bottom of the file, as constants. 
*
*   Known Issues: 
*       + User input values > 256 are truncated to 256 without warning
*       + The 'Carry out flag set' value will never be set, because addition is being performed using ADD.L, 
*           which won't roll over until we reach 2^32 +1, and therefore requires multiplying 512 (2^9) by 2^23, 
*           which is well below the range of the byte (2^8) we're using as user input.
*  
* The following functions are defined and implemented: 
*   - Cursor Position Functions
*       - GetCursorPosition
*       - SaveCursorPosition
*       - SetCursorPosition
*
*   - Print Functions
*       - PrintDecimalInline 
*       - PrintNewline
*       - PrintText
*       - PrintWelcomeInfo
* 
*   - Cumulative Sum Functions
*       - PrintMultiplicationResults
*       - MultiplyInQuotes
*-----------------------------------------------------------


*=====================================================================================================================    
* Cursor Position Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* GetCursorPosition 
* 
* Reads the console to identify the current cursor position, and stores it in D1.W
*   The position is stored in (Col,Row) format, using the D2.W, with the Col occupying the high-bits and Row the 
*   low-bits. Col ranges from 0-255; Row ranges from 0-127; origin is the top-left corner at 0,0. 
*---------------------------------------------------------------------------------------------------------------------
GetCursorPosition
    MOVEM.L D0,-(SP)    ; store the context 
    MOVE.W  #$00FF,D1   ; apply mask to force "get" functionality from subtask 11
    MOVE.B  #11,D0      ; load 'get/set cursor position' subtask
    TRAP    #15         ; execute 'get cursor position' subtask 
    MOVEM.L (SP)+,D0    ; restore context
    RTS
   
   
*---------------------------------------------------------------------------------------------------------------------
* SaveCursorPosition
* 
* Uses GetCursorPosition to identify the cursor position, then stores it in D2.2 
* Assumes: 
*   - D2 is available for storage 
*---------------------------------------------------------------------------------------------------------------------
SaveCursorPosition
    JSR     GetCursorPosition   ; load cursor position into D1.W
    MOVE.L  D1,D2               ; save the cursor position to D2.W
    RTS


*---------------------------------------------------------------------------------------------------------------------
* SetCursorPosition
* 
* Uses Trap Subtask 11 to set the cursor position stored in D1.W
* 
* Assumes: 
*   - D1 contains the cursor position in (Col,Row) format [see GetCursorPosition] 
*---------------------------------------------------------------------------------------------------------------------
SetCursorPosition   
    MOVEM.L D0,-(SP)    ; store the context
    MOVE.W  #11,D0      ; load 'get/set cursor position' subtask 
    TRAP    #15         ; execute 'set cursor position' subtask 
    MOVEM.L (SP)+,D0    ; restore context 
    RTS


*=====================================================================================================================
* Print Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* PrintDecimalInline 
* 
* Displays a decimal number to the console on the same line the cursor is already on, and advances the cursor one space
* Assumes: 
*   - D1 contains the target character
*---------------------------------------------------------------------------------------------------------------------
PrintDecimalInline
    MOVEM.L D0-D5,-(SP)
    MOVE.L  D1,D5               ; copy D1 to d5 so it's not overwritten by saveCursor
    
    JSR     SaveCursorPosition  ; saves the cursor position to D2

    
    MOVE.L  D5,D1               ; Recover D1 from d5 local backup
    MOVE.L  D2,D5               ; D2 contains the cursor information 
    
    MOVE.B  #10,D2              ; use 10 as the radix
    MOVE.B  #15,D0              * load the 'print number to screen' subtask
    TRAP    #15                 * execute 'print number to screen' subtask
     
    MOVE.L  D5,D2               ; restore the cursor information
    
    CLR     D0                  ; clear D0 to use as a temp variable
    ADD.B   #02,D0              ; set the lower-order bits to 2
    ASL     #8,D0               ; swap to set the higher-order bits to 2
    ADD.W   D0,D2               ; add 2 to the column of the previous position
    MOVE.W  D2,D1               ; move the old position into D1 to be applied
    JSR     SetCursorPosition
    MOVEM.L (SP)+,D0-D5
    RTS                         * return


*---------------------------------------------------------------------------------------------------------------------
* PrintNewline
* 
* Uses PrintText to start a new line via carriage return + line feed 
* 
* Assumes: 
*   - NL is a defined constant ($0D,$0A,0)
*---------------------------------------------------------------------------------------------------------------------
PrintNewline
    MOVEM.L A1,-(SP)
    LEA     NEWLINE,A1
    JSR     PrintText
    MOVEM.L (SP)+,A1
    RTS

    
*---------------------------------------------------------------------------------------------------------------------
* PrintText
* 
* Prints a string to console using Trap Subtask #14
* Assumes: 
*   - A1 -> null-terminated string
*---------------------------------------------------------------------------------------------------------------------   
PrintText:
    MOVEM.L D0,-(SP)
    MOVE.B  #14,D0  * load the 'print text to screen' subtask
    TRAP    #15     * execute 'print text to screen' subtask
    MOVEM.L (SP)+,D0
    RTS             * return



*---------------------------------------------------------------------------------------------------------------------
* PrintWelcomeInfo
*
*   Prints a series of strings explaining the origin and
*   purpose of the program 
*---------------------------------------------------------------------------------------------------------------------
PrintWelcomeInfo
        MOVEM.L A1,-(SP)    ; store the context
        LEA HEADER_LINE,A1
        JSR PrintText            
        LEA HEADER_1,A1
        JSR PrintText            
        LEA HEADER_2,A1
        JSR PrintText
        LEA HEADER_BLANK,A1
        JSR PrintText           
        LEA HEADER_3,A1
        JSR PrintText           
        LEA HEADER_4,A1
        JSR PrintText           
        LEA HEADER_LINE,A1
        JSR PrintText
  
        LEA NEWLINE,A1
        JSR PrintText
        
        LEA INSTRUCTIONS_1,A1
        JSR PrintText       
        LEA INSTRUCTIONS_2,A1
        JSR PrintText  
        LEA INSTRUCTIONS_3,A1
        
        JSR PrintText  
        LEA NEWLINE,A1
        JSR PrintText
        LEA NEWLINE,A1
        JSR PrintText
        MOVEM.L (SP)+,A1    ; restore the context
        RTS   


*=====================================================================================================================
* User Interaction
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* ReadDecimalFromKeyboard
* 
* Uses TRAP subtask #4 to read a decimal from keyboard into D1.L
*---------------------------------------------------------------------------------------------------------------------   
ReadDecimalFromKeyboard
    MOVEM.L D0,-(SP)        ; store D0 on the stack
    MOVE.B  #04,D0          ; use D0 to load the 'read # from keyboard' subtask 
    TRAP    #15             ; execute the 'read # from keyboard' subtask
    MOVEM.L (SP)+,D0        ; restore D0
    RTS                     


*---------------------------------------------------------------------------------------------------------------------
* GetUserInput
* 
* Prints the "type a number" prompt to screen, then reads in the value using GetDecimalFromKeyboard
*---------------------------------------------------------------------------------------------------------------------   
GetUserInput: 
    MOVEM.L     A0-A1,-(SP)
    LEA         INPUT_BYTE,A1
    JSR         PrintText
    JSR         ReadDecimalFromKeyboard
    MOVE.W      D1,D0
    
    MOVEM.L     (SP)+,A0-A1
    RTS


*=====================================================================================================================
* Cumulative Sum Functions 
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* Print Multiplication Results
* 
* Prints the result of the multiplication, specifically:
*   - The product 
*   - Whether the carry bit was set or not
*---------------------------------------------------------------------------------------------------------------------   
PrintMultiplicationResults:
    MOVEM.L D0-D2/A0-A2,-(SP) ; store the context
    
    LEA RESULT_PRODUCT,A1   ; load the product caption
    JSR PrintText           ; print the product caption
 
    MOVE.L  D1,D5       ;backup the carry bit to D5
    MOVE.L  D2,D1       ; copy the multiplication result to D1 for printing
    JSR     PrintDecimalInline ;print the multiplication data
    JSR     PrintNewline
    
    LEA     RESULT_CARRY,A1 ; load the carry bit caption
    JSR     PrintText       ; print the carry bit caption
    
    CMP     #01,D1          ; check if the carry bit was set
    BEQ     PR_CarryTrue    ; the carry bit was set, skip to 'carry true' 
    
    LEA     RESULT_FALSE,A1        ; carry bit was not set, print 'false'
    JSR     PrintText           ; print 'false' as result
    BRA     LetMeHearPercussion ; skip to exit

PR_CarryTrue
    LEA     RESULT_TRUE,A1  ; carry bit was set, load 'true' result
    JSR     PrintText       ; print 'true' result
    
    
LetMeHearPercussion
    MOVEM.L (SP)+,D0-D2/A0-A2 ; restore the context
    RTS



*---------------------------------------------------------------------------------------------------------------------
* MultiplyInQuotes
* 
* "Multiplies" 512 with the byte-value provided by the user
*---------------------------------------------------------------------------------------------------------------------   
MultiplyInQuotes
    *MOVEM.L D0-D2,-(SP)     ;save the context
    CMP     #00,D0              ; check if D0 is zero 
    BEQ     MultiplyReturn      ; quit if true
    
    CLR     D5                  ;clear D5 as temp storage for the carry flag
        
MultiplyLoop
    ADD.L   #512,D2             ; add 512 foreach index
    BCS     SetCarryFlagFlag    ; check if the carry flag was set  
MultiplyContinue                ; continue the loop
    SUBQ.B  #01,D0              ; decrement after each addition
    BEQ     MultiplyReturn      ; 
    BRA     MultiplyLoop        ; if not complete, continue loop 

SetCarryFlagFlag
    MOVE.L  #01,D5
    BRA     MultiplyContinue    
 
MultiplyReturn      
    *MOVEM.L (SP)+,D0-D2     ; restore the context 
    MOVE.L  D5,D1            ; copy D5 to D1, to set the carry flag-flag
    RTS



*=====================================================================================================================
*=====================================================================================================================
* START
* 
* It puts the lotion on its parameters
*=====================================================================================================================
*=====================================================================================================================
    ORG    $1000
START:                  ; first instruction of program
    JSR     PrintWelcomeInfo
    JSR     GetUserInput
    JSR     MultiplyInQuotes
    JSR     PrintMultiplicationResults


    SIMHALT             ; halt simulator








*=====================================================================================================================
* Constants
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* CHAR(ish) Constants
*---------------------------------------------------------------------------------------------------------------------
PIPE    EQU     $7C    
DASH    EQU     $2D
CR      EQU     $0D
LF      EQU     $0A
TAB     EQU     $09
SPACE   EQU     $20

NEWLINE  DC.B    CR,LF,0



*---------------------------------------------------------------------------------------------------------------------
* String Constants
*---------------------------------------------------------------------------------------------------------------------
HEADER_LINE     DC.B '*=============================================================================*',CR,LF,0
HEADER_1        DC.B '* 512 Cumulative Sum                                                          *',CR,LF,0
HEADER_2        DC.B '* HW 5, Q5                                                                    *',CR,LF,0
HEADER_BLANK    DC.B '*                                                                             *',CR,LF,0
HEADER_3        DC.B '*   Howie Catlin                                                              *',CR,LF,0
HEADER_4        DC.B '*   CSS 422, Autumn 2019                                                      *',CR,LF,0

INSTRUCTIONS_1      DC.B 'This program performs pseudo-multiplication by performing iterative',CR,LF,0
INSTRUCTIONS_2      DC.B '  addition. It requests a byte-sized number and multiplies it against',CR,LF,0
INSTRUCTIONS_3      DC.B '  the number 512, and reports if the carry flag was set.',CR,LF,0

INPUT_BYTE          DC.B 'Multiplicand (0-256): ',$09,0
RESULT_PRODUCT      DC.B 'Product:',$09,$09,$09,$20,$20,$20,$20,0
RESULT_CARRY        DC.B 'Carry Bit Set?: ',$09,$09,$20,0
RESULT_TRUE         DC.B 'True',CR,LF,0
RESULT_FALSE        DC.B 'False',CR,LF,0

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
