.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    bne a2 a4 exit_4
    ble a1 x0 exit_2
    ble a5 x0 exit_3


    # Prologue
    li t0 1 # stride for m0
    mv t1 a5 # stride for m1
    li t4 4
    mul t0 t0 t4
    mul t1 t1 t4
    
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
	
    li t6 0
    mv s2 a6 # s2 is the pointer to new matrix's element

outer_loop_start:
	beq t6 a1 outer_loop_end
    li t2 1 # check dot product
    li t3 0 # check if fill up the first row of d
    
    li t4 4
    mul t4 t4 t6
    add s3 a0 t4 # move to the target row of m0 
    
    mv s4 a3
    addi t6 t6 1
    li s0 0

	
inner_loop_start:
	lw t4 0(s3) # element of m0
    lw t5 0(s4) # element of m1
    mul s1 t4 t5
    add s0 s0 s1 # accumulative sum of dot product
	
    add s3 s3 t0
    add s4 s4 t1
    
    beq t2 a2 inner_loop_end
    addi t2 t2 1
    j inner_loop_start
	

inner_loop_end:
	sw s0 0(s2)
    li s0 0
    addi t3 t3 1
    addi s2 s2 4
    beq t3 a5 outer_loop_start
    li t4 4
    mul t4 t4 t3
    add s4 a3 t4 # move to the next column of m1
    
    # move to the target row of m0 
    sub s3 s3 t1
    
    j inner_loop_start

exit_2:
	li a1 2
    j exit2

exit_3:
	li a1 3
    j exit2

exit_4:
	li a1 4
    j exit2


outer_loop_end:

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24
    
    ret