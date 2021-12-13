#
#
# Filename: q5.asm
# Date created: 11/29/2021
#
# Author(s): Marcellus Von Sacramento 
#
# Purpose: The program will take 3 digits through MM I/O and make a real decimal value 
#		   out of it. The program will also output the result.
#
# Copyright(c)
#
#
# Last date modified: 12/12/2021
#
#

        .data
jTable: .word   hundredsPlace, tensPlace, onesPlace  # jumptable

        .text
        .globl main

main:                       # start of text segment
    li      $t1, 0          # counter for the digit place
    la      $t3, jTable     # load address of the jumptable
    lui     $t0, 0xffff     # 0xFFFF0000, base address of I/O

waitLoop:
    lw      $s0, 0($t0)     # load contents of receiver control register to $t1
    nop                     # delay
    andi    $s0, 0x0001     # extract the ready bit
    beqz    $s0, waitLoop   # check if ready bit is 1, reloop if not
    nop                     # delay

# extract the input from receiver data register
    lw      $s1, 4($t0)     # load contents of receiver data register
    nop                     # delay
    sll     $s1, $s1, 28    # shift left logical by 28 to get the lower 4 bits
    srl     $s1, $s1, 28    # shift right logical to get actual decimal digit

# check which digit place was read (i.e. 1st digit will be on the "hundreds" place, 2nd will be on the "tens" place, and so on)
    sll     $s0, $t1, 2     # calculate offset from base address of jumptable
    addu    $s0, $s0, $t3   # calculate jump address
    lw      $s2, 0($s0)     # load the address contained in $s0
    nop                     # delay
    jr      $s2             # jump to address contained in $s0
    nop  

hundredsPlace:
    li      $s0, 100        # $s0 = 100
    mult    $s1, $s0        # calculate the "hundreds" place by multiplying input by 100
    mflo    $s1             # get result from lo register
    #j       display        # jump back to waitloop to get next input
  #  nop

display:
    or      $a0, $s1, $s1   # copy contents of $s1 to $a0 for display
    li      $v0, 1          # service code for printing string
    syscall

exit:
    li      $v0, 10         # service code for returning control to OS
    syscall                 # return control to OS


# end of program
# end of file