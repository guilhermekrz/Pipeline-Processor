.data
A: 		 .byte 0x01
A_prime: .byte 0x01


.text
main:
	addi $t3, $zero, 8
	L1:
		lw $t1, A
		lw $t2, A_prime
		add $zero,$zero,$zero #nop
		add $t5, $t2, $zero # old A'
		add $t2, $t2, $t1
		sw $t5, A
		sw $t2, A_prime
		add $zero,$zero,$zero #nop
		add $t9, $t2, $zero # display A'
		beq $t3, $zero, L2
		add $zero,$zero,$zero #nop
		addi $t3, $t3, -1 # count down
		beq $zero, $zero, L1
		add $zero,$zero,$zero #nop
		L2:
		add $zero, $zero, $zero
		beq $zero, $zero, L2
		add $zero,$zero,$zero #nop