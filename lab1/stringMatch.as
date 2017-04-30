! stringMatch

  set     94
  ldr1    $t0           ! load 95 to $acc1, counter
  set     95
  ldm5    $t0           ! load last word to $acc5
  set     9
  ldm2    $t0           ! load word to match
  zero0                 ! zero $acc0, pattern match counter

loop:
  ld4m1                 ! load word at mem of counter number
  add0c24               ! add 1 to $acc0 if lower 4 bit of $acc2 $acc4 match
  srl4                  ! shift right $acc4
  srf5                  ! shift right $acc5, shift in = shift out of $acc4
  add0c24
  srl4
  srf5
  add0c24
  srl4
  srf5
  add0c24
  srl4
  srf5
  add0c24
  srl4
  srf5
  add0c24
  srl4
  srf5
  add0c24
  srl4
  srf5
  add0c24
  srl4
  srf5                  ! shift right $acc4 $acc5 8 times

  dec1                  ! decrement counter
  b1ne31  loop          ! branch if counter reaches 31

end-loop:
  add0c24               ! add 1 to $acc0 if lower 4 bit of $acc2 $acc4 match
  srf5                  ! shift right $acc5, shift in = shift out of $acc4
  add0c24
  srf5
  add0c24
  srf5
  add0c24               ! check match extra 4 times,

  set     10
  stm0    $t0           ! store pattern counter

  halt
