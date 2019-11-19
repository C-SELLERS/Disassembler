*=====================================================================================================================
* Title      : Matrix Multiplier, HW5, Q7
* Written by : Howie Catlin
* Date       : 18-Nov-2019
* 
* Description:
*   Muliplies two M-by-N matrices and prints their results to screen. The matrices, and their properties, are defined 
*   at the bottom of the file, as constants. 
*
*  
* The following functions are defined and implemented: 
*   - Print Functions
*       - PrintChar
*       - PrintCharInline
*       - PrintDecimalInline 
*       - PrintText
*       - PrintWelcomeInfo
*       - PrintDash
*       - PrintTab
*       - PrintPipe
*       - PrintSpace
*       - PrintNewline
* 
*   - Cursor Position Functions
*       - GetCursorPosition
*       - SaveCursorPosition
*       - SetCursorPosition
* 
*   - Matrix Functions 
*       - GetRowOrderedOffset
*       - GetColOrderedOffset
*       - GetOffset
*       - InitializeOutputMatrix
*       - PrintMatrix_HeaderFooter
*       - PrintMatrix_Data
*       - Print_MatrixA
*       - Print_MatrixB
*       - Print_MatrixOut
*       - MultiplyMatrixA_B
*=====================================================================================================================


    ORG 2000

*=====================================================================================================================    
* Print Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* Print_Char 
* 
* Prints a single character to console using Trap Subtask #6
* Assumes: 
*   - D1 contains the target charcter
*   - Characters are printed on a new line
*--------------------------------------------------------------------------------------------------------------------- 
PrintChar:
    MOVEM.L D0,-(SP)
    MOVE.B  #6,D0   * load the 'print char to screen' subtask
    TRAP    #15     * execute 'print text to screen' subtask
    MOVEM.L (SP)+,D0
    RTS

*---------------------------------------------------------------------------------------------------------------------
* PrintCharInline 
* 
* Prints a single character to the console on the same line the cursor is already on, and advances the cursor one space
* Assumes: 
*   - A0 -> the target character
*---------------------------------------------------------------------------------------------------------------------
PrintCharInline:
    MOVEM.L D0-D2/A0,-(SP)
    
    JSR     SaveCursorPosition  ;save cursor position to D2
    
    MOVE.W  A0,D1               ; copy the char from A0 to D1
    JSR     PrintChar   ; display the char using trap subtask 6
    
    CLR     D0                  ; clear D0 to use as a temp variable
    ADD.B   #02,D0              ; set the lower-order bits to 2
    ASL     #8,D0               ; swap to set the higher-order bits to 2
    ADD.W   D0,D2               ; add 2 to the column of the previous position
    MOVE.W  D2,D1               ; move the old position into D1 to be applied
    
    JSR     SetCursorPosition
    
    MOVEM.L (SP)+,D0-D2/A0
    RTS


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


*---------------------------------------------------------------------------------------------------------------------
* PrintTab
* 
* Uses Trap Subtask 6 to place a tab on screen and advance the cursor 5 places (4 + 1) on the same line. 
* Typically you would use PrintCharInline, but it only advances 1 space, and Easy68k doesn't automatically pad 
* the horizontal tab character with space so we have to do it manually. 
* 
* Assumes: 
*   - TAB is a defined contant ($09)
*---------------------------------------------------------------------------------------------------------------------
PrintTab
    MOVEM.L D0-D2,-(SP)
    JSR     SaveCursorPosition  ;save cursor position to D2
    MOVE.W  #TAB,D1           ; copy the char from A0 to D1
    JSR     PrintChar    ; display the char using trap subtask 6
    CLR     D0              ; clear D0 to use as a temp variable
    ADD.B   #05,D0          ; set the lower-order bits to 2
    ASL     #8,D0           ; swap to set the higher-order bits to 2
    ADD.W   D0,D2           ; add 2 to the column of the previous position
    MOVE.W  D2,D1           ; move the old position into D1 to be applied
    JSR     SetCursorPosition
    MOVEM.L (SP)+,D0-D2
    RTS


*---------------------------------------------------------------------------------------------------------------------
* PrintDash
* 
* Uses PrintCharInline to insert a '-' character and advance the cursor one space on the same line. 
* It's the same code with less typing. 
* 
* Assumes: 
*   - DASH is a defined contant ($2D)
*---------------------------------------------------------------------------------------------------------------------
PrintDash
    MOVEM.L A0,-(SP)
    LEA     DASH,A0
    JSR     PrintCharInline
    MOVEM.L (SP)+,A0
    RTS


*---------------------------------------------------------------------------------------------------------------------
* PrintSpace
* 
* Uses PrintCharInline to insert a ' ' character and advance the cursor one space on the same line. 
* It's the same code with less typing. 
* 
* Assumes: 
*   - SPACE is a defined contant ($20)
*---------------------------------------------------------------------------------------------------------------------
PrintSpace
    MOVEM.L A0,-(SP)
    LEA     SPACE,A0
    JSR     PrintCharInline
    MOVEM.L (SP)+,A0
    RTS


*---------------------------------------------------------------------------------------------------------------------
* PrintSpace
* 
* Uses PrintCharInline to insert a '|' character and advance the cursor one space on the same line. 
* It's the same code with less typing. 
* 
* Assumes: 
*   - PIPE is a defined contant ($7C)
*---------------------------------------------------------------------------------------------------------------------
PrintPipe
    MOVEM.L A0,-(SP)    
    LEA     PIPE,A0
    JSR     PrintCharInline
    MOVEM.L (SP)+,A0
    RTS

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
* Matrix Functions
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* GetRowOrderedOffset
* 
* Calculates the memory offset required to access a cell in a matrix, assuming row-ordered interleaving.
*   Puts all the variables on the stack and then calls GetOffset. 
* 
* Assumes: 
*   - A0 is free to start a stack frame
*   - D5 = column index 
*   - D4 =  row index
* 
* Postconditions
*   - (SP)+ [the top of the stack] contains the offset 
*---------------------------------------------------------------------------------------------------------------------   
GetRowOrderedOffset:
    offset 4+4                      ; offset = 4 (A0 link) + 4 (output)
rowOffset   ds.l    1
    ORG     *
    LINK    A0,#0                   ; create the stack frame    
    MOVE.L  #CellSize,-(SP)         ; load the cell size in 4th var
    MOVE.L  D5,-(SP)                ; load the col index in 3rd var
    MOVE.L  #MatrixA_Width,-(SP)    ; load the #cols in 2nd var
    MOVE.L  D4,-(SP)                ; load the row in 1st var
    JSR     GetOffset               ; calculate matrix offset
    MOVE.L  (SP)+,(rowOffset,A0)    ; bubble the result to the top 
    UNLK    A0                      ; remove the stack frame
    RTS


*---------------------------------------------------------------------------------------------------------------------
* GetColOrderedOffset
* 
* Calculates the memory offset required to access a cell in a matrix, assuming column-ordered interleaving.
*   Puts all the variables on the stack and then calls GetOffset. 
* 
* Assumes: 
*   - A0 is free to start a stack frame
*   - D6 = column index 
*   - D7 = row index
* 
* Postconditions
*   - (SP)+ [the top of the stack] contains the offset 
*---------------------------------------------------------------------------------------------------------------------   
GetColOrderedOffset:
    offset 4+4                      ; offset = 4 (A0 link) + 4 (output)
colOffset   ds.l    1
    ORG     *
    LINK    A0,#0                   ; create the stack frame  
    MOVE.L  #CellSize,-(SP)         ; load the cell size in 4th var
    MOVE.L  D7,-(SP)                ; load the row index in the 3rd var
    MOVE.L  #MatrixB_Height,-(SP)   ; load the #rows in the 2nd var 
    MOVE.L  D6,-(SP)                ; load the col index in 1st var
    JSR     GetOffset               ; calculate the matrix offset
    MOVE.L  (SP)+,(colOffset,A0)    ; bubble the result to the top 
    UNLK    A0                      ; remove the stack frame
    RTS

*---------------------------------------------------------------------------------------------------------------------
* GetOffset
* 
* Calculates the memory offset required to access a cell in a matrix, regardless of interleaving, due to positional 
* parameterization. Pull all the variables from the stack and then returns the values from the top of the stack. 
*
* This method is analogous to memory addressing, where you have a page + offset. You need to know how many pages
* per unit, how many pages to offset, and the individual offset. It doesn't matter if they're rows or columns, the
* math works out the same. 
* 
* Assumes: 
*   - (SP)+1 [top] is the page offset  
*   - (SP)+2 is the # of pages per address
*   - (SP)+2 is the local offset
*   - (SP)+4 is the size of each individual cell (1 for byte, 2 for word, 4 for long)
*   - D7 = row index
* 
* Postconditions
*   - (SP)+ [the top of the stack] contains the offset 
*---------------------------------------------------------------------------------------------------------------------   
GetOffset:
    offset 4+4                      ; offset = 4 (A1 link) + 4 (return address)
totalOffset     DS.L    1
    ORG *
    LINK        A1,#8
   
    MOVE.L      (SP)+,D3            ; load first var into temp
    MOVE.L      (SP)+,D2            ; load 2nd var into other-temp
    MULU        D2,D3               ; multiply temps & store in d3
    ADD.L       (SP)+,D3            ; Add 3rd var to temp
    MOVE.L      (SP)+,D2            ; load 4th var into other-temp
    MULU        D2,D3               ; multiply temps & store in d3
    MOVE.L      D3,(totalOffset,A1) ; return the value using the top of the stack
    UNLK        A1
    RTS
    
*---------------------------------------------------------------------------------------------------------------------
* InitializeOutputMatrix:
* 
* Initializes all elements of the output matrix to 0, so that results can aggreggated from an accurate start point.
*
* Assumes:  
*---------------------------------------------------------------------------------------------------------------------    
InitializeOutputMatrix:
    MOVEM.L D4-D5,-(SP)
    LEA     MatrixOut,A4
    MOVE.L  #MatrixA_Height,D4  ; load the matrix a height into D4
    MOVE.L  #MatrixB_Width,D5   ; load the matrix b width into D5
    MULU    D4,D5               ; multiply and store in D5
    SUBQ.B  #1,D5               ; subtract 1, because were decrementing not incrementing
    
InitLoop:
    BLT     InitExit            ; quit if D5 = 0
    MOVE.B  #00,(A4,D5)         ; copy 0's into byte (MatrixOut)+D5
    SUBQ.W  #01,D5              ; decrement D5 index
    BRA     InitLoop            ; continue to count down
   
InitExit:
    MOVEM.L (SP)+,D4-D5
    RTS

*---------------------------------------------------------------------------------------------------------------------
* PrintMatrix_HeaderFooter
* 
* Uses a series of functiosn to calculate the separation distance of "-" characters that to act as end caps for 
* ascii-art matrices. The vertical lines of the matrices are inserted by PrintMatrix_Data. Together you should get 
* something close to: 
* 
*   -           -
*   |   1   2   | 
*   |   3   4   |
*   -           -
* 
* but it never quite comes out as nice as you want it to
* 
* Assumes: 
*   - The matrix will always be tabbed to the right by 1 to start
*   - D3 contains the width of the matrix 
*---------------------------------------------------------------------------------------------------------------------   
PrintMatrix_HeaderFooter:
    MOVEM.L D3,-(SP)
    MOVE.B  #MatrixOut_Width,D3
    JSR     PrintNewline
    JSR     PrintTab
    JSR     PrintDash
    JSR     PrintTab

PMHF_Loop:
    JSR     PrintTab
    JSR     PrintTab
    SUBQ.B  #01,D3
    BLT     PMHF_Loop
    JSR     PrintTab
    JSR     PrintDash
    MOVEM.L (SP)+,D3
    RTS
    
*---------------------------------------------------------------------------------------------------------------------
* PrintMatrix_Data
* 
* Uses a series of functions to print the data inside a matrix. See PrintMatrix_HeaderFooter for more information. 
* 
* Assumes: 
*   - A1 -> start of matrix 
*   - D6 = # cols 
*   - D7 =  # rows
*   - Matrix calculation has either not started or already completed
*---------------------------------------------------------------------------------------------------------------------   
PrintMatrix_Data
    JSR     PrintMatrix_HeaderFooter    ; always print a header
    JSR     PrintNewline               ; start data on a new line
    JSR     PrintTab                 ; start each new line with a tab
    JSR     PrintPipe
    JSR     PrintTab

    CLR     D4          ; D5 = col index
    CLR     D5          ; D6 = row index
    LEA     (A1),A0     ; load the matrix data
   
PM_DataLoop:
    CLR     D1 
    MOVE.B  (A1)+,D1                ; load the matrix data
    
    JSR     PrintDecimalInline  ; print the matrix value
    
    JSR     PrintTab             ; separate with a tab
    ADDI    #01,D4              ; increment the column counter
    
    
    CMP     D6,D4               ; compare to the column width
    BLT     PM_DataLoop         ; loop if not at end of row

    JSR     PrintPipe        ; + final pipe
    CLR     D4                  ; restart the column counter on the new line
    
    ADDI    #01,D5              ; increment the row counter
    CMP     D7,D5               ; compare to the row height    
    BEQ     PM_Exit             ; exit if reached the end 
                                
                                ; otherwise, start a new line
    JSR     PrintNewline       ; start a new line
    JSR     PrintTab         ; new lines always have a "tab | tab"
    JSR     PrintPipe        ; pipe
    JSR     PrintTab
    BRA     PM_DataLoop         ; continue the loop 
    
PM_Exit
    JSR     PrintMatrix_HeaderFooter  ; print footer at end of rows
    RTS   
    
*---------------------------------------------------------------------------------------------------------------------
* Print_MatrixA
* 
* Uses a series of functions to print the Matrix A name and data
* 
* Assumes: 
*   - PrintMatrix_Data requires: A1 -> start of matrix 
*   - PrintMatrix_Data requires: D6 = # cols 
*   - PrintMatrix_Data requires: D7 =  # rows
*---------------------------------------------------------------------------------------------------------------------   
Print_MatrixA
    MOVEM.L D6-D7/A1,-(SP)          ; save the context on the way in 
    
    LEA     HEADER_MATRIX_A,A1      ; load the matrix name
    JSR     PrintText            ; print the matrix name 
        
    LEA     MatrixA,A1              ; point to the matrix info
    MOVE.B  #MatrixA_Width,D6       ; provide matrix width in D6
    MOVE.B  #MatrixA_Height,D7      ; provide matrix height in D7
    
    JSR     PrintMatrix_Data        ; print the matrix data
    
    MOVEM.L (SP)+,D6-D7/A1          ; restore context on the way out 
    RTS


*---------------------------------------------------------------------------------------------------------------------
* Print_MatrixB
* 
* Uses a series of functions to print the Matrix B name and data
* 
* Assumes: 
*   - PrintMatrix_Data requires: A1 -> start of matrix 
*   - PrintMatrix_Data requires: D6 = # cols 
*   - PrintMatrix_Data requires: D7 =  # rows
*---------------------------------------------------------------------------------------------------------------------  
Print_MatrixB
    MOVEM.L D6-D7/A1,-(SP)          ; save the context on the way in 
    
    LEA     HEADER_MATRIX_B,A1      ; load the matrix name
    JSR     PrintText            ; print the matrix name 
        
    LEA     MatrixB,A1              ; point to the matrix info
    MOVE.B  #MatrixB_Width,D6       ; provide matrix width in D6
    MOVE.B  #MatrixB_Height,D7      ; provide matrix height in D7
    
    JSR     PrintMatrix_Data        ; print the matrix data
    
    MOVEM.L (SP)+,D6-D7/A1          ; restore context on the way out 
    RTS

*---------------------------------------------------------------------------------------------------------------------
* Print_MatrixOut
* 
* Uses a series of functions to print the Matrix Out name and data
* 
* Assumes: 
*   - PrintMatrix_Data requires: A1 -> start of matrix 
*   - PrintMatrix_Data requires: D6 = # cols 
*   - PrintMatrix_Data requires: D7 =  # rows
*---------------------------------------------------------------------------------------------------------------------  
Print_MatrixOut
    MOVEM.L D6-D7/A1,-(SP)          ; save the context on the way in 
    
    LEA     HEADER_MATRIX_OUT,A1    ; load the matrix name
    JSR     PrintText            ; print the matrix name 
        
    LEA     MatrixOut,A1            ; point to the matrix info
    MOVE.B  #MatrixOut_Width,D6     ; provide matrix width in D6
    MOVE.B  #MatrixOut_Height,D7    ; provide matrix height in D7
    
    JSR     PrintMatrix_Data        ; print the matrix data
    
    MOVEM.L (SP)+,D6-D7/A1          ; restore context on the way out 
    RTS    








*---------------------------------------------------------------------------------------------------------------------
* MultiplyMatrixA_B
* 
* Multiplies the values stored in Matrices A & B
*
* Assumes: 
*   - Matrix A & B are defined constants
*   - Matrix A & B have defined constants for height & widths (# rows, & # cols) 
*   - The matrices can be multiplied (i.e.: MatrixA.Cols == MatrixB.Rows)
*   - A constant space has been allocated for the resulting matrix
*---------------------------------------------------------------------------------------------------------------------   
MultiplyMatrixA_B:
    MOVEM.L D4-D7/A2-A4,-(SP)
    
    JSR     InitializeOutputMatrix      ; automatically initialized the output matrix to 00s
    
    
    LEA     MatrixA,A2          ; A2 -> matrix A;  
    LEA     MatrixB,A3          ; A3 -> Matrix B; 
    LEA     MatrixOut,A4
    
    CLR D4              ; init MatrixA row index to 0
    CLR D5              ; init MatrixA col index to 0
    
    CLR D6              ; init MatrixB row index to 0
    CLR D7              ; init MatrixB col index to 0

    
MatrixMultiplyLoop:
    * calculate the MatrixA offset
    MOVEM.L D4-D7/A2-A4,-(SP)           ; store registers D4-7/A0-6
    MOVE.L  #0,-(SP)                ; prep a space on the stack for the offset 
    JSR     GetRowOrderedOffset
    MOVE.L  (SP)+,D0
    MOVEM.L (SP)+,D4-D7/A2-A4
 
    MOVE.B  (A2,D0),D2      *get the MatrixA cell value based on the offset 
    
    * calculate the MatrixB offset
    MOVEM.L D2,-(SP)                ; store D2 also
    MOVEM.L D4-D7/A2-A4,-(SP)           ; store registers D4-7/A0-6
    MOVE.L  #0,-(SP)                ; prep a space on the stack for the offset 
    JSR     GetColOrderedOffset
    MOVE.L  (SP)+,D0     ; pull the offset off the stack       
    
    MOVEM.L (SP)+,D4-D7/A2-A4           ; recover D4-7/A0-6
    MOVEM.L (SP)+,D2                ; recover D2 first
    
    MOVE.B (A3,D0),D3   * get the MatrixB cell value based on the offset
        
    MULU    D2,D3       * multiply the MatrixA & B cells and store in D3
      
    ADD.B     D3,(A4)   * aggregate the cell value products in the output matrix cell
    
    ADDI.B  #01,D5  ; increment the MatrixA Col index (move right)
    ADDI.B  #01,D6  ; increment the MatrixB Row index (move down)



* Cell Math: iterate over Matrix A (one row) x Matrix B (one column)
Check_Cell
    CMP     #MatrixB_Height,D6  ; check if reached end of Matrix B column elements
    BNE     MatrixMultiplyLoop  ; not reached, therefore loop to continue multiplication
    
    CMP     #MatrixA_Width,D5   ; check if reached the end of Matrix A row elements
    BNE     MatrixMultiplyLoop  ; not reached, therefore loop to continue multiplication

    
    * reached the end of the current (row * col) math; 
    * therefore prepare to write to a new output element 
    
    CLR D5                  ; clear the Matrix A column index (move left)
    CLR D6                  ; clear the Matrix B row index (move up)
    
    ADDI    #01,D7          ; increment the Matrix B col index (move right) 
    ADDA    #CellSize,A4    ; increment the output pointer (move right &/or word-wrap like Notepad/Excel)
    
* Row Math: iterate over Matrix A (one row) x Matrix B (all columns) 
Check_MatrixA_Complete
    CMP     #MatrixB_Width,D7       ; check if reached end of Matrix B columns
    BNE     MatrixMultiplyLoop      ; not reached, therefore continue looping through Matrix B columns
    
    ; end of columns reached, therefore reset to iterate down Matrix A
    CLR     D7           ; clear Matrix B col index (move right)
    ADDI    #01,D4       ; increment Matrix A row index (move down)

* Column Math: iterate over Matrix A (all rows) x Matrix B (all columns)     
Check_MatrixA_Row
    CMP     #MatrixA_Height,D4  ; check if reached end of Matrix A rows
    BNE     MatrixMultiplyLoop  ; not reached, therefore continue looping
    
    ; all rows completed, therefore perform cleanup actions
    MOVEM.L (SP)+,D4-D7/A2-A4 ; restore the context on the way out  
    RTS




*=====================================================================================================================
*=====================================================================================================================
* START
* 
* This is where the fun begins
*=====================================================================================================================
*=====================================================================================================================
    ORG    $1000

START:                  
    LEA     stack,SP            ; create a place for the stack t live
    
    JSR PrintWelcomeInfo      ; print the welcome information
    JSR Print_MatrixA           ; print the current 'Matrix A' information
    JSR Print_MatrixB           ; print the current 'Matrix B' information
    
    JSR MultiplyMatrixA_B       ; calcualte the output matrix 
    
    JSR Print_MatrixOut         ; print the resultintg output matrix
    


    SIMHALT           
    
    

*=====================================================================================================================
* Constants
*=====================================================================================================================
*---------------------------------------------------------------------------------------------------------------------
* Matrix Constants
*---------------------------------------------------------------------------------------------------------------------

CellSize            EQU     1   ; defines the width of the data stored in the matrix, where byte=1, word=2, long=4

* MATRIX A: the first matrix 
MatrixA             DC.B    1,2
                    DC.B    3,4   
            
MatrixA_Width       EQU     2
MatrixA_Height      EQU     2


* MATRIX B: The second matrix
MatrixB             DC.B    5,6
                    DC.B    7,8

MatrixB_Width       EQU     2
MatrixB_Height      EQU     2


* MATRIX OUT: The resultant matrix 
MatrixOut_Width     EQU     MatrixB_Width
MatrixOut_Height    EQU     MatrixA_Height
MatrixOut           DS      MatrixOut_Height*MatrixOut_Width*CellSize



*---------------------------------------------------------------------------------------------------------------------
* Program Constants
*---------------------------------------------------------------------------------------------------------------------
stack               EQU     $3000



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
HEADER_1        DC.B '* Matrix Multiplier                                                           *',CR,LF,0
HEADER_2        DC.B '* HW 5, Q7                                                                    *',CR,LF,0
HEADER_BLANK    DC.B '*                                                                             *',CR,LF,0
HEADER_3        DC.B '*   Howie Catlin                                                              *',CR,LF,0
HEADER_4        DC.B '*   CSS 422, Autumn 2019                                                      *',CR,LF,0

INSTRUCTIONS_1      DC.B 'This program multiplies two M-by-N matrices. These matrices are defined  ',CR,LF,0
INSTRUCTIONS_2      DC.B '  in memory, and their only restriction is that column count of the',CR,LF,0
INSTRUCTIONS_3      DC.B '  first matrix be equal to the row count of the second matrix.',CR,LF,0

HEADER_MATRIX_A     DC.B CR,LF,'Matrix A:',CR,LF,0
HEADER_MATRIX_B     DC.B CR,LF,'Matrix B:',CR,LF,0
HEADER_MATRIX_OUT   DC.B CR,LF,'Resulting Matrix: ',CR,LF,0


    END    START        




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
