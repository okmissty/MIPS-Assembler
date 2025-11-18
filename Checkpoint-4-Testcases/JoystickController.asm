# X:-176 (0x3FFFF50), Y:-172 (0x3FFFF54)
.text
main:
  addi $sp,$0,-4096
loop:
  lw   $t0,-176($0)      # X
  lw   $t1,-172($0)      # Y
  sll  $t0,$t0,28        # mask low 4 bits without andi
  srl  $t0,$t0,28
  sll  $t1,$t1,28
  srl  $t1,$t1,28
  add  $s0,$s0,$t0
  add  $s1,$s1,$t1
  j    loop
