.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    li t0 5
    bne a0 t0 exit_49


	addi sp sp -52
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    sw ra 48(sp)
	# =====================================
    # LOAD MATRICES
    # =====================================
    lw s0 4(a1) # m0
    lw s1 8(a1) # m1
    lw s2 12(a1) # input_path
    lw s3 16(a2) # output_path
    mv s10 a2
    
    li a0 8
    jal malloc
    mv s4 a0

    

    

    # Load pretrained m0
    addi a1 s4 0 # a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    addi a2 s4 4 # a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    
    mv a0 s0
    jal read_matrix
    mv s0 a0 # s0 is matrix m0
    lw s4 0(a1) # the number of rows of m0
    lw s5 0(a2) # the number of columns of m0

    # Load pretrained m1
    addi a1 s4 0 # a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    addi a2 s4 4 # a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    
    mv a0 s1
    jal read_matrix
    mv s1 a0 # s1 is matrix m1
    lw s6 0(a1) # the number of rows of m1
    lw s7 0(a2) # the number of columns of m1

    # Load input matrix
    addi a1 s4 0 # a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    addi a2 s4 4 # a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    
    mv a0 s2
    jal fread
    mv s2 a0 # s2 is input vector
    lw s8 0(a1) # the number of rows of input
    lw s9 0(a2) # the number of columns of input

	mv a0 s4
    jal free
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    mv a1 s4
    mv a2 s5

    mv a4 s8
    mv a5 s9
    
    mul a0 s4 s9
    slli a0 a0 2
    jal malloc 
    mv a6 a0
    
    mv a0 s0
    mv a3 s2

    jal matmul
    
    mv a0 a6
    mv s11 a6 # record hidden matrix's location
    jal relu
    
    mv a3 a0
    mv a4 s4
    mv a5 s9
    mv a1 s6
    mv a2 s7
    
    mul a0 s6 s9
    slli a0 a0 2
    jal malloc
    mv a0 s1
    
    jal matmul
    
    mv a0 s11
    jal free
    
    mv s11 a6 # record output vector's location
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a1 a6 # a1 is the output scores vector
    mv a2 s6 # the number of rows in the matrix
    mv a3 s9 # the number of columns in the matrix
    mv a0 s3 # the pointer to string representing the filename
	jal write_matrix
    



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	mv a0 a1
    mv a1 s6
    jal argmax

    # Print classification
    bne s10, x0, not_print
    mv a1 a0
    jal print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char


not_print:
	mv a0 s11
    jal free
    mv a0 s0
    jal free
    mv a0 s1
    jal free
    mv a0 s2
	jal free
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw ra 44(sp)
    addi sp sp 48

    ret
   
exit_49:
	li a1 49
    j exit2