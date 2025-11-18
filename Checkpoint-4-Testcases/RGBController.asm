# X:-224, Y:-220, COLOR:-216, GO:-212
.text
main:
  addi $sp,$0,-4096
  addi $t0,$0,10        # x
  sw   $t0,-224($0)
  addi $t0,$0,5         # y
  sw   $t0,-220($0)
  lui  $t0,0x00FF       # color 0x00FF00 (green) if you have lui; else add upper/low manually
  ori  $t0,$t0,0x0000
  sw   $t0,-216($0)
  sw   $0,-212($0)      # draw
halt: j halt
