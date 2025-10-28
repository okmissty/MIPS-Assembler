.main
# Testcase 15b
# setup
addi $t0, $zero, -1               # $t0 = 0xFFFFFFFF
addi $t1, $zero, 0                # $t1 = 0x0
# test
xor $t2, $t0, $t1                 # $t2 = $t0 ⊕ $t1
# Expected Output: $t2 = 11111111111111111111111111111111 = 4294967295 = 0xFFFFFFFF