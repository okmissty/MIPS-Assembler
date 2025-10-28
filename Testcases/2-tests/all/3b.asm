.main
# Testcase 3b
# setup
addi $t4, $zero, 10              # t4 = 10
addi $t5, $zero, 2              # t5 = 2
# test
sub $t3, $t4, $t5              # t3 should be 8