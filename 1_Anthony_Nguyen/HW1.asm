.text
# Prompt the user to enter X
li $v0, 4
la $a0, promptX
syscall

# Reads X
li $v0, 5
syscall
# Store the result in X
sw $v0, X

# Prompt the user to enter Y
li $v0, 4
la $a0, promptY
syscall

# Reads Y
li $v0, 5
syscall
# Store the result in Y
sw $v0, Y

#li $v0, 1		# prints out int X
#lw $a0, X
#syscall
#li $v0, 1		# prints out int Y
#lw $a0, Y
#syscall

# Displays
li $v0, 4
la $a0, result
syscall


lw $t0, X
lw $t1, Y
sub $t0, $t0, $t1		# t0 = X - Y
sw $t0, D

# Prints difference in $a0
li $v0,1	
lw $a0, D
syscall

# Exits program
li $v0, 10	
syscall

.data
result: .asciiz "\nThe difference between X and Y (X - Y) is "
promptX: .asciiz "Enter X: "
promptY: .asciiz "\nEnter Y: "
X: .word 0
Y: .word 0
D: .word 0
