.data
JUNK0: .byte 0xFF 0xFF 0xFF 0xFF 0xFF 0xFF
JUNK1: .byte 0xFF 0xFF 0xFF 0xFF 0xFF 0xFF
LIST: .byte 0x01 0x01 0x02 0x03 0x05 0x08
JUNK2: .byte 0xFF 0xFF 0xFF 0xFF 0xFF 0xFF

.text
main:
	addi $t3, $zero, 5
	addi $t6, $zero, 12
	L1:
		lw $t10, 0($t6)		# t9 = &t6
		addi $t6, $t6, 1	# Next memory address.
		addi $t3, $t3,-1	# t3--;
		beq $t3, $zero, L2	# if t3 == 0, then L2, else L1
		beq $zero, $zero, L1
		L2:
		add $zero, $zero, $zero
		beq $zero, $zero, L2