# Testcase 1a
# setup
addi $t1, $zero, 10            # t1 = 10
addi $t2, $zero, 2              # t2 = 2
# test
add $t0, $t1, $t2               # t0 should be 12

# Testcase 1b
# setup
addi $t1, $zero, 10            # t1 = 10
addi $t2, $zero, -2             # t2 = -2
# test
add $t0, $t1, $t2               # t0 should be 8

# Testcase 2a
# setup
addi $t0, $zero, 2              # t0 = 2

# test
addi $t0, $zero, 12             # t0 should be 14

# Testcase 2b
# test
addi $t1, $zero, -5              # t1 should be -5

# Testcase 2c
# test
addi $t0, $zero, 10             # t0 should be 10

# Testcase 2d
# setup
addi $t0, $zero, 10 
# test
addi $t1, $t0, -5              # t1 should be 5

