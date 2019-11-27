*-----------------------------------------------------------
* Title      :  TEST_003
*
* Written by : Howie Catlin
* Date       : 13-Nov-2019
* 
* Description:
*   Unit test to validate:
*   - Opcode prefix: '0000'
*   - Ops: BCLR, ORI, & CMPI
*   - <EA>s: Dn, #x 
*-----------------------------------------------------------



#TEST_FILE   '.\test_001.x68


    ORG    $1000
START:

 
    INCLUDE 'Fx_File.x68'

    



   BCLR    D0,D1
    ORI     #$FF,D0
    CMPI    #$0F,D0
    

    SIMHALT

    END    START

*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
