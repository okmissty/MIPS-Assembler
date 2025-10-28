.main
# Testcase 18a
# setup
# test
lui $t0, 0x1234                 # $t0 = imm << 16
# Expected Output: $t0 = 00010010001101000000000000000000 = 305397760 = 0x12340000