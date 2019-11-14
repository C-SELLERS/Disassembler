*-----------------------------------------------------------
* Program Number:
* Written by    : Colton Sellers
* Date Created  :
* Description   : Read from test in, print it out to console, and 
*                 then write contents to another file
*
*MAIN ISSUE: We have to define the number of bytes. :(
*           gotta find a way for it to determine how many bytes.
*-----------------------------------------------------------
    ORG     $1000

***********OPEN IN FILE AND READ TO BUFFER******************
    lea     inFile,a1       ;in file name
    move    #51,d0          ;open in file
    trap    #15

    lea     buffer,a1       ;store file data in buffer
    move    #byteCount,d2          ;# bytes to read
    move    #53,d0          ;read from file
    trap    #15
    
*************WRITE CONTENTS TO OUTPUT WINDOW*****************
    move   #byteCount,D1           *Number of bytes to print
    move   #0,D0            *output the contents of file
    lea   buffer,a1
    trap   #15
   
************OPEN OUT FILE AND WRITE TO IT********************   
    lea     outFile,a1      ;out file name
    move    #52,d0          ;open NEW out file CLEARS THE OLD ONE!!!
    trap    #15
    
    lea     buffer,a1       ;load the out message
    move    #byteCount,d2         ;# bytes to write
    move    #54,d0          ;write to file
    trap    #15
   
    move    #50,d0
    trap    #15             ;close all files

    MOVE.B  #9,D0
    TRAP    #15             ; halt simulator
   
inFile              DC.B 'testIn.txt',0
buffer              DS.B 80
outFile             DC.B 'testOut.txt',0
byteCount           EQU 40

    END     $1000


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
