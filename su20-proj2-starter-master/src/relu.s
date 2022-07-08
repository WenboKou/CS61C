.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    li t1, 1
    bge a1, t1, loop_start
    li a1, 8
    j exit2
    

loop_start:
    lw t0, 0(a0)
    bge t0, x0, loop_continue
    sw x0, 0(a0)







loop_continue:
	addi a0, a0, 4
    addi a1, a1, 4
    bge x0, a1, loop_end
    j loop_start


loop_end:


    # Epilogue

    
	ret