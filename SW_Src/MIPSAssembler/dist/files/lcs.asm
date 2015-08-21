.data
#result: index 4 to index 6, length = 3
S: .byte 0x41 0x6C 0x6F 0x20 0x4D 0x61 0x6D 0x61 0x65 0x00 #0x00 = '\0'
#s_length: .byte 0x09
T: .byte 0x4D 0x61 0x6D 0x00 #0x00 = '\0'
#t_length: .byte 0x03
#L: .byte 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00

#result: index 1 to index 4, length = 4
#S: .byte 0x42 0x41 0x61 0x62 0x39 0x38 0x00 #0x00 = '\0'
##s_length: .byte 0x06
#T: .byte 0x41 0x61 0x62 0x39 0x42 0x38 0x00 #0x00 = '\0'
##t_length: .byte 0x06
#L: .byte 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00

z: .byte 0x00
ret: .byte 0x00
one: .byte 0x01

#L: .byte 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
L: .byte 0x00

 .text                   # Add what follows to the text segment of the program
        #.globl  main            # Declare the label main to be a global one

# $t0 = initial address of S
# $t1 = length of S (m)
# $t2 = initial address of T
# $t3 = length of T (n)
# $t4
# $t5
# $t6 = z # length
# $t7 = i
# $t8 = j
# $t9 = ret #index

# $zero = 0
# $s1
# $s2 = L[i][j]
# $s3
# $s4
# $s5
# $s6 = 1


main:	
	add $zero,$zero,$zero #nop
	
	#$t1 <= t_length
	add $t1,$zero,$zero
	la $t0,S
contLength1:
	lw $t2,0($t0)
	beq $t2,$zero,endLength1
	addi $t0,$t0,1
	addi $t1,$t1,1
	beq $zero,$zero,contLength1
endLength1:
	
	#$t3 <= t_length
	add $t3,$zero,$zero
	la $t0,T
contLength2:
	lw $t2,0($t0)
	beq $t2,$zero,endLength2
	addi $t0,$t0,1
	addi $t3,$t3,1
	beq $zero,$zero,contLength2
endLength2:
	
	la $t0, S
	#la $t1, s_length
	la $t2, T
	#la $t3, t_length
	#lw $t1,0($t1)
	#lw $t3,0($t3)
	la $s5, one
	lw $s6,0($s5)
	add $t6,$zero,$zero
	add $t9,$zero,$zero
	add $t7,$zero,$zero	

outerloop:
	add $t8,$zero,$zero
	
innerloop:

	#t4 = value stored in address S ------- it must be here because I change the value in t4
	#add $t4, $t7, $t7
	#add $t4, $t4, $t4
	#add $t4, $t4, $t0
	add $t4, $t7, $t0
	lw $t4, 0($t4) 
	
	#t5 = value stored in address T
	#add $t5, $t8, $t8
	#add $t5, $t5, $t5
	#add $t5, $t5, $t2
	add $t5, $t8, $t2
    lw $t5, 0($t5) 
    
   
	# $s2 = address of L[i][j]
    
    # START MULTIPLICATION - $s2 = t7 * t3 (i * n)
    add $s4, $zero, $zero
	add $s5, $zero, $t1
	
mult1: 
	beq $s5, $zero, endmult1
	add $s4, $s4, $t7
	sub $s5,$s5,$s6
	beq $zero,$zero, mult1

endmult1:
    add $s2, $zero, $s4
    # FINISH MULTIPLICATION - $s2 = t7 * t3 (i * n)
    
    add $s2, $s2, $t8 # s2 += t8 (+j)
    #add $s2, $s2, $s2
    #add $s2, $s2, $s2 # s2 = s2 * 4
    la $s3,L
    add $s2,$s2,$s3
    #-----------------s2 = address of L[i][j] 
    
    beq $t4,$t5, yep # if (t4==t5) -> yep
    sw $zero,0($s2) #else -> L[i][j] = 0
    
cont:
	add $t8,$t8,$s6 #j++
	#bne $t3,$t8,innerloop # if (j != n)
	beq $t3,$t8, L3
	beq $zero,$zero,innerloop
	
L3:	
	add $t7, $t7, $s6 #i++
	#bne $t1,$t7,outerloop # if (i != m)
	beq $t1,$t7,L4
	beq $zero,$zero,outerloop
	
L4:	
	#jr $ra #THE END
	
	#Organize registers: $t0 <= initial index, $t1 <= final index
	sub $t0,$t9,$t6
	addi $t0,$t0,1
	add $t1, $t9,$zero
	
	add $s1,$zero,$t6
	beq $s1,$zero,end1
	
	add $t2,$zero,$zero
	add $t3,$zero,$zero
	add $t4,$zero,$zero
	add $t5,$zero,$zero
	add $t6,$zero,$zero
	add $t7,$zero,$zero
	add $t8,$zero,$zero
	add $t9,$zero,$zero
	
	la $s0,S
	add $s0,$s0,$t0
	lw $t2,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t3,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t4,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t5,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t6,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t7,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t8,0($s0)
	addi $s1,$s1,-1
	beq $s1,$zero,end1
	
	addi $s0,$s0,1
	lw $t9,0($s0)
	
	beq $zero,$zero,end1

yep: 
	#if (i==0 || j==0) -> equalZero
	beq $t7,$zero,equalZero
	beq $t8,$zero,equalZero 

	# else L[i][j] = L[i-1][j-1] + 1;
	sub $s0, $t7, $s6
	sub $s1, $t8, $s6
	
	#START MULTIPLICATION
    add $t4, $zero, $zero
	add $s5, $zero, $t1
	
mult2: # t7 * t3 (i * n)
	beq $s5, $zero, endmult2
	add $t4, $t4, $s0
	sub $s5, $s5, $s6

	beq $zero,$zero, mult2

endmult2:
	#END MULTIPLICATION
    
    add $t4, $t4, $s1 # t4 += t8 (+j)
    #add $t4,$t4,$t4
    #add $t4,$t4,$t4 # t4 = t4 * 4
    
    la $t5,L
    add $t4,$t4,$t5
    lw $s0,0($t4) # s0 = L[i-1][j-1]
	#add $zero,$zero,$zero #nop
    add $s0, $s0, $s6 # s0++
	
    sw $s0,0($s2) # L[i][j] = L[i-1][j-1] + 1    
    
cont2:
	#if (L[i][j] > z) -> z = L[i][j]; ret = i;
	lw $t5, 0($s2)
	#add $zero,$zero,$zero #nop
	sub $t5, $t5, $t6
	blez $t5, cont3
	
	lw $t6, 0($s2)
	add $t9, $t7, $zero
	
cont3:
    #if (L[i][j] == z) -> ret = i;
	lw $t5, 0($s2)
	#add $zero,$zero,$zero #nop
	#bne $t5,$t6,cont
	beq $t5,$t6,L2
	beq $zero,$zero,cont
	
L2:	
	add $t9, $t7, $zero
	
	beq $zero, $zero, cont #j cont
	
equalZero:
    sw $s6,0($s2) # L[i][j] = 1
    beq $zero, $zero, cont2 #j cont2

end1: 
	add $zero,$zero,$zero
	beq $zero,$zero,end1