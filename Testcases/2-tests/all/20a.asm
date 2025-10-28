.main
# Testcase 20a (Test max positive immediate)
# setup
lui $t0, 0x2108                 # $t0 = imm << 16 = 0x21080000
# test
addi $t0, $t0, 0x7FFF           # $t0 = $t0 + imm = 0x21087FFF
# Expected Output: $t0 = 0010 0001 0000 1000 0111 1111 1111 1111 = 0x21087FFF