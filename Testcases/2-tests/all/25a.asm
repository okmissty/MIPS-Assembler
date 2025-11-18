# TESTCASES FOR PROJECT CHECKPOINT 3  (no $a* or $v* regs used)

.main
# --- Setup small values; exercise sw/lw at aligned addresses 0 and 4 ---
    addi  $t0, $zero, 1          # 0000 $t0=1
    addi  $t1, $zero, 2          # 0001 $t1=2
    addi  $t2, $zero, 3          # 0002 $t2=3

    sw    $t0, 0($zero)          # 0003 MEM[0]   = 1
    sw    $t1, 4($zero)          # 0004 MEM[4]   = 2
    lw    $t3, 0($zero)          # 0005 $t3=1
    lw    $t4, 4($zero)          # 0006 $t4=2

# --- Branches: beq not-taken, then bne taken to “took1” ---
    beq   $t3, $t4, skip1        # 0007 1==2? no -> not taken
    bne   $t3, $t4, took1        # 0008 1!=2 -> taken, skip next

skip1:
    addi  $t5, $zero, 999        # 0009 would run only if bne not taken (it IS taken)

took1:                            # now here
    add   $t6, $t3, $t4          # 0010 $t6=1+2=3
    beq   $t6, $t2, next1        # 0011 3==3 -> taken, skip next
    addi  $t7, $zero, 123        # 0012 would be skipped by taken beq

# --- Absolute jump (“j”) to jtarget ---
next1:
    j     jtarget                # 0013 jump to jtarget
    addi  $zero, $zero, 0        # 0014 padding

# --- JAL to func; verify link goes to $ra; then test JALR ---
jtarget:
    jal   func                   # 0015 link $ra = PC+4, jump to func
    addi  $t0, $zero, 132        # 0016 prepare absolute byte addr for JALR target
    jalr  $t0, $s1               # 0017 jump to *$t0, link in $s1

# --- Func: set a value and return via jr $ra ---
func:
    addi  $s2, $zero, 7          # 0018 place 7 in $s2 (used instead of $v0)
    jr    $ra                    # 0019 return to caller

# --- After returning from JAL, execution resumes here ---
# Add a not-taken branch, then do syscall (your design: jalr $zero,$k0)
    bne   $t2, $t2, label        # 0020 not taken
    syscall                      # 0021 (wired as jalr $zero,$k0 in your control)

# --- JALR target block at absolute address 132 ---
# jalr linked to $s1, so return with jr $s1
jalr_target:                     # byte address 132 (i.e., instruction index 33)
    addi  $s3, $zero, 42         # use $s3 instead of $a0
    jr    $s1

end:
    j end
