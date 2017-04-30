! division

  set     128
  ldm0    $t0           ! $acc0 msw of dividend
  set     129
  ldm1    $t0           ! $acc1 lsw of dividend
  set     130
  ldm5    $t0           ! $acc5 divisor
  zero2                 ! zero $acc2 reminder


  sub25                 ! $acc2 -= divisor, must negative
  sll1
  slf0
  slf2                  ! (reminder, msw Dividend, lsw Dividend) << 1
  add25                 ! $acc2 += diviser, since last op make $acc2 negative
  set     64            ! set $t0 = 0100 0000
  add3_n2 $t0           ! if $acc2 non negative and $t0 to msw of quotient
  set     32            ! set $t0 = 0010 0000

loop-msw:
  atos2                 ! transit adder to subtracter if remainder negative
  sll1
  slf0
  slf2                  ! (reminder, msw Dividend, lsw Dividend) << 1
  sub25                 ! if negative, $acc2 += divisor, if positive $acc2 -= divisor
  add3_n2 $t0           ! if $acc2 non negative and $t0 to msw of quotient, despite if adder flipped

  srl     $t0           ! shift $t0
  bnzr    loop-msw

end-loop-msw:
  set     128           ! set $t0 = 1000 0000

loop-lsw:
  atos2                 ! transit adder to subtracter if remainder negative
  sll1
  slf0
  slf2                  ! (reminder, msw Dividend, lsw Dividend) << 1
  sub25                 ! if negative, $acc2 += divisor, if positive $acc2 -= divisor
  add4_n2 $t0           ! if $acc2 non negative and $t0 to lsw of quotient, despite if adder flipped

  srl     $t0           ! shift $t0
  bnzr    loop-lsw

end-loop-msw:
  set     126
  stm3    $t0           ! store msw of quotient
  set     127
  stm4    $t0           ! lsw of quotient

  halt
