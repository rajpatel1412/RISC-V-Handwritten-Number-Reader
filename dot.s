.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s0, 28(sp)
    addi s0, sp, 36
    sw a0, 24(sp) # pointer to v0
    sw a1, 20(sp) # pointer to v1
    sw a2, 16(sp) # size
    sw a3, 12(sp) # stride v0
    sw a4, 8(sp) # stride v1
    sw zero, 4(sp) # initial sum t0
    sw zero 0(sp) # index t1

    # slli a3, a3, 2
    # slli, a4, a4, 2
    # sw a3, 12(sp)
    # sw a4, 8(sp)

loop_start:

    lw t0, 4(sp) # sum
    lw t1, 0(sp) # index
    lw a2, 16(sp)
    bge t1, a2, loop_end

    # lw a0, 24(sp)
    # lw a1, 20(sp)
    # lw a3, 12(sp)
    # lw a4, 8(sp)
    # lw t4, 0(a0)
    # lw t5, 0(a1)
    # add a0, a0, a3
    # add a1, a1, a4
    # sw a0, 24(sp)
    # sw a1, 20(sp)
    # mul t6, t4, t5
    # add t0, t0, t6
    # sw t0, 4(sp)
    # addi t1, t1, 1

    lw a0, 24(sp)
    lw a1 20(sp)
    lw a3, 12(sp)
    lw a4, 8(sp)
    mul t2, t1, a3 # stridev0 * index
    slli t2, t2, 2 # stridev0 * index * 4
    add t2, t2, a0 # address of element in v0
    mul t3, t1, a4 # stridev1 * index
    slli t3, t3, 2 # stridev1 * index * 4
    add t3, t3, a1 # address of element in v1
    lw t4, 0(t2) # dereference of element in v0
    lw t5, 0(t3) # dereference of element in v1
    mul t6, t4, t5
    add t0, t0, t6
    sw t0, 4(sp)
    addi t1, t1, 1
    sw t1, 0(sp)
    j loop_start


loop_end:
    # Epilogue
    lw a0, 4(sp)
    lw s0, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    
    ret
