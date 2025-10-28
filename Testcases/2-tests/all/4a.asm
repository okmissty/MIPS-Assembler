.main
# Testcase 4a
# setup
addi $t8, $zero, -2             # t8 = -2
addi $t7, $zero, -15            # t7 = -15
# test
mult $t8, $t7                   # HI:LO = $t8 * $t7
mflo $t2                        # t2 should be 30