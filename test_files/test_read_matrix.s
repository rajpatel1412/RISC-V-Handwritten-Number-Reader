.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_files/test_input.bin"

.text
main:
    # Read matrix into memory
    la a1, file_path

    # Print out elements of matrix
    la a0, file_path
    jal read_matrix

    mv s1, a0
    mv s2, a1
    lw s3, 0(s2)
    mv s4, a2
    lw s5, 0(s4)

    mv a0, s1
    mv a1, s3
    mv a2, s5
    jal print_int_array


    # Terminate the program
    addi a0, x0, 10
    ecall