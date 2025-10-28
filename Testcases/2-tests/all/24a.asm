.main
# Testcase 24a
# setup
addi $t0, $zero, 305441741     # t0 = 00010010001101001010101111001101 = 305441741 = 0x1234ABCD
# test
andi $t1, $t0, 0xFFFF          # t1 = t0 & imm
# Expected Output: t1 = 00000000000000001010101111001101 = 43981 = 0x0000ABCD