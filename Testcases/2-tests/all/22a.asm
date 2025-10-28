.main
# Testcase 22a (srl on negative; zero-fill)
# setup
addi $t0, $zero, 15728640     # $t0 = 0xF0000000 = 15728640
# test
srl $t1, $t0, 5                  # t1 = t0 >> 5
# Expected Output: $t1 = 00000111100000000000000000000000 = 0x07800000