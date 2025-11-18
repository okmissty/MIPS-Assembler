.text
main:
  addi $sp,$0,-4096
  addi $t0,$0,440
  sw   $t0,-128($0)     # 0x3FFFF80 freq
  addi $t0,$0,60
  sw   $t0,-124($0)     # 0x3FFFF84 vol
  sw   $0,-120($0)      # 0x3FFFF88 toggle ON
spin: j spin
