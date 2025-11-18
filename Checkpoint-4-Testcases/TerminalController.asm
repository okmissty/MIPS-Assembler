.text
main:
  addi $sp,$0,-4096
  addi $t0,$0,65        # 'A'
  sw   $t0,-256($0)     # 0x3FFFF00
  j    main
