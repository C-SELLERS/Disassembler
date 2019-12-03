*-----------------------------------------------------------
* Title      : TEST FILE
* Written by : CS
* Date       :
* Description: Use as an include to load into memory at the
* 
*-----------------------------------------------------------
TESTIO

* Put program code here

    ;PROBLEM OPCODES
        ;EOR.W  #$AAFF,D0 -> CMPI   IMMEDIATE HEX FAIL
        ;EOR.L  
        ;ADD    #02, D1  -> SUBQ    READS IT AS AN ADDQ; NEED TO ADD ADDQ FUNCTIONALITY**
        ;
  
    EOR.W  #$AAFF,D0
    CMPI   #$AAFF,D0 
