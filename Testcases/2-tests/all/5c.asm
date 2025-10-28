.main
# Testcase 5c
# setup
addi $s0, $zero, -10            # s0 = -10
addi $s1, $zero, 3              # s1 = 3
# test
div $s0, $s1                    # HI:LO = $s0 / $s1
mfhi $t0                        # t0 (HI) should be -1
mflo $t1                        # t1 (LO) should be -3