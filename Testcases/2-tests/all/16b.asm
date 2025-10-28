.main
# Testcase 16b
# setup
addi $t0, $zero, 65535              # $t0 = 00000000000000001111111111111111 = 0x0000FFFF
# test
xori $t1, $t0, 0xFFFF               # $t1 = $t0 ⊕ imm = 0x00000000
# Expected Output: $t1 = 00000000000000000000000000000000 = 0 = 0x00000000