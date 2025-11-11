# STATUS -240 (0x3FFFF10), DATA -236, TERM -256
.text
main:
  addi $sp,$0,-4096
loop:
  lw   $t0,-240($0)     # status
  beq  $t0,$0,loop
  lw   $t1,-236($0)     # char
  sw   $0,-240($0)      # pop
  sw   $t1,-256($0)     # echo
  j    loop
