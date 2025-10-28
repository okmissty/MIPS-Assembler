.main
# Testcase 17a
# setup
addi $t0, $zero, 305419896     # t0 = 00010010001101000101011001111000 = 305419896 = 0x12345678
addi $t1, $zero, 0              # t1 = 0
# test
nor $t2, $t0, $t1               # $t2 = $t0 ~| $t1
# Expected Output: $t2 = 11101101110010111010100110000111 = 3989547399 = 0xEDCBA987