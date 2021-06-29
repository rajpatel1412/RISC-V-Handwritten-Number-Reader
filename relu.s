.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -20
    sw ra, 16(sp) 
    sw s0, 12(sp) 
    addi s0, sp, 20
    sw a0, 8(sp)
    sw a1, 4(sp)
    sw zero, 0(sp)
    j loop_start

loop_start:
    lw t0, 0(sp) # index
    lw a1, 4(sp) # size
    bge t0, a1, loop_end # if i >= size jump to loop end

    lw a0, 8(sp) # base address
    slli t0, t0, 2 # index in bytes
    add t1, a0, t0 # add index to base address
    lw t2, 0(t1) # load dereference value
    bge t2, zero, loop_continue #if t2 >= 0 jump to loop continue

    sw zero, 0(t1) # if true, then sotre 0 in the address of t1
    j loop_continue # jump to continue

loop_continue: #indes increment
    lw t1, 0(sp)
    addi t1, t1, 1
    sw t1, 0(sp)
    j loop_start


loop_end:

    # Epilogue
    lw s0, 12(sp) 
    lw ra, 16(sp) 
    addi sp, sp, 20
    
	ret


