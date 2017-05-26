    set     127
    ldm0    $t0           ! $acc0 msw of dividend
    set     128
    ldm1    $t0           ! $acc1 lsw of dividend
    set     129
    ldm5    $t0           ! $acc5 divisor                        (7)

    set     128            ! set $t0 = 1000 0000                 (8)

loop-msw:
    atos_2                ! transit adder to subtracter if remainder negative
    slf1
    slf0
    slf2                  ! (reminder, msw Dividend, lsw Dividend) << 1
    sub25                 ! if neg, $acc2 += divisor, if pos $acc2 -= divisor
    add3_n2 $t0           ! if $acc2 >=0 add $t0 to msw quotient, despite flipped

    srl     $t0           ! shift $t0
    bnzr    loop-msw      !                                     (8*6)

end-loop-msw:
    set     128           ! set $t0 = 1000 0000                 (1)

loop-lsw:
    atos_2                 ! transit adder to subtracter if remainder negative
    slf0
    slf2                  ! (reminder, msw Dividend, lsw Dividend) << 1
    sub25                 ! if neg, $acc2 += divisor, if pos $acc2 -= divisor
    add4_n2 $t0           ! if $acc2 >=0 and $t0 to lsw quotient, despite flipped

    srl     $t0           ! shift $t0
    bnzr    loop-lsw      !                                     (8*8)

end-loop-lsw:
    set     125
    stm3    $t0           ! store msw of quotient
    set     126
    stm4    $t0           ! lsw of quotient                     (4)

    halt                  !                               Total (133)
