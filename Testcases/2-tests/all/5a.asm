.main
# Testcase 5a
# setup
addi $t2, $zero, 11             # t2 = 11
addi $t3, $zero, 4              # t3 = 4
# test
div $t2, $t3                    # HI:LO = $t2 / $t3
mfhi $t0                        # t0 (HI) should be 3
mflo $t1                        # t1 (LO) should be 2