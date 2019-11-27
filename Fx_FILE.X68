*-----------------------------------------------------------
* Title      : File Functions 
* Written by : The CSS 422 "Best Group" 
*               (Howie Catlin, Kyle Dukart, Colton Seller)
* 
* Date       : 12-Nov-2019
* 
* Description:
*   A collection of functions that simulate the "File" 
*   class in order to manipulate portions of the file 
*   system. 
* 
*-----------------------------------------------------------



*********************************************************************************
* File_Open
* 
* Description: 
*   Attempts to open the file stored at the path loaded into A1
*
* Preconditions:  A1 -> a null-terminated file path
* Postconditions: 
*   - D1.L contains the File-ID 
*   - D0 contains the process return code 
*
* Notes: 
*   - Use 'JSR File_IsOpen' to test if the file opened successfully
*   - Use 'JSR String_GetLength' followed by 'JSR String_IsEmpty' 
*       to test if the file path is null or empty
*
*********************************************************************************
File_Open:
    MOVE.B  #51,D0      * load the 'open file' subtask
    TRAP    #15         * execute 'open file' subtask
    RTS



*********************************************************************************
* File_Close
* 
* Description: 
*   Attempts to use the File-ID stored in D1 to write all pending data and close
*
* Preconditions:  D1 stores a File-ID from File_Open
* Postconditions: 
*   - Data was written to file, as needed 
*   - D0 contains the process return code 
*
* Notes: 
*   - Use 'JSR File_IsClosed' to test if the file closed successfully
*
*********************************************************************************
File_Close
    MOVE.B  #56,D0      * load the 'close file' subtask
    TRAP    #15         * execute 'close file' subtask
    RTS


    
*********************************************************************************
* File_Read
* 
* Description: 
*   Attempts to use a File-ID (D1.L) to read a number of bytes (D2.L) to a buffer
*   address (A1)
*
* Preconditions:  
*   - D1 - File-ID (From File_Open) 
*   - D2 - Number of bytes to read
*   - A1 - Buffer location to store the bytes 
*
* Postconditions: 
*   - Data read to memory location pointed to by A1 
*
* Notes: 
*   - Use 'JSR File_WasRead' to test if the data was read successfully 
*
*********************************************************************************
File_Read:
    CMP     $00,D2                      * test if a byte length has already been set
    BNE     Read_Custom_Byte_Length     * a length has been set, skip initializing
    MOVE.W  FILE_DEFAULT_READ_BYTES,D2  * a length has not been set, initialize to default

read_Custom_Byte_Length
    MOVE.B  #53,D0                      * load the 'read file' subtask
    TRAP    #15                         * execute 'read file' subtask
    RTS


*********************************************************************************
* File_Is<X>
* 
* Description: 
*   A series of functions that all compare against D0 to determine the success
*   or failure of a file I/O operation 
*
* Preconditions:
*   - Execution of File_Open, File_Read, or File_Close
*
* Postconditions:
*   - Status Register 'Z' marked as '0' if success, 1 for non-success
* 
* Known Issues: <TBA>
*********************************************************************************   
File_IsOpen
File_IsClosed
File_WasRead
    CMP #00,D0
    RTS



*********************************************************************************
* File_Is<X>
* 
* Description: 
*   A series of functions that all compare against D0 to determine the success
*   or failure of a file I/O operation 
*
* Preconditions:
*   - Execution of File_Open, File_Read, or File_Close
*
* Postconditions:
*   - Status Register 'Z' marked as '0' if success, 1 for non-success
* 
* Known Issues: <TBA>
*********************************************************************************   
* File_ReadErrorCode
*    LEA     FileErrorArray,A1
*    MULU    #WORD_LENGTH,D0
*    LEA     (A1,D0.W),A1
*    MOVE.B  #14,D0
*    TRAP    #15



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
