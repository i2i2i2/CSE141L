    set     94
    ldr1    $t0           ! load 95 to $acc1, counter
    ldm5    $t0           ! load last word at 95th mem to $acc5
    set     8
    ldm2    $t0           ! load word to match
    zero0                 ! zero $acc0, pattern match counter   (7)

loop:
    dec1
    ld4m1                 ! load word at mem of counter number
    add0c25               ! add 1 to $acc0 if lower 4 bit of $acc2 $acc4 match
    srl4                  ! shift right $acc4
    srf5                  ! shift right $acc5, shift in = shift out of $acc4
    add0c25
    srl4
    srf5
    add0c25
    srl4
    srf5
    add0c25
    srl4
    srf5
    add0c25
    srl4
    srf5
    add0c25
    srl4
    srf5
    add0c25
    srl4
    srf5
    add0c25
    srl4
    srf5                  ! shift right $acc4 $acc5 8 times
                          ! decrement counter
    b1ne31  loop          ! branch if counter reaches 31        (28*63)

end-loop:
    add0c25               ! add 1 to $acc0 if lower 4 bit of $acc2 $acc4 match
    srf5                  ! shift right $acc5, shift in = shift out of $acc4
    add0c25
    srf5
    add0c25
    srf5
    add0c25               ! check match extra 4 times,          (7)
    srf5
    add0c25

    !bbit    overflow

no-overflow:
    set     9
    stm0    $t0           ! store pattern counter               (2)

    halt                  !                               Total (1781)

overflow:
    set     255
    ldr1    $t0
    stm1    $t0

    halt
