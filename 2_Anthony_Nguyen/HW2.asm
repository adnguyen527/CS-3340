.data
promptInput:	.asciiz "Enter a number between 0 and 100."
input:		.word 0
array:		.space 1000
sum:		.word 0
closing1:		.asciiz "The sum of the odd integers from 0 to "
closing2:		.asciiz " is "
.text
main:
# Prompt to enter a number
	li 	$v0, 4
	la 	$a0, promptInput
	syscall
# Reads input
	li 	$v0, 5
	syscall
	sw 	$v0, input 	# stores input
	
# Checks if equal to zero
	lw 	$t0, input
	beq 	$t0, $zero, done
	
# Creates an array with dimension size of the input
	lw	$s0, input
	la 	$s1, array
	li 	$t0, 0 		# initialize
# Puts values in the array
	addi	$s0, $zero, 0
	addi	$t1, $zero, 0	# increment
	lw	$t0, input
loop:
	sw	$s0, array($t1)
	beq	$s0, $t0, next
	add	$s0, $s0, 1	# next spot in array
	add	$t1, $t1, 4	# increment
	j	loop
	
	#li $v0, 1
	#addi $t0, $zero, 16
	#lw $a0, array($t0)
	#syscall
next:
	lw	$t0, input	# $t0 has the input
	addi	$t1, $zero, 0	# increment
	lw	$s0, sum	# sum register
loop2:
	lw	$t2, array($t1)	# $t2 has the number from the array
	and	$a0, $t2, 1
	bne	$a0, 1, even	# test if odd or even
	add	$s0, $s0, $t2	# add odd numbers
even:	# do nothing
	add	$t1, $t1, 4	# increment
	beq 	$t2, $t0, final
	j 	loop2
# final printing of results
final:
	sw	$s0, sum

	li	$v0, 4
	la	$a0, closing1	# closing statement
	syscall
	li	$v0, 1
	lw	$a0, input	# prints the input
	syscall
	li	$v0, 4
	la	$a0, closing2
	syscall
	li	$v0, 1
	lw	$a0, sum	# prints the sum
	syscall
	
done:	# exits the program
	li	$v0, 10
	syscall