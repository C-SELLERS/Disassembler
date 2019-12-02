    


    ; Configure the stack to exist (current default: $0070000)
    LEA         STACK_LOCATION,SP   
    

    ; Read in from config.cfg
    LEA         inFile, A1       ;in file name
    MOVE        #51, D0          ;open in file
    TRAP        #15

    ;Setup for Read
    MOVE        #8, D2        ;# bytes to read
    MOVE        #53,D0                  ;read from file

    ; Read & store begin address in BEGIN_ADDRESS_STR
    LEA         BEGIN_ADDRESS_STR, A1
    TRAP        #15

    ; Convert the beginning address to HEX and store the value in A3
    JSR         AsciiToHex
    MOVE.L      D7, A3
    
    ; Move File position to where the next line should be
    MOVE        #10,D2 
    MOVE        #55,D0
    TRAP        #15
    
    ;Setup for Read again
    MOVE        #8, D2        ;# bytes to read
    MOVE        #53,D0                  ;read from file
    
    ; Read & store end address in END_ADDRESS
    LEA         END_ADDRESS_STR, A1
    TRAP        #15

    ; Convert the end address to hex and store in A4
    JSR         AsciiToHex
    MOVE.L      D7, A4

    ; Clear Current String Length
    LEA         CURRENT_STR_LENGTH, A1
    CLR.B       (A1)



    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
