.main
# Testcase 23a
# setup
addi $t2, $zero, 11             # t2 = 11
addi $t3, $zero, 4              # t3 = 4
# test
div $t2, $t3                    # HI:LO = $t2 / $t3
mult $t2, $t3                   # HI:LO = $t2 * $t3
mfhi $t4                        # t4 should be 0 = 0x00000000
mflo $t5                        # t5 should be 44 = 0x0000002C