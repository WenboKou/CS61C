.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
    
    li t0 1
    blt a2 t0 exit_length
    blt a3 t0 exit_stride
    blt a4 t0 exit_stride

    addi sp sp -12
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)

    li s1 0
    li t5 4
    li t6 0
    mul t3 a3 t5 # t3 is the step size of v0 
    mul t4 a4 t5 # t4 is the step size of v1
    
    jal loop_start
    
    add a0 a0 t1
    add a1 a1 t2
    beq t6 a2 loop_end
  

loop_start:
    lw t1 0(a0) # desired element of vector v0
    lw t2 0(a1) # desired element of vector v1
    mul s0 t1 t2
    add s1 s1 s0 # accumulated sum of the product of t1 and t2
    addi t6 t6 1
    ret
	

exit_stride:
	li a1 6
    j exit2
    
exit_length:
	li a1 5
    j exit2

loop_end:
    mv a0 s1
   
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    addi sp sp 12
    # Epilogue

    
    ret