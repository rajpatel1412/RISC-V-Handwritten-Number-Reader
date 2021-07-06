.import ../read_matrix.s
.import ../write_matrix.s
.import ../matmul.s
.import ../dot.s
.import ../relu.s
.import ../argmax.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step 1: hidden_layer = matmul(m0, input)**\n"
output_step2: .asciiz "\n**Step 2: NONLINEAR LAYER: ReLU(hidden_layer)** \n"
output_step3: .asciiz "\n**Step 3: Linear layer = matmul(m1, relu)** \n"
output_step4: .asciiz "\n**Step 4: Argmax ** \n"
#input: .asciiz "./inputs/simple1/bin/inputs/input0.bin"
#m0: .asciiz "./inputs/simple1/bin/m0.bin" 
#m1: .asciiz "./inputs/simple1/bin/m1.bin"


.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <INPUT_PATH> <M0_PATH> <M1_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    li s1, 4
    mv s2, a0 # s2 is argc
    blt s2, s1, error

    mv s3, a1 # s3 is argv
    addi s3, s3, 4 # s3 is pointing to input_path



	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0


   
    #lw a0 4(s3)
    la a0, m0
    jal ra read_matrix # reading m0 

    mv s1, a0 # base address of m0
    mv s4, a1
    mv s5, a3
    lw s4, 0(s4) # rows m0
    lw s5, 0(s5) # columns m0

    addi sp, sp, -12
    sw a0, 0(sp) # base address of m0
    sw a1, 4(sp) # pointer to rows of m0
    sw a2, 8(sp) # pointer to columns of m0
    


    # Load pretrained m1
    
    #lw a0 8(s3)
    la a0, m1
    jal ra read_matrix # reading m1 

    addi sp, sp, -12
    sw a0, 0(sp) # base address of m1
    sw a1, 4(sp) # pointer to rows of m1
    sw a2, 8(sp) # pointer to columns of m1

    #mv t0, sp
    lw s6, 0(t0) # base address of m1
    lw s7, 4(t0) 
    lw s8, 8(t0) 
    lw s7, 0(s7) # rows m1
    lw s8, 0(s8) # columns of m1

    # Load input matrix
    
    #lw a0 0(s3)
    la a0, input
    jal ra read_matrix # reading in input matrix
    

    addi sp, sp -12
    sw a0, 0(sp) # base address of input
    sw a1, 4(sp) # pointer to rows of input
    sw a2, 8(sp) # pointer to columns of input

    #mv t0, sp
    lw s9, 24(t0) # base address of input
    lw s10, 28(t0) 
    lw s11, 32(t0) 
    lw s10, 0(s10) # rows input
    lw s11, 0(s11) # columns of input

    addi sp, sp, -8
    sw s2, 4(sp) # argc
    sw s3, 0(sp) # argv

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input

    #li a0, 4
    #jal malloc
    #mv s2, a0 # s2 points to the heap where the number of rows will be stored of the output
    #sw s4, 0(s2)

    #li a0, 4
    #jal malloc
    #mv s3, a0 # s3 points to the heap where the number of columnss will be stored of the output
    #sw s11, 0(s3)

   
    mul t1, s4, s11
    slli a0, t1, 2
    #mv a0, t1
    jal ra malloc
    mv s2, a0 # s2 is a pointer to the heap where the output matrix will be stored

    addi sp, sp, -12
    sw s2, 0(sp) # base address of linear layer
    sw s4, 4(sp) # rows of linear layer
    sw s11, 8(sp) # columns of linear layer

    mv a0, s1
    mv a1, s4
    mv a2, s5
    mv a3, s9
    mv a4, s10
    mv a5, s11
    mv a6, s2
    jal ra matmul


    # Output of stage 1
    la a1, output_step1
    jal print_str

    ## FILL OUT
    #lw t2, 0(sp)
    mv a0, s2 # Base ptr
    mv a1, s4 #rows
    mv a2, s11 #cols
    jal ra print_int_array 

    


    # 2. NONLINEAR LAYER: ReLU(m0 * input)

    #lw t2, 0(sp)
    mv a0, s2
    mul a1, s4, s11
    jal ra relu


    # Output of stage 1
    la a1, output_step2
    jal print_str

    ## FILL OUT
    #lw t2, 0(sp)
    mv a0, s2 # Base ptr
    mv a1, s4 #rows
    mv a2, s11#cols
    jal ra print_int_array 



    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    #li a0, 4
    #jal malloc
    #mv s1, a0 # s1 points to the heap where the number of rows will be stored of the output
    #sw s4, 0(s1)

    #li a0, 4
    #jal malloc
    #mv s4, a0 # s4 points to the heap where the number of columnss will be stored of the output
    #sw s11, 0(s4)

   
    mul a0, s7, s11
    slli a0, a0, 2
    #mv a0, s5
    jal ra malloc
    mv s5, a0 # s5 is a pointer to the heap where the output matrix will be stored

    addi sp, sp, -12
    sw s5, 0(sp) # base address of linear layer
    sw s7, 4(sp) # rows of linear layer
    sw s11, 8(sp) # columns of linear layer


    #lw t2 12(sp)
    mv a0, s6
    mv a1, s7
    mv a2, s8
    mv a3, s2
    mv a4, s4
    mv a5, s11
    mv a6, s5
    jal matmul

    # Output of stage 3
    la a1, output_step3
    jal print_str

    ## FILL OUT
    mv a0, s5# Base ptr
    mv a1, s7#rows
    mv a2, s11#cols
    jal ra print_int_array 

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s5
    mul a1, s7, s11
    jal ra argmax
    mv s8, a0


    # Print classification

        # Output of stage 3
    la a1, output_step4
    jal print_str

    ## FILL OUT
    #mv a0, s5 # Base ptr
    #mv a1, s7 #rows
    #mv a2, s11#cols
    #jal print_int_array 

    mv a1 s8
    jal ra print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit


error:
    li a1 3
    jal exit2