.main
# Testcase 21a (Test min negative immediate)
# setup
lui $t0, 0x2108                 # $t0 = imm << 16 = 0x21080000
# test
addi $t0, $t0, 0x8000           # $t0 = $t0 + imm = 0x21078000
# Expected Output: $t0 = 0010 0001 0000 1000 0111 1000 0000 0000 = 0x21078000