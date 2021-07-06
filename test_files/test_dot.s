.import ../dot.s
.import ../utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9
#vector0: .word 1 0 2 0 3 
#vector1: .word 1 3 5 
#vector0: .word 1 2 3 4 5 6
#vector1: .word 1 2 3 4 5 6 

.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    addi s2, zero, 9
    addi s3, zero, 1
    mv s4, s3
    # addi s2, zero, 3
    # addi s3, zero, 2
    # addi s4, zero, 1
    #addi s2, zero, 2
    #addi s3, zero, 1
    #addi s4, zero, 3


    # Call dot function
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    jal ra dot

    # Print integer result
    mv a1 a0
    jal ra print_int


    # Print newline
    li a1 '\n'
    jal ra print_char


    # Exit
    jal exit
