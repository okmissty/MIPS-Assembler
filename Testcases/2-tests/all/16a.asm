.main
# Testcase 16a
# setup
addi $t0, $zero, 2863289685      # $t0 = 10101010101010100101010101010101 = 2863289685 = 0xAAAA5555
# test
xori $t1, $t0, 0x00FF            # $t1 = $t0 ⊕ imm = 0xAAAA55AA
# Expected Output: $t1 = 10101010101010100101010110101010 = 2863289770 = 0xAAAA55AA