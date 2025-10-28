.main
# Testcase 5e
# setup
addi $s4, $zero, -100           # s4 = -100
addi $s5, $zero, -3             # s5 = -3
# test
div $s4, $s5                    # HI:LO = $s4 / $s5
mfhi $t0                        # t0 (HI) should be -10
mflo $t1                        # t1 (LO) should be 30
