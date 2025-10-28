.main
# Testcase 5b
# setup
addi $t5, $zero, 10             # t5 = 10
addi $t6, $zero, 3              # t6 = 3
# test
div $t5, $t6                    # HI:LO = $t5 / $t6
mfhi $t0                        # t0 (HI) should be 1
mflo $t1                        # t1 (LO) should be 3

