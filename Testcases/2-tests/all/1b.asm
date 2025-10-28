.main
# Testcase 1b
# setup2    
addi $t1, $zero, 10            # t1 = 10
addi $t2, $zero, -2             # t2 = -2
# test
add $t0, $t1, $t2               # t0 should be 8