#.import ./dot.s

.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    addi sp, sp, -84
    sw ra, 80(sp)
    sw s0, 76(sp)
    addi s0, sp, 84
    sw s1, 72(sp)
    sw s2, 68(sp)
    sw s3, 64(sp)
    sw s4, 60(sp)
    sw s5, 56(sp)
    sw s6, 52(sp)
    sw s7, 48(sp)
    sw s8, 44(sp)
    sw s9, 40(sp)
    sw s10, 36(sp)
    mv, s1, a0
    mv, s2, a1
    mv, s3, a2
    mv, s4, a3
    mv, s5, a4

    sw s1, 32(sp) # pointer to m0
    sw s2, 28(sp) # m0 rows
    sw s3, 24(sp) # m0 cols
    sw s4, 20(sp) # pointer to m1
    sw s5, 16(sp) # m1 rows
    sw a5, 12(sp) # m1 cols
    sw a6, 8(sp) # pointer to d
    sw, zero, 4(sp) # i
    
    slli s8, s3, 2
    
outer_loop_start:
    
    lw s6, 4(sp) # i
    bge s6, s2, outer_loop_end
    sw, zero, 0(sp) # j
    lw s4, 20(sp)

inner_loop_start:

    lw s7, 0(sp) # j
    lw a5, 12(sp) # m1 cols
    bge s7, a5, inner_loop_end
    
    mv a0, s1
    mv a1, s4
    mv a2, s3
    addi, a3, zero, 1
    #mv a4, s3
    mv a4, a5
    jal ra, dot # prepare arguments and call dot

    lw a6, 8(sp)
    mv s9, a0
    sw s9, 0(a6)

    
    addi s4, s4, 4
    addi a6, a6, 4
    sw a6, 8(sp)

    addi, s7, s7, 1
    sw, s7, 0(sp)
    j inner_loop_start

 inner_loop_end:

     
     add s1, s1, s8

     addi, s6, s6, 1
     sw s6, 4(sp)
     j outer_loop_start


 outer_loop_end:


     # Epilogue 
     lw a6, 8(sp)
     mv a0, a6
     lw s1, 72(sp)
     lw s2, 68(sp)
     lw s3, 64(sp)
     lw s4, 60(sp)
     lw s5, 56(sp)
     lw s6, 52(sp)
     lw s7, 48(sp)
     lw s8, 44(sp)
     lw s9, 40(sp)
     lw s10, 36(sp)
     lw s0, 76(sp)
     lw ra, 80(sp)
     addi sp, sp, 84
     ret

mismatched_dimensions:
     li a1 2
     jal exit2
