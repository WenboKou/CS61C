.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    
    # open the file
    mv a1 a0
    li a2 0
	jal fopen
    li t0 -1
    beq a0 t0 exit_50
    
    # read the file
    mv a1 a0 # a1 is the file descriptor
    li a3 4 # read 4 bytes each time
    jal fread
    bne a3 a0 exit_51
    mv t1 a2 # pointer to number of rows
    lw t1 0(t1)
    jal fread
    bne a3 a0 exit_51
    mv t2 a2 # pointer to number of columns
    lw t2 0(t2)
    
    mul a0 t1 t2 # number of elements of the matrix
    mul a0 a0 a3 # number of bytes of the matrix
    mv a3 a0
    
    jal malloc
    
    mv a2 a0
    
    jal fread
    bne a3 a0 exit_51
    
    jal fclose
    bne a0 x0 exit_52
    
    mv a0 a2
    mv a1 t1
    mv a2 t2

    # Epilogue


    ret
exit_50:
	li a1 50
    j exit2
    
exit_51:
	li a1 51
    j exit2

exit_52:
	li a1 52
    j exit2