.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    addi    sp, sp, -28
    sw      ra, 24(sp) # return address                   
    sw      s0, 20(sp) # frame pointer                     
    addi    s0, sp, 28
    sw      a0, 16(sp) # pointer to array
    sw      a1, 12(sp) # size of array
    lw      t0, 0(a0)
    sw      t0, 8(sp) # initial max
    sw      zero, 4(sp) # initial index
    addi    t1, zero, 1
    sw      t1, 0(sp) # i

loop_start:

    lw      t1, 0(sp) # i
    lw      a1, 12(sp) # size
    bge     t1, a1, loop_end # if i >= size jump to loop_end
    lw      a0, 16(sp) # base address
    slli    t4, t1, 2 # i in bytes
    add     t2, a0, t4 # address of index in array
    lw      t3, 0(t2) # dereference of array index
    lw      t0, 8(sp) # max
    bge     t0, t3, loop_continue # if max >= a[i] jump to loop_continue
    sw      t3, 8(sp) # max
    sw      t1, 4(sp) # index
    j       loop_continue

loop_continue:
    
    lw      t1, 0(sp) # i
    addi    t1, t1, 1
    sw      t1, 0(sp) # i
    j       loop_start


loop_end:

    # Epilogue
    lw      a0, 4(sp) # index
    lw      s0, 20(sp)                      
    lw      ra, 24(sp)                      
    addi    sp, sp, 28
    ret
