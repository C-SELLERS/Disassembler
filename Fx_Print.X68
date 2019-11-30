*----------------------------------------------------------------------------
* ConvertASCIIToHex
* Source: Adapted from Arnie Berger's Book, Chapter 9
*
* Modifications include: 
*   - validation against out-of-range values 
*   - register D2 reports success/failure via exit codes
*   - single point of exit via ATH_Return 
*   - replace magic numbers with constants
*
* input params: 
*   D0 = ascii code
* 
* output params:
*   D0: hex value
*   D2: return code
*----------------------------------------------------------------------------
ConvertASCIIToHex
ATH_CheckDecimals
    ;CMP.W       #ASCII_9,D0                      * test: is > 9 in ascii?
    CMP.B       #ASCII_9,D0                      * test: is > 9 in ascii?
    BGT         ATH_CheckUppercase               * yes; check for > F 
        
    ;SUB.W      #ASCII_Hex_Offset_Digits,D0      * strip everything below '0'
    SUB.B      #ASCII_Hex_Offset_Digits,D0      * strip everything below '0'
    BRA         ATH_CheckOutOfRange

ATH_CheckUpperCase                        
    ;CMP.W       #ASCII_F_Uppercase,D0            * test: is > F in ascii ?
    CMP.B       #ASCII_F_Uppercase,D0            * test: is > F in ascii ?
    BGT         ATH_CheckLowerCase
        
    ;SUB.W       #ASCII_Hex_Offset_Uppercase,D0   * strip everything below 'A'
    SUB.B       #ASCII_Hex_Offset_Uppercase,D0   * strip everything below 'A'
    BRA         ATH_CheckOutOfRange
                              
ATH_CheckLowerCase                       
    ;CMP.W       #ASCII_F_Lowercase,D0            * test: is > f in ascii?
    CMP.B       #ASCII_F_Lowercase,D0            * test: is > f in ascii?
    BGT         ATH_Invalid                      ; definitively not a hex value
        
    ;SUB.W       #ASCII_Hex_Offset_Lowercase,D0   ; strip everything below 'a'
    SUB.B       #ASCII_Hex_Offset_Lowercase,D0   ; strip everything below 'a'
    BRA         ATH_CheckOutOfRange

ATH_CheckOutOfRange 
    BMI         ATH_Invalid                     ; check for out of range (via roll-over)
    BRA         ATH_Valid                       ;

ATH_Invalid          
    MOVE.B      RETURNCODE_INVALID,D2           ; put the flag on the stack
    MOVE.B      #$FF,D0                         ; put an invalid hex valud on the stack as a secondary flag
    BRA         ATH_Return                      ; return 

ATH_Valid
    MOVE.B      RETURNCODE_VALID,D2             ; put the flag on the stack
    BRA         ATH_Return                      ; return 

ATH_Return            
    RTS                                         * return 


*---------------------------------------------------------------------------------------------------------------------
* ReadFileLine
* 
*   Reads a a line from file until it either 
*       A.) finds a 'CR,LF' combination, or 
*       B.) reaches the character maximum (80)
*   whichever comes first 
* 
*   Preconditions:
*       - A1 -> location in memory to read the string
*       - A2 -> location in memory to save the hex 
*       - D2 contains the length of the string that was read
*
*---------------------------------------------------------------------------------------------------------------------
ReadFileLine 
    MOVEM.L     D3-D6,-(SP)                     ; store context 
    ;MOVEM.L     A1                          ; backup A1 most recently
    ; D0 -> trap subtask #
    ; D1 -> file ID
    ; D2 -> #bytes to read
    ; D3 -> if found CR
    ; D4 -> total bytes read
    ;Setup for Read
    
    ;MOVE.L  A1,A0                          ; temp store A1 in A0
    
    ;LEA     IO_BUFFER,A1                   ; load input buffer 
    CLR         D3                              ; clear 'is CR' temp variable
    CLR         D4                              ; clear temp 'total chars' variable
    CLR         D5                              ; clear byte counter
    CLR         D6                              ; clear byte temp storage
    
ReadFileLine_ReadLoop 
    MOVE.L      #01,D2                          ; copy in the trap subtask 
    MOVE        #53,D0                          ; set the 'read' subtask
    TRAP        #15                             ; read the char
    
    CMP.B       #00,D0                          ; check for file-read status (0 = ok)
    BNE         ReadFileLine_FinishedReading             ; status != ok, therefore return
    
    ADD         #01,D4                          ; increment the char counter
    ADD         #01,D5                          ; increment the byte counter
    
    MOVE.B      (A1)+,D0
    
    CMP.B       #CR,D0                        ; check if the char was CR
    BEQ         ReadFileLine_FlagCR                      ; flag CR when found
    
    CMP.B       #LF,D0                        ; check if the char was LF
    BEQ         ReadFileLine_FinishedReading             ; if LF, at end of line
       
    CMP         #02,D5                          ; check if read in a byte's worth of hex values
    BEQ         ReadFileLine_ConvertByte        ; convert byte to hex 
  
    JSR         ConvertASCIIToHex               ; convert ascii to hex
    ASL.W       #4,D0
    ADD.L       D0,D6   
    
    CMP         #WORD_LENGTH,D4        ; check if read the max # chars
    BEQ         ReadFileLine_FinishedReading             ; clean up on the way out
    
    BRA         ReadFileLine_ReadLoop           ; loop until break

ReadFileLine_ConvertByte
    JSR         ConvertASCIIToHex               ; convert ascii to hex
    ADD.L       D0,D6 
    ADDA        #-2,A1
    MOVE.B      D6,(A1)+
    MOVE.B      #00,D6
 
    MOVE.B      #00,D5                          ; clear the byte counter 
    BRA         ReadFileLine_ReadLoop
    
ReadFileLine_FlagCR
    MOVE.B      #01,D3                          ; set the 'is CR' flag
    BRA         ReadFileLine_ReadLoop           ; continue to loop

    
ReadFileLine_FinishedReading
    CMP         #01,D3                          ; check if 'is CR' flag was set
    BNE         ReadFileLine_SkipCleanup        ; if not set, skip CR/LF cleanup
    ADDA        #-02,A1                         ; reverse the line pointer by 2 (CR & LF)
    ADD         #-02,D4                         ; reverse the char counter by 2 
    
ReadFileLine_SkipCleanup
    MOVE.W      D4,D2                           ; copy the line length to D2 
    MOVEM.L     (SP)+,D3-D6                     ; restore context 
    RTS                                         ; exit    
    
    

*---------------------------------------------------------------------------------------------------------------------
* LoadConfig
* 
*   Attempts to load the Config.cfg file using the ReadLine function 
* 
*   Preconditions: 
*       - inFile is defined as the path to 'Config.cfg'
*       - START_ADDRESS defined as 8 bytes of free space
*       - END_ADDRESS defined as 8 bytes of free space 
* 
*   Postconditions: 
*       - START_ and END_ADDRESS populated with ASCII characters read from file, 
*       - 
*
*---------------------------------------------------------------------------------------------------------------------
LoadConfig
    MOVEM.L     D0/D2/A0-A1,-(SP)                  ; store context
    ; Read in from config.cfg
    LEA         ADDRESSING_CONFIG_FILE_PATH,A1  ;in file name

    MOVE        #51, D0                         ;open in file
    TRAP        #15
    
    ;LEA         ADDRESSING_BEGIN,A2             ; A2 -> location to store start address
    LEA         ADDRESSING_BEGIN,A1             ; A1 -> location to store the start address        
    JSR         ReadFileLine                    ; read the file string
    CMP         #ADDRESSING_LENGTH,D2           ; check that the input string is an address in length 
    BNE         LoadConfig_PrintError           ; if not correct lenght, print error 
    
    ;LEA         ADDRESSING_END,A2               ; A2 -> location to store end address
    LEA         ADDRESSING_END,A1               ; A1 -> location to store end address
    JSR         ReadFileLine                    ; read the file string 
    CMP         #ADDRESSING_LENGTH,D2           ; check if correct length
    BNE         LoadConfig_PrintError           ; if not correct length, print error
     
    ; fall through to validation

LoadConfig_ValidateAddresses
    LEA         ADDRESSING_BEGIN,A1             ; A1 -> start address
    MOVE.L      (A1),D1                         ; D1 = start value 
    AND.L       #ADDRESSING_MASK,D1             ; mask to the important value(s)
    
    CMP         #ADDRESSING_INVALID_RANGE,D1    ; check if address falls within the disallowed range
    BEQ         LoadConfig_PrintError           ; if disallowed, throw error
    
    MOVE.L      #ADDRESSING_END,A1              ; A1 -> end address
    MOVE.L      (A1),D1                         ; D1 = end value
    AND.L       #ADDRESSING_MASK,D1             ; mask to important values
    
    CMP         #ADDRESSING_INVALID_RANGE,D1    ; check if disallowed
    BEQ         LoadConfig_PrintError           ; print error if within disallowed range

    BRA         LoadConfig_Return               ; otherwise continue 
    
LoadConfig_PrintError
    LEA         ConfigErrorArray,A1             ; load 'failed to read config' array
    JSR         PrintArray                      ; print 'failed to read config' array
                                                ; fall through to return 
LoadConfig_Return
    MOVEM.L     (SP)+,D0/D2/A0-A1               ; restore context
    RTS                                         ; return 
    



*---------------------------------------------------------------------------------------------------------------------
* LoadTargetData
* 
*   Attempts to load the Target data identified in TEST_FILE_PATH into the the memory position identified in 
*     Config.cfg and pointed to by ADDRESS_BEGIN through ADDRESS_END 
* 
*   Preconditions: 
*       - TEST_FILE_PATH is defined as the path to '<filePath>.s68'
*       - START_ADDRESS stores a valid 8-byte starting address 
*       - END_ADDRESS stores a valid 8-bytes ending address 
* 
*   Postconditions: 
*       - Memory stored in ADDRESS_BEGIN to _END populated with test data read from TEST_FILE_PATH
*       - 
*
*---------------------------------------------------------------------------------------------------------------------
LoadTargetData
    MOVEM.L     D0/D2/A0,-(SP)                  ; store context
    MOVE.B      IO_BUFFER_MAX_LENGTH,-(SP)
    ; Read in from config.cfg
    LEA         TEST_FILE_PATH, A1              ;in file name
    MOVE        #51, D0                         ;open in file
    TRAP        #15

    LEA         ADDRESSING_END,A1
    MOVE.L      (A1),D0                         ; use D0 to count total bytes read
    LEA         ADDRESSING_BEGIN,A1
    SUB.L       (A1),D0                         ; calculate total bytes to read
    
    MOVE.L      (A1),A1                         ; load the memory location pointed to ADDRESSING_BEGIN into A1
        
LoadTarget_Loop    
    MOVEM.L     D0,-(SP)                        ; store remaining length
    JSR         ReadFileLine                    ; read the file string
    MOVEM.L     (SP)+,D0                        ; restore total remaining length
    SUB.W       D2,D0                           ; subtract the lenght of the string we just read

    CMP.L       #00,D0                          ; check if no remaining space
    BEQ         LoadTarget_Return               ; reached end of space
                
    CMP         IO_BUFFER_MAX_LENGTH,D0
    BLT         LoadTarget_SetIOMaxToRemainder
      
    ; test for EOF    
            
    ;CMP         IO_BUFFER_MAX_LENGTH,D2         ; check if maxed out length
    ;BEQ         LoadTarget_Return               ; reached end of file first         
    


LoadTarget_SetIOMaxToRemainder
    MOVE.B      D0,IO_BUFFER_MAX_LENGTH         ; set the IO buffer to the remaining distance
    BRA         LoadTarget_Loop                 ; loop to pick up the remaining chars
    
    
LoadTarget_Return
    MOVE.L     (SP)+,IO_BUFFER_MAX_LENGTH
    MOVEM.L     (SP)+,D0/D2/A0    
    RTS
    
;    CMP         END_ADDRESS,D0          ; check that the input string is an address in length 
;    BGT         LoadTarget_Loop         ; if not correct lenght, print error 
;    
;    LEA         END_ADDRESS,A1          ; A1 -> location to store end address
;    JSR         ReadFileLine            ; read the file string 
;    CMP         #LONG_LENGTH,D2         ; check if correct length
;    BNE         LoadConfig_PrintError  ; if not correct length, print error




*---------------------------------------------------------------------------------------------------------------------
* PrintArray
* 
* Prints a null-terminated array of strings 
* Assumes: 
*   - A1 -> null-terminated array of strings
*---------------------------------------------------------------------------------------------------------------------
PrintArray:
    MOVEM.L     D0-D2/A0-A2,-(SP)
    MOVE.W      #14,D0                          * load the 'print text to screen' subtask
    MOVE.W      #0,D1   
    MOVE.L      A1,A2
    
PA_Loop
    MOVE.B      D1,D2                           ; copy index to temp
    MULU        #2,D2                           ; multiply index * element width 
    MOVE.W      (A2,D2),A1                      ; offset + base = position
    MOVE.W      (A2,D2),D6
    
    CMP.W       #00,A1                          ; check that we're not at the end of the list
    BEQ         PA_Return                       ; exit if at end of list 
    
    TRAP        #15                             ; execute the 'print' subtask
    ADDI.W      #1,D1                           ; increment the counter 
    BRA         PA_Loop
    
PA_Return   
    MOVEM.L     (SP)+,D0-D2/A0-A2               ; restore the context 
    RTS
    
    
*---------------------------------------------------------------------------------------------------------------------
* PrintText
* 
* Prints a string to console using Trap Subtask #14
* Assumes: 
*   - A1 -> null-terminated string
*---------------------------------------------------------------------------------------------------------------------
PrintText:
    MOVEM.L     D0,-(SP)
    MOVE.B      #14,D0                          * load the 'print text to screen' subtask
    TRAP        #15                             * execute 'print text to screen' subtask
    MOVEM.L     (SP)+,D0
    RTS                                         * return



*---------------------------------------------------------------------------------------------------------------------
* ValidateUserInput
* 
* Iterates over every digit the user wrote in, converting the ascii to hex 
* Assumes: 
*   - A1 -> null-terminated string
*---------------------------------------------------------------------------------------------------------------------   
;ValidateASCIIToHex
;    MOVEM.L     D0-D1/D3,-(SP)
;    MOVEM.L     A1,-(SP)
;    MOVE.B      #LONG_LENGTH,D1            ; D1 acts as counter 
;        
;VUI_Loop    
;    MOVE.B      (A1),D0                ; copy the ascii value to D0
;    JSR         ConvertASCIIToHex       ; convert current letter to ascii
;            
;    CMP.B       RETURNCODE_VALID,D2       ; check return code for valid hex values
;    BNE         VATH_FlagInvalid        ; if invalid, exit 
;    
;    ASL.L       #4,D3                   ; shift D3 left 4 to receive the new byte
;    ADD.L       D0,D3                   ; copy the new hex value from d0 to lower-end of D3 
;
;    SUBQ        #01,D1                  ; decrement the counter
;    CMP         #0,D1                   ; check to see if end of hex value 
;    BEQ         VATH_FlagValid          ; successfully reached the end 
;    
;    BRA         VUI_Loop                ; loop until win or lose 
;    
;VATH_FlagValid
;    MOVE.B      RETURNCODE_VALID,D2
;    BRA         VATH_Return
;    
;VATH_FlagInvalid
;    MOVE.B      RETURNCODE_INVALID,D2
;
;VATH_Return
;    MOVEM.L     (SP)+,A1
;    
;    MOVE.W      #$0003,D1
;VATH_CopyLoop
;    MOVE.L      D3,D0
;    ROL.L       #8,D0
;    MOVE.L      D0,D3
;    AND.L       #$000000FF,D0
;    MOVE.B      D0,(A1)+
;    DBRA        D1,VATH_CopyLoop
;    
;    MOVEM.L     (SP)+,D0-D1/D3
;    RTS











inFile                          DC.B 'Config.cfg',0

ADDRESSING_CONFIG_FILE_PATH     DC.B    'Config.cfg',0

ADDRESSING_LENGTH               EQU     8
ADDRESSING_BEGIN                DS.B    ADDRESSING_LENGTH
ADDRESSING_END                  DS.B    ADDRESSING_LENGTH

ADDRESSING_MASK                 EQU     $0000F000
ADDRESSING_INVALID_RANGE        EQU     $00009000

TEST_FILE_PATH                  DC.B    '.\UnitTests\Test_002.s68'


ASCII_9                         EQU     $39
ASCII_F_Uppercase               EQU     $46
ASCII_F_Lowercase               EQU     $66
ASCII_Hex_Offset_Digits         EQU     $30
ASCII_Hex_Offset_Uppercase      EQU     $37
ASCII_Hex_Offset_Lowercase      EQU     $57

RETURNCODE_VALID                DC.B    0
RETURNCODE_INVALID              DC.B    1      
RETURNCODE_EOF                  DC.B    $FF
RETURNCODE_LENGTH_OK            DC.B    3


CONFIGERROR_1                   DC.B    'Could not load configuration file located at: ',0
CONFIGERROR_2                   DC.B    'or settings were invalid. Please inspect the file and settings and try again.',0

ConfigErrorArray                DC.W    CONFIGERROR_1,inFile,NEWLINE,CONFIGERROR_2,0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
