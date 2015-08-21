.data
JUNK0: .byte 0xFF 0xFF 0xFF 0xFF 0xFF 0xFF
JUNK1: .byte 0xFF 0xFF 0xFF 0xFF 0xFF 0xFF
LIST: .byte 0x01 0x01 0x02 0x03 0x05 0x08
JUNK2: .byte 0xFF 0xFF 0xFF 0xFF 0xFF 0xFF

.text
main:
	addi $t3, $zero, 5
	la $t6, JUNK0
	la $t6, JUNK1
	la $t6, JUNK2
	la $t6, LIST # has first index of LIST
	L1:
		lw $t9, 0($t6)
		addi $t6, $t6, 1 # next address of LIST
		beq $t3, $zero, L2
		addi $t3, $t3, -1 # count down
		beq $zero, $zero, L1
		L2:
		add $zero, $zero, $zero
		beq $zero, $zero, L2