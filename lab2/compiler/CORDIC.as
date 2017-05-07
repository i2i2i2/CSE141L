    set     24
    ldm3    $t0             ! load lsw of y to $acc3
    set     16
    ldm2    $t0             ! load msw of y to $acc2
    set     8
    ldm1    $t0             ! load lsw of x to $acc1
    set     0
    ldm0    $t0             ! load msw of x to $acc0
    ldr4    $t0             ! set msw of angle to 0 at $acc4
                            ! lsw of angle set to $acc5 later

                            ! prep loop
    cp0_5                   ! store msw of x to $acc5
    str1    $t1             ! store lsw of x to $t1
    str2    $t2             ! store msw of y to $t2
    str3    $t3             ! store lsw of y to $t3
    set     64              ! set $t0 to 0100 0000         (14)

loop-msw:
    sra5                    ! shift x msw, set shift-out to $flag
    srf     $t1             ! shift x lsw, set shift-in to $flag

    sra     $t2             ! shift y msw, set shift-out to $flag
    srf     $t3             ! shift y lsw, set shift-in to $flag

    atos_2                  ! set adder to subtracter if $acc2 negative

    add1    $t3
    addf0   $t2             ! x new = x + (y >> 1) or x new = x - (y >> 1)

    sub3    $t1
    subf25                  ! y new = y - (x >> 1) or y new = y + (x >> 1)

    add4    $t0             ! sub if flipped

    cp0_5                   ! store new msw of x to $acc5
    str1    $t1             ! store new lsw of x to $t1
    str2    $t2             ! store new msw of y to $t2
    str3    $t3             ! store new lsw of y to $t3

    srl     $t0             ! shift t0
    bnzr    loop-msw        ! backward                     (16*7)

end-loop-msw:             ! $t1 now x >> 8, $t3 now y >> 8
    sra     $t2             ! shift sign bit of y to $flag
    srl     $t1             ! x always positive, always shift in 0
    srf     $t3             ! shift in sign bit for the first loop
    mov     $t2             ! set $t0 = 2 to $t2, SOURCE of ZERO
    ldr5    $t0             ! set $acc5 to 0
    set     128             ! $t0 = 1000 0000              (6)

loop-lsw:
    atos_2                  ! set adder to subtracter if $acc2 negative

    add1    $t3             ! x new = x + (y >> 1) or x new = x - (y >> 1)
    inc_af0                 ! $flip? ($flag? do nothing: add 1) : (add $flag)

    sub3    $t1             ! y new = y - (x >> 1) or y new = y + (x >> 1)
    subf2   $t2             ! sub 0 and flag bit

    add5    $t0
    addf4   $t2             ! add to angle or subtract to angle if flipped

    str1    $t1             ! store lsw of x
    srl     $t1             ! shift logical, x always positive
    str3    $t3             ! store lsw of y
    sra     $t3             ! shift arithmetically, y can be negative

    srl     $t0             ! shift right angle
    bnuzr   loop-lsw        ! loop till $t0 = 0000 1000    (13*4)

end-loop:
    set     5
    stm0    $t0
    set     6
    stm1    $t0
    set     7
    stm4    $t0
    set     8
    stm5    $t0             !                              (8)

    halt                    ! store and stop         Total (193)
