.main
# Testcase 4b
# setup
addi $t0, $zero, 4              # t0 = 4
addi $t1, $zero, 2              # t1 = 2
# test
mult $t0, $t1                   # HI:LO = $t0 * $t1
mflo $t2                        # t2 should be 8