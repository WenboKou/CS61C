.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    
    li t0, 1
    lw t1, 0(a0)
    li s0, 0
    li s1, 0
    bge a1, t0, loop_start
    
    li a1, 7
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, -4
    j exit2


loop_start:
	lw t2, 0(a0)
    bge t1, t2, loop_continue
    mv s0, s1
    mv t1, t2
    







loop_continue:
	addi a0, a0, 4
    addi a1, a1, -1
    addi s1, s1, 1
    bge a1, t0, loop_start
    j loop_end



loop_end:
    mv a0, s0
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    

    # Epilogue


    ret