! CORDIC

! -----:Register:-----:4 visible:-----:6 accumulator:-----:1 flag:-----------------------
! $acc0 - $acc5:  5 accumulator regs  (Inaccessible, set by accumulator)

! $flag:          1 1-bit flag reg    (Inaccessible, set by carry, shift-in/out)
! $flip:          1 1-bit adder-subtracter transition bit
! $t0 - $t3:      4 regular regs      accessible, load from/store to, shift
                                      ($t0 can be directly set to 8-bit number)

! --:Operations:--:1 set:--:30 acc:--:5 branch:--:9 anti-pattern:--:6 reg:--:1 halt----
! set:                    set immediate constant to register $t0                      (1)

! ldm[0-5]:               load rom memory address to $acc                             (6)
! ldr[1,4,5]:             load from regs to $acc, only for                            (2)
! add[1,4,5]:             add reg, set $flag to carry bit                             (4)
! addf[0,4]:              add and add flag bit, set $flag to carry bit                (3)
! sub[1,3-5]:             sub reg, set $flag to carry bit                             (4)
! subf2:                  sub and sub flag bit, set $flag to carry bit                (3)
! str[1-3]:               store from acc to regs                                      (4)
! stm[0,1,3,4,5]:         store from acc to memory                                    (4)

! mov:                    set reg with value store in $t0                             (1)
! srl:                    shift right logically, set 1 bit flag                       (1)
! sra:                    shift right arithmetically, and set 1 bit flag              (1)
! srf:                    shift right set msb with 1 bit flag                         (1)

! bnzr:                   branch if $t0 not equal to 0                                (1)
! bnuzr                   branch if upper 4 bit of $t0 is 0                           (1)
! b1ne31                  branch if $acc1 not equal 31                                (1)

! dec1                    decrease $acc1 by 1                                         (1)
! zero0                   zero $acc0                                                  (1)
! zero2                   zero $acc2                                                  (1)
! zero3                   zero $acc3                                                  (1)
! zero4                   zero $acc4                                                  (1)
! srl4:                   shift $acc4 right, set shift out to $flag                   (1)
! sra5:                   shift $acc5 right arithmetically, set $flag                 (1)
! srf5:                   shift $acc5 logically, set shift in to $flag                (1)
! sll1:                   shift $acc1 left, set shift out to $flag                    (1)
! slf0:                   shift $acc0 left, set shiftin as $flag, shiftout to $flag   (1)
! slf2:                   shift $acc2 left, set shiftin as $flag                      (1)
! add3_n2:                add register to $acc3 if $acc2 not negative, despite $flip  (1)
! add4_n2:                add register to $acc3 if $acc2 not negative, despite $flip  (1)
! cp0_5:                  copy $acc0 to $acc5                                         (1)
! inc_af0:                $flip? ($flag? do nothing: add 1) : (add $flag) to $acc0    (1)
! subf25:                 sub $acc5 from $acc2 and carry                              (1)
! add25:                  add $acc5 to $acc2                                          (12
! sub25:                  sub $acc5 from $acc3
! ld4m1                   load byte to $acc5, from memory stored in $acc1             (1)
! add0c24                 add 1 to $acc0 if upper 4bit of $acc2, $acc4 match          (1)
! atos_2                  set adder to subtracter if $acc2 negative                   (1)

! halt:                   signal stop                                                 (1)

  set     24
  ldm3    $t0             ! load lsw of y to $acc3
  set     16
  ldm2    $t0             ! load msw of y to $acc2
  set     8
  ldm1    $t0             ! load lsw of x to $acc1
  set     0
  ldm0    $t0             ! load msw of x to $acc0
  ldr4    $t0             ! set msw of angle to 0 at $acc4
                          ! lsw of angle set to $super later

                          ! prep loop
  cp0_5                   ! store msw of x to $acc5
  str1    $t1             ! store lsw of x to $t1
  str2    $t2             ! store msw of y to $t2
  str3    $t3             ! store lsw of y to $t3
  set     64              ! set $t0 to 0100 0000                                    (14)

loop-msw:
  sra5                    ! shift x msw, set shift-out to $flag
  srf     $t1             ! shift x lsw, set shift-in to $flag

  sra     $t2             ! shift y msw, set shift-out to $flag
  srf     $t3             ! shift y lsw, set shift-in to $flag

  atos_2                  ! set adder to subtracter if $acc2 negative

  add1    $t3
  addf0   $t2             ! x new = x + (y >> 1) or if flipped x new = x - (y >> 1)

  sub3    $t1
  subf25                  ! y new = y - (x >> 1) or if y new = y + (x >> 1)

  add4    $t0             ! sub if flipped

  cp0_5                   ! store new msw of x to $super
  str1    $t1             ! store new lsw of x to $t1
  str2    $t2             ! store new msw of y to $t2
  str3    $t3             ! store new lsw of y to $t3

  srl     $t0             ! shift t0
  bnzr    loop-msv        ! backward 21                                             (16*7)

end-loop-msw:             ! $t1 now x >> 8, $t3 now y >> 8
  sra     $t2             ! shift sign bit of y to $flag
  srl     $t1             ! x always positive, always shift in 0
  srf     $t3             ! shift in sign bit for the first loop
  mov     $t2             ! set $t0 = 2 to $t2, SOURCE of ZERO
  ldr5    $t0             ! set $acc5 to 0
  set     128             ! $t0 = 1000 0000                                         (6)

loop-lsw:
  atos_2                  ! set adder to subtracter if $acc2 negative

  add1    $t3             ! x new = x + (y >> 1) or if flipped x new = x - (y >> 1)
  inc_af_0                ! $flip? ($flag? do nothing: add 1) : (add $flag)

  sub3    $t1             ! y new = y - (x >> 1) or if flipped y new = y + (x >> 1)
  subf2   $t2             ! sub 0 and flag bit

  add5    $t0
  addf4   $t2             ! add to angle or subtract to angle if flipped

  str1    $t1             ! store lsw of x
  srl     $t1             ! shift logical, x always positive
  str3    $t3             ! store lsw of y
  sra     $t3             ! shift arithmetically, y can be negative

  srl     $t0             ! shift right angle
  bnuzr   loop-lsw        ! loop till $t0 = 0000 1000                               (13*4)

end-loop:
  set     5
  stm0    $t0
  set     6
  stm1    $t0
  set     7
  stm4    $t0
  set     8
  stm5    $t0

  halt                    ! store and stop                                          (9)
