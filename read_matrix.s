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
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp -36
	sw ra, 32(sp)
    sw s0, 28(sp)
    addi s0, sp, 36
    sw s1, 24(sp)
    sw s2, 20(sp)
    sw s3, 16(sp)
    sw s4, 12(sp)
    sw s5, 8(sp)
    sw s6, 4(sp)
    sw s7, 0(sp)

    #open file
    mv a1, a0
    li a2, 0
    jal fopen
    mv s1, a0 # s1 is file descriptor now
    mv a1, a0
    jal ferror
    bne a0, zero, eof_or_error

    
    li a0, 4
    jal malloc
    mv s2, a0 # s2 points to the heap where the number of rows will be stored

    li a0, 4
    jal malloc
    mv s7, a0 # s7 points to the heap where the number of cols will be stored

    #step 3
    mv a1, s1
    mv a2, s2
    li a3, 4
    jal fread # reads the first 4 bytes and stores them where s2 is pointing

    mv a1, s1
    mv a2, s7
    li a3, 4
    jal fread # reads the next 4 bytes and stores them where s7 is pointing

    #step 4
    lw s3 0(s2) # rows
    lw s5 0(s7) # columns
    mul s6, s5, s3 # number of elements in matrix
    slli s6, s6, 2 # number of elements in bytes
   
    
    mv a0, s6
    jal malloc
    mv s4, a0 # s4 is pointer to the matrix

    
    mv a1, s1 # s1 is file descriptor
    mv a2, s4 # s4 is pointer to buffer in memory where matrix will be stored
    mv a3, s6 # s6 is number of bytes to be read
    jal fread

    mv a0, s4
    #mv a1, s2
    mv a1, s2
    #addi t0, s2, 4
    mv a2, s7
    #lw a1, 0(s2)
    #lw a2, 4(s2)
    #step 5

    # Epilogue

    
    lw s1, 24(sp)
    lw s2, 20(sp)
    lw s3, 16(sp)
    lw s4, 12(sp)
    lw s5, 8(sp)
    lw s6, 4(sp)
    lw s7, 0(sp
    lw s0, 28(sp)
    lw ra, 32(sp)
    addi sp, sp 36
    ret

eof_or_error:
    li a1 1
    jal exit2
    