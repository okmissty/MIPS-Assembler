.main
# Testcase 5d
# setup
addi $s2, $zero, 32             # s2 = 32
addi $s3, $zero, -3             # s3 = -3
# test
div $s2, $s3                    # HI:LO = $s2 / $s3
mfhi $t0                        # t0 (HI) should be 2
mflo $t1                        # t1 (LO) should be -10