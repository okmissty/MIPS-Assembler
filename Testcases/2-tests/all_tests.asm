.main
# Testcase 1a
# setup
addi $t1, $zero, 10            # t1 = 10
addi $t2, $zero, 2              # t2 = 2
# test
add $t0, $t1, $t2               # t0 should be 12

# Testcase 1b
# setup2    
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
# setup
addi $t1, $zero, -1
# test
addi $t1, $zero, -5              # t1 should be -5

# Testcase 2c
# setup
addi $t0, $zero, 0
# test
addi $t0, $zero, 10             # t0 should be 10

# Testcase 2d
# setup
addi $t0, $zero, 10 
# test
addi $t1, $t0, -5              # t1 should be 5

# Testcase 3a
# setup
addi $t1, $zero, -10              # t1 = -10
addi $t2, $zero, 2              # t2 = 2
# test
sub $t0, $t1, $t2              # t0 should be -12

# Testcase 3b
# setup
addi $t4, $zero, 10              # t4 = 10
addi $t5, $zero, 2              # t5 = 2
# test
sub $t3, $t4, $t5              # t3 should be 8

# Testcase 4a
# setup
addi $t8, $zero, -2             # t8 = -2
addi $t7, $zero, -15            # t7 = -15
# test
mult $t8, $t7                   # HI:LO = $t8 * $t7
mflo $t2                        # t2 should be 30

# Testcase 4b
# setup
addi $t0, $zero, 4              # t0 = 4
addi $t1, $zero, 2              # t1 = 2
# test
mult $t0, $t1                   # HI:LO = $t0 * $t1
mflo $t2                        # t2 should be 8

# Testcase 5a
# setup
addi $t2, $zero, 11             # t2 = 11
addi $t3, $zero, 4              # t3 = 4
# test
div $t2, $t3                    # HI:LO = $t2 / $t3
mfhi $t0                        # t0 (HI) should be 3
mflo $t1                        # t1 (LO) should be 2

# Testcase 5b
# setup
addi $t5, $zero, 10             # t5 = 10
addi $t6, $zero, 3              # t6 = 3
# test
div $t5, $t6                    # HI:LO = $t5 / $t6
mfhi $t0                        # t0 (HI) should be 1
mflo $t1                        # t1 (LO) should be 3

# Testcase 5c
# setup
addi $s0, $zero, -10            # s0 = -10
addi $s1, $zero, 3              # s1 = 3
# test
div $s0, $s1                    # HI:LO = $s0 / $s1
mfhi $t0                        # t0 (HI) should be -1
mflo $t1                        # t1 (LO) should be -3

# Testcase 5d
# setup
addi $s2, $zero, 32             # s2 = 32
addi $s3, $zero, -3             # s3 = -3
# test
div $s2, $s3                    # HI:LO = $s2 / $s3
mfhi $t0                        # t0 (HI) should be 2
mflo $t1                        # t1 (LO) should be -10

# Testcase 5e
# setup
addi $s4, $zero, -100           # s4 = -100
addi $s5, $zero, -3             # s5 = -3
# test
div $s4, $s5                    # HI:LO = $s4 / $s5
mfhi $t0                        # t0 (HI) should be -10
mflo $t1                        # t1 (LO) should be 30

# Testcase 8a
# setup
addi $t0, $zero, 3              # t0 = 3
# test
sll $t1, $t0, 4                  # t1 = t0 << 4
# Expected Output: $t1 = 48 = 0x00000030

# Testcase 8b
# setup
addi $t0, $zero, 1              # t0 = 1
# test
sll $t1, $t0, 31                 # t1 = t0 << 31
# Expected Output: $t1 = 2147483648 = 0x80000000

# Testcase 8c
# setup
addi $t0, $zero, 4026531841    # t0 = 1111 0000 0000 0000 0000 0000 0000 0001 = 4026531841 = 0xF0000001
# test
sll $t1, $t0, 1                  # t1 = t0 << 1
# Expected Output: $t1 = 1110 0000 0000 0000 0000 0000 0000 0010 = 3758096386 = 0xE0000002

# Testcase 8d
# setup
addi $t0, $zero, 305419896     # t0 = 0001 0010 0011 0100 0101 0110 0111 1000 = 305419896 = 0x12345678
# test
sll $t1, $t0, 1                  # t1 = t0 << 1
# Expected Output: $t1 = 0010 0100 0110 1000 1010 1100 1111 0000 = 610839792 = 0x2468ACF0

# Testcase 9a
# setup
addi $t0, $zero, 2147483648    # t0 = 1000 0000 0000 0000 0000 0000 0000 0000 = 2147483648 = 0x80000000
# test
srl $t1, $t0, 1                  # t1 = t0 >> 1
# Expected Output: $t1 = 0100 0000 0000 0000 0000 0000 0000 0000 = 1073741824 = 0x40000000

# Testcase 9b
# setup
addi $t0, $zero, 1              # t0 = 0000 0000 0000 0000 0000 0000 0000 0001
# test
srl $t1, $t0, 1                  # t1 = t0 >> 1
# Expected Output: $t1 = 0000 0000 0000 0000 0000 0000 0000 0000 = 0 = 0x00000000

# Testcase 9c
# setup
addi $t0, $zero, -1             # t0 = 1111 1111 1111 1111 1111 1111 1111 1111 = 4294967295 = 0xFFFFFFFF 
# test
srl $t1, $t0, 4                  # t1 = t0 >> 4
# Expected Output: $t1 = 0000 1111 1111 1111 1111 1111 1111 1111 = 268435455 = 0xFFFFFFF

# Testcase 9d
# setup
addi $t0, $zero, 25769803775   # t0 = 1000 1001 1010 1011 1100 1101 1110 1111 = 2309737967 = 0x89ABCDEF
# test
srl $t1, $t0, 31                 # t1 = t0 >> 31
# Expected Output: $t1 = 0000 0000 0000 0000 0000 0000 0000 0001 = 1 = 0x00000001

# Testcase 10a
# setup
addi $t0, $zero, -1             # $t0 = -1
addi $t1, $zero, 1              # $t1 = 1
# test
slt $t2, $t0, $t1               # $t2 = 1 (since -1<1)
# Expected Output: $t2 = 1

# Testcase 10b
# setup
addi $t0, $zero, 5              # $t0 = 5
addi $t1, $zero, -3             # $t1 = -3
# test
slt $t2, $t0, $t1               # $t2 = 0 (since 5 !< -3)
# Expected Output: $t2 = 0

# Testcase 10c
# setup
addi $t0, $zero, 7              # $t0 = 7
addi $t1, $zero, 7              # $t1 = 7
# test
slt $t2, $t0, $t1               # $t2 = 0 (since 7 !< 7)
# Expected Output: $t2 = 0

# Testcase 11a
# setup
addi $t0, $zero, 4042322160           # $t0 = 1111 0000 1111 0000 1111 0000 1111 0000 = 4042322160 = 0xF0F0F0F0
addi $t1, $zero, 252645135            # $t1 = 0000 1111 0000 1111 0000 1111 0000 1111 = 252645135 = 0x0F0F0F0F
# test
and $t2, $t0, $t1               # $t2 = $t0 & $t1
# Expected Output: $t2 = 0000 0000 0000 0000 0000 0000 0000 0000 = 0 = 0x00000000

# Testcase 11b
# setup
addi $t0, $zero, 4294902015           # $t0 = 1111 1111 1111 1111 0000 0000 0000 0000 = 4294902015 = 0xFFFF0000
addi $t1, $zero, 16711935              # $t1 = 0000 0000 1111 1111 0000 0000 1111 1111 = 16711935 = 0xFF00FF
# test
and $t2, $t0, $t1               # $t2 = $t0 & $t1 
# Expected Output: $t2 = 0000 0000 1111 1111 0000 0000 0000 0000 = 16711680 = 0xFF0000

# Testcase 12a
# setup
addi $t0, $zero, 305419896     # t0 = 0001 0010 0011 0100 0101 0110 0111 1000 = 305419896 = 0x12345678
# test
andi $t1, $t0, 15               # t1 = t0 & imm (15 = 0x0000000F)
# Expected Output: t1 = 0000 0000 0000 0000 0000 0000 0000 1000 = 8 = 0x00000008

# Testcase 12b
# setup
addi $t0, $zero, 4294902015         # t0 = 1111 1111 1111 1111 0000 0000 0000 0000 = 4294902015 = 0xFFFF00FF
# test
andi $t1, $t0, 64512                 # t1 = t0 & imm (64512 = 0xFC00)
# Expected Output: t1 = 0000 0000 0000 0000 0000 0000 0000 0000 = 0 = 0x00000000

# Testcase 12c
# setup
addi $t0, $zero, 65535              # t0 = 0000 0000 0000 0000 1111 1111 1111 1111 = 65535 = 0x0000FFFF
# test
andi $t1, $t0, 255                  # t1 = t0 & imm (255 = 0x000000FF)
# Expected Output: t1 = 0000 0000 0000 0000 0000 0000 1111 1111 = 255 = 0x000000FF

# Testcase 13a
# setup
addi $t0, $zero, 4042322160        # $t0 = 1111 0000 1111 0000 1111 0000 1111 0000 = 4042322160 = 0xF0F0F0F0
addi $t1, $zero, 252645135         # $t1 = 0000 1111 0000 1111 0000 1111 0000 1111 = 252645135 = 0xF0F0F0F
# test
or $t2, $t0, $t1                   # $t2 = $t0 | $t1
# Expected Output: $t2 = 1111 1111 1111 1111 1111 1111 1111 1111 = 4294967295 = 0xFFFFFFFF

# Testcase 13b
# setup
addi $t0, $zero, 305397760     # t0 = 0001 0010 0011 0100 0000 0000 0000 0000 = 305397760 = 0x12340000
addi $t1, $zero, 22136         # t1 = 0000 0000 0000 0000 0101 0110 0111 1000 = 22136 = 0x00005678
# test
or $t2, $t0, $t1               # $t2 = $t0 | $t1
# Expected Output: $t2 = 0001 0010 0011 0100 0101 0110 0111 1000 = 305419896 = 0x12345678

# Testcase 14a
# setup
addi $t0, $zero, 305397760     # t0 = 0001 0010 0011 0100 0000 0000 0000 0000 = 305397760 = 0x12340000
# test
ori $t0, $t0, 22136            # t0 = $t0 | imm (22136 = 0x5678)
# Expected Output: t0 = 0000 0001 0010 0011 0100 0101 0110 0111 1000 = 305419896 = 0x12345678

# Testcase 14b
# setup
addi $t1, $zero, 4294902015       # t1 = 11111111111111110000000000000000 =4294901760 = 0xFFFF0000
# test
ori $t2, $t1, 255                 # t2 = $t1 | imm (255 = 0x00FF)
# Expected Output: t2 = 1111 1111 1111 1111 0000 0000 1111 1111 = 4294902015 = 0xFFFF00FF

# Testcase 15a
# setup
addi $t0, $zero, 2863289685      # $t0 = 10101010101010100101010101010101 = 2863289685 = 0xAAAA5555
addi $t1, $zero, 16711935        # $t1 = 00000000111111110000000011111111 = 16711935 = 0x00FF00FF
# test
xor $t2, $t0, $t1                 # $t2 = $t0 ⊕ $t1
# Expected Output: $t2 = 10101010010101010101010110101010 = 2857719210 = 0xAA5555AA

# Testcase 15b
# setup
addi $t0, $zero, -1               # $t0 = 0xFFFFFFFF
addi $t1, $zero, 0                # $t1 = 0x0
# test
xor $t2, $t0, $t1                 # $t2 = $t0 ⊕ $t1
# Expected Output: $t2 = 11111111111111111111111111111111 = 4294967295 = 0xFFFFFFFF

# Testcase 16a
# setup
addi $t0, $zero, 2863289685      # $t0 = 10101010101010100101010101010101 = 2863289685 = 0xAAAA5555
# test
xori $t1, $t0, 0x00FF            # $t1 = $t0 ⊕ imm = 0xAAAA55AA
# Expected Output: $t1 = 10101010101010100101010110101010 = 2863289770 = 0xAAAA55AA

# Testcase 16b
# setup
addi $t0, $zero, 65535              # $t0 = 00000000000000001111111111111111 = 0x0000FFFF
# test
xori $t1, $t0, 0xFFFF               # $t1 = $t0 ⊕ imm = 0x00000000
# Expected Output: $t1 = 00000000000000000000000000000000 = 0 = 0x00000000

# Testcase 17a
# setup
addi $t0, $zero, 305419896     # t0 = 00010010001101000101011001111000 = 305419896 = 0x12345678
addi $t1, $zero, 0              # t1 = 0
# test
nor $t2, $t0, $t1               # $t2 = $t0 ~| $t1
# Expected Output: $t2 = 11101101110010111010100110000111 = 3989547399 = 0xEDCBA987

# Testcase 17b
# setup
addi $t0, $zero, -1             # $t0 = 0x
addi $t1, $zero, -1             # $t1 = 0xFFFFFFFF
# test
nor $t2, $t0, $t1               # $t2 = $t0 ~| $t1
# Expected Output: $t2 = 00000000000000000000000000000000 = 0 = 0x00000000

# Testcase 18a
# setup
# test
lui $t0, 0x1234                 # $t0 = imm << 16
# Expected Output: $t0 = 00010010001101000000000000000000 = 305397760 = 0x12340000

# Testcase 19a
# setup
# test
add $zero, $t0, $t1             # $zero should remain 0
# Expected Output: $zero = 00000000000000000000000000000000 = 0 = 0x00000000

# Testcase 20a (Test max positive immediate)
# setup
lui $t0, 0x2108                 # $t0 = imm << 16 = 0x21080000
# test
addi $t0, $t0, 0x7FFF           # $t0 = $t0 + imm = 0x21087FFF
# Expected Output: $t0 = 0010 0001 0000 1000 0111 1111 1111 1111 = 0x21087FFF

# Testcase 21a (Test min negative immediate)
# setup
lui $t0, 0x2108                 # $t0 = imm << 16 = 0x21080000
# test
addi $t0, $t0, 0x8000           # $t0 = $t0 + imm = 0x21078000
# Expected Output: $t0 = 0010 0001 0000 1000 0111 1000 0000 0000 = 0x21078000

# Testcase 22a (srl on negative; zero-fill)
# setup
addi $t0, $zero, 15728640     # $t0 = 0xF0000000 = 15728640
# test
srl $t1, $t0, 5                  # t1 = t0 >> 5
# Expected Output: $t1 = 00000111100000000000000000000000 = 0x07800000

# Testcase 23a
# setup
addi $t2, $zero, 11             # t2 = 11
addi $t3, $zero, 4              # t3 = 4
# test
div $t2, $t3                    # HI:LO = $t2 / $t3
mult $t2, $t3                   # HI:LO = $t2 * $t3
mfhi $t4                        # t4 should be 0 = 0x00000000
mflo $t5                        # t5 should be 44 = 0x0000002C

# Testcase 24a
# setup
addi $t0, $zero, 305441741     # t0 = 00010010001101001010101111001101 = 305441741 = 0x1234ABCD
# test
andi $t1, $t0, 0xFFFF          # t1 = t0 & imm
# Expected Output: t1 = 00000000000000001010101111001101 = 43981 = 0x0000ABCD