*--------------------------------------------------------------------------
* Title      : Disassembler
* Written by : THE BEST GROUP 
* Date       :
* 
* Description: This code contains a method for you to use
* with your Disassembler project IO, and a short demo of 
* how to call this method in the body of the "START" code.
* 
* Hints and Tips:
*   -Follow the code commenting convention here for file & method headers
*   -Don't rename this file name (Main.X68)
*   -Don't reorg the start address ($1000)
*   -Don't rename or edit the IO method I've provided you with here
*   -Don't rename the config.cfg file or change the file format: 
*    <Long_StartAddress>\CR\LF
*    <Long_EndAddress>\CR\LF<EOF>
*---------------------------------------------------------------------------
    ORG    $1000    *Don't change this; see hints and tips above
*---------------------------------------------------------------------------

    INCLUDE     'Disassembler_Setup.X68'


MAIN_LOOP:
    ; Append String with address
    MOVE.L    A3, D6
    JSR     PrintASCIILong
    CLR.L     D6
    
    JSR     Get_Next_Word_D6

    JSR     DisassembleOpcode   ; disassemble and print word in D6

    ; Compare current address to end address
    CMP.L       A4,A3           ; Are we done yet?
    BLE         MAIN_LOOP       ; Branch if less than or equal too MAIN_LOOP
    
    ; end (print SIMHALT?  close file?)

    SIMHALT

*********************************************************************************
* Method Name: Get_Next_Word_D6
* Description: This method collects the next word at A3 and increments the pointer
*           to the next word.
* Preconditions: (A3) points to the current address we are looking at
* Postconditions: D6 contains the new word
*********************************************************************************
Get_Next_Word_D6:
    ; read word into D6 from current address
    MOVE.W      (A3), D6

    ; Increment Address
    ADD        #2,A3        * Increment pointer by two bytes

    RTS

*********************************************************************************
* Method Name: Get_Next_Word_D7
* Description: This method collects the next word at A3 and increments the pointer
*           to the next word.
* Preconditions: (A3) points to the current address we are looking at
* Postconditions: D7 contains the new word
*********************************************************************************
Get_Next_Word_D7:
    ; read word into D7 from current address
    MOVE.W      (A3), D7

    ; Increment Address
    ADD        #2,A3        * Increment pointer by two bytes

    RTS

*********************************************************************************
* Method Name: Get_Next_Long_D7
* Description: This method collects the next word at A3 and increments the pointer
*           to the next word.
* Preconditions: (A3) points to the current address we are looking at
* Postconditions: D7 contains the new word
*********************************************************************************
Get_Next_Long_D7:
    ; read long into D7 from current address
    MOVE.L      (A3), D7

    ; Increment Address
    ADD         #4,A3        * Increment pointer by four bytes

    RTS


*********************************************************************************
* Method Name: DisassembleOpcode
* Description: This method will determine which opcode is in the current word, and
*   write its ASCII assembly code equivalent into (A1)
* Preconditions:  D6 contains word-length opcode
* Postconditions: (A1) points to ASCII assembly code ending in 0
*********************************************************************************
DisassembleOpcode:
    INCLUDE     'Determine_Opcode.X68'
    INCLUDE     'Breakdown_Opcode.X68'
    INCLUDE     'Addressing.X68'
    ;INCLUDE    'OPCODE_OR.x68'
    RTS


*********************************************************************************
* Method Name:  AppendOutput
* Description:  This file will be included in Main.X68 disassembler program
*       When opcodes is being broken down we will be actively appending the
*       output string to prepare for TRAPTask13
*
* Preconditions: Appending String is in A2 and must end in null
*                string constants are in Gbl_CONST.X68
*
*********************************************************************************
AppendOutput:
    INCLUDE     'AppendOutput.X68'
    RTS

*********************************************************************************
* Method Name:  PrintASCIIWord
* Description:  This function will take a 16 bit word as input and convert it to 
*       ASCII format.  It will then call AppendOutput to print it.
*
* Preconditions: Current word is in D6
*
*********************************************************************************
PrintASCIIWord:
    MOVEM.L     D2-D3/A4, -(SP)     ; MOVEM all registers used
    MOVEA       Hex_StrArray, A4    ; Move the base array into A4

    MOVE.W      D6,D3                ; move word into temp register
    AND         #MASK_OPCODE, D3        ; mask first 4 bits
    ROL         #4, D3                  ; rotate left 4 so bits are in least significant position
    MULS        #2, D3              ; multiply by 2 for correct array offset
    LEA         (A4,D3), A2       ; move ASCII char into A2
    JSR         AppendOutput
    
    MOVE.W      D6, D3              ; move word into temp register
    AND         #MASK_111098, D3        ; mask second 4 bits
    ROL         #8, D3              ; rotate right 8 so bits are in least significant position
    MULS        #2, D3              ; multiply by 2 for correct array offset
    LEA         (A4,D3), A2         ; move ASCII char into A2
    JSR         AppendOutput

    MOVE.W      D6, D3               ; move word into temp register
    AND         #MASK_7654, D3       ; mask third 4 bits
    ROR         #4, D3              ; rotate right 4 so bits are in least significant position
    MULS        #2, D3              ; multiply by 2 for correct array offset
    LEA         (A4,D3), A2       ; move ASCII char into A2
    JSR         AppendOutput
    
    MOVE.W      D6, D3               ; move word into temp register
    AND         #MASK_3210, D3       ; mask last 4 bits
    MULS        #2, D3              ; multiply by 2 for correct array offset
    LEA         (A4,D3), A2       ; move ASCII char into A2
    JSR         AppendOutput

    MOVEM.L     (SP)+, D2-D3/A4     ; return registers to their previous state
    RTS                                ; exit 
    

*********************************************************************************
* Method Name:  PrintASCIILong
* Description:  This function will take a 32 bit word as input and convert it to 
*       ASCII format.  It will then call AppendOutput to print it.
*
* Preconditions: Current word is in D6
*
*********************************************************************************

PrintASCIILong:
    MOVEM.L     D6-D7, -(SP)        ; MOVEM all registers used
    MOVE.B      #16, D7             ; move 16 into D7 for rotation
    ROL.L       D7, D6              ; rotate D6 by 16 bits
    JSR         PrintASCIIWord 
    ROL.L       D7, D6
    JSR         PrintASCIIWord 
    MOVEM.L     (SP)+, D6-D7        ; MOVEM all registers used
    RTS

*********************************************************************************
* Method Name: TrapTask13
* Description: Creates a file if none exists, and appends bytes to that file
*   while also echoing the written bytes to the screen.  You shouldn't need to
*   change this code.
*
* Calling Convention: Callee-Saved 
*
* Preconditions & Method Input:
*   A1 points to the null-terminated buffer to write (newline will be added for you)
*
* Postconditions & Output:
*   ALL files that were previously open will be CLOSED (FileIDs will be invalid)
*   See 'Output.txt' in directory for the results, also piped to the console
*
*
*  A2 holds a pointer to null terminated string to write (input)
*  A3 points to the null-terminated file name
*  D3 holds the number of bytes already in the file to write
*
*  D5 holds number of bytes to write
********************************************************************************
toSave REG D0-D5/A2-A3
TrapTask13:
    *******************************************************************
    * Method initialization, regsiter spilling, parameter saving, etc.
    *******************************************************************
    MOVEM.L toSave, -(SP)   ;  Callee-Saved, so save and restore     
      
    MOVEA.L A1, A2 ; save this buffer to write
    LEA outFilename, A3  ; save this for later, too
      
    MOVE #50,d0   
    TRAP #15 ; close all files, suggested to begin any IO 
    *******************************************************************
    * End Method Init
    *******************************************************************

    ******************************************************************************************
    * Calculate the number of bytes to write by searching for the null in the target buffer A0
    ******************************************************************************************
    CLR.L D5 *D5 is now the number of bytes to write
nullLoop:
    MOVE.B (A1)+, D0
    CMPI.B #0,D0  * compare to null
    BEQ findNullLoopDone
    ADDI.W #1, D5
    BRA nullLoop
    
findNullLoopDone:
    MOVEA.L A3, A1 * reset A1 so it points to the file to write to (to open, next)
    
    ;check if file exists, and open with task 51 if so, otherwise 52
    ;(precondition here is A1 points to the null-terminated filename )
    MOVE.B #51, D0      ;open file (task 51 is existing, 52 is new)
    TRAP #15
      
    if.w D0 <NE> #0 then.s         ; if file error (404, not found)
        MOVE.B #52, D0             ; open new file (52 is new)
        TRAP #15
    endi
    
    ********************************************************************************************************* 
    * Seek to END of FILE by counting the number of bytes, closing, reopening, then seeking.
    *    (first, count number of bytes already in the file to obtain seek position)
    *********************************************************************************************************
    Clr.L D3   ;TODO: reg save, D3 is now our count of bytes read
    MOVE.L #1, D2 ; read one byte at a time
    LEA byteRead, A1
    
countLoop:
    MOVE.B #53, D0 ; try to read one byte (TODO: MOVE out of loop)
    TRAP #15
    
    CMPI.W #1,D0  ;1 == EOF
    BEQ countDone
    ADDI #1, D3
    BRA countLoop
    
countDone:    
    * close this file
     MOVE #56,d0  
     TRAP #15 
     
     * reopen the target file
     MOVE.L A3,A1
     MOVE #51, D0
     TRAP #15
     
    * seek to right position, then continue with writing
    MOVE.L D3, D2 ; MOVE the number of bytes found in the file to D2
    MOVE #55, D0  ; position file task
    TRAP #15

    ******************************************************************************
    * Actually write the buffer to the file, after caculating the number of bytes 
    *  to write and after seeking to the right location in the file for append
    ******************************************************************************

    MOVE.L D5, D2 ; restore this for the actually writing the buffer 
    ; assumes A0 hasnt changed since handed to this method      
    MOVEA.L A2, A1 ; load the address of the buffer we want to write to disk
    ; assumes file ID is still stored in D1.L  
    MOVE.B #54, D0 ; subtask 54 is write to open file (append, or?), assumes D2 holds # of bytes
    TRAP #15

    ; add a newline to the file output
    LEA NEWLINE, A1
    MOVE.B #54, D0 
    MOVE.B #2,D2  ; kills # of bytes to write from input param
    TRAP #15
    
    ; finally, close only this file
    MOVE.B #56, D0 ; close file task
    TRAP #15
  
    ; report to screen
    MOVEA.L A2, A1 ; load the address of the buffer we want to write to disk & screen
    MOVE.B #13, D0
    TRAP #15
      
    ; restore context
    MOVEM.L (SP)+, toSave
    
    RTS
    
    
*----------------------------------------------------------------------------------
* Method Name: AsciiToHex
* Written by : Berger, Modified by Nash
* Date       : 3/1/2019
* Description: Converts chars '0'-'9' and 'a'-'f' to 0-9,a-F
*              Transforms/unpacks 8 chars (8b each) pointed to by A1 into 
*              its (4b each) equivalent hex value 
*  
*  Preconditions & Input
*       A1 (input) points to a memory buffer holding 8 ascii chars (not null-terminated) 
*       This function calls another function (strip_ascii)
*
*  Postconditions & Output
*       D7 (output) holds the converted value 
*       Caller-Saved : D0 is temp, D6 is a loop var
*----------------------------------------------------------------------------------
AsciiToHexRegList REG D0,D6
AsciiToHex     
    MOVEM.L asciiToHexRegList, -(SP)  *save context
    CLR.L D7 * cLEAr our return value
    MOVE.L #8, D6 ; and set up our loop counter

chrLoop
    MOVE.B (A1)+,D0 * Get the first byte
    jsr strip_ascii * Get rid of the ascii code    
    OR.W D0,D7 * Load the bits into D7
    
    subI.B #1,D6  *decrement our loop variable
    BEQ chrDone   *skip shifting if we are done
    
    ASL.L #4,D7 * shift left 4 bits to prepare for next byte
    BRA chrLoop

chrDone
    MOVEM.L (SP)+,asciiToHexRegList 
    RTS


**********************************************************************
* SUBROUTINE: strip_ascii
* reMOVE the ascii code from the digits 0-9,a-f, or A-F
* Input Parameters: <D0> = ascii code
*
* Return parameters: D0.B = number 0...F, returned as 00...0F
* Registers used internally: D0
* Assumptions: D0 contains $30-$39, $41-$46 or $61-66
*
***********************************************************************
strip_ascii
      CMP.B #$39,D0 * Is it in range of 0-9?
      BLE sub30 * Its a number
      CMP.B #$46,D0 * Is is A...F?
      BLE sub37 * Its A...F
      SUB.B #$57,D0 * Its a...f
      BRA ret_sa * Go back
sub37 SUB.B #$37,D0 * Strip 37
      BRA ret_sa * Go back
sub30 SUB.B #$30,D0 * Strip 30
ret_sa RTS * Go back

    
* Required variables and constants go here for your Disassembler
CR                  EQU $0D
LF                  EQU $0A
NEWLINE             DC.B CR,LF,0  
MSG1                DC.B 'MOVE.L D4,D5',0
MSG2                DC.B 'ADD.B D0,D1',0
outFilename         DC.B 'Output.txt',0
byteRead            DS.B 1
ascii_val           DC.B $31,$41,$30,$30,$31,$41,$30,$30 * Test value $1A001A00
    INCLUDE 'Gbl_CONST.X68'
    

    ORG $00111112
   
     
    INCLUDE '.\UnitTests\TEST_002.x68'


 


   END    $1000        ; last line of source
















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
