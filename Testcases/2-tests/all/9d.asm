.main
# Testcase 9d
# setup
addi $t0, $zero, 25769803775   # t0 = 1000 1001 1010 1011 1100 1101 1110 1111 = 2309737967 = 0x89ABCDEF
# test
srl $t1, $t0, 31                 # t1 = t0 >> 31
# Expected Output: $t1 = 0000 0000 0000 0000 0000 0000 0000 0001 = 1 = 0x00000001