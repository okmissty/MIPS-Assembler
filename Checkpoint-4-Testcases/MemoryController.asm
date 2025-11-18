.text
main:
  addi $sp,$0,-4096

  # store and load roundtrip
  addi $t0,$0,12345
  la   $t1, 0($0)        # any RAM address < 0x3FFFF00
  sw   $t0, 0($t1)
  lw   $t2, 0($t1)
  beq  $t2,$t0, ok
bad: j bad
ok:  j ok
