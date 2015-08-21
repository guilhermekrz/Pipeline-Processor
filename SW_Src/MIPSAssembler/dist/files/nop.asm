.data

.text
main:
	addi $t0, $zero, 10
	addi $t1, $zero, 1
	add $zero,$zero,$zero #nop
	add $zero,$zero,$zero #nop
Label1: 	
	sub $t0, $t0, $t1
	add $zero,$zero,$zero #nop
	add $zero,$zero,$zero #nop
	beq $zero, $t0, end
	add $zero,$zero,$zero #nop
	beq $zero,$zero,Label1
	add $zero,$zero,$zero #nop
end:	
	beq $zero,$zero,end
	add $zero,$zero,$zero #nop
	
