-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 				: IN 		STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	
	flush					: OUT		STD_LOGIC;
			
	flushP				: IN		STD_LOGIC;	
	Zero					: IN		STD_LOGIC;
	LessThanZero		: IN		STD_LOGIC;
	
	RegDst 				: OUT 	STD_LOGIC;
	ALUSrc 				: OUT 	STD_LOGIC;
	MemtoReg 			: OUT 	STD_LOGIC;
	RegWrite 			: OUT 	STD_LOGIC;
	MemRead 				: OUT 	STD_LOGIC;
	MemWrite 			: OUT 	STD_LOGIC;
	Branch 				: OUT 	STD_LOGIC;
	BranchLessThanZero: OUT		STD_LOGIC;
	ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	clock, reset		: IN 		STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw, Beq, Blt, Addi 	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format				<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw						<=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw						<=  '1'  WHEN  Opcode = "101011"  ELSE '0';
   Beq					<=  '1'  WHEN  Opcode = "000100"  ELSE '0';	
	Blt					<=	 '1' 	WHEN 	Opcode = "000110"	 ELSE '0';
	Addi					<=  '1' 	WHEN	Opcode = "001000"  ELSE '0';
	
  	RegDst    	<=  R_format ;--OR Addi;
 	ALUSrc  		<=  Lw OR Sw  OR Addi;
	MemtoReg 	<=  Lw when flushP = '0' else '0';
  	RegWrite 	<=  (R_format OR Lw  OR Addi) when flushP = '0' else '0';
  	MemRead 		<=  Lw when flushP = '0' else '0';
   MemWrite 	<=  Sw when flushP = '0' else '0';
 	Branch      <=  Beq when flushP = '0' else '0';
	BranchLessThanZero <= Blt when flushP = '0' else '0';
	ALUOp( 1 ) 	<=  R_format;
	ALUOp( 0 ) 	<=  Beq OR Blt; --Backup: ALUOp( 0 ) 	<=  Beq ; 
	
	flush <= '1' when (flushP='0') AND (( (( Beq = '1' ) AND ( Zero = '1' )) OR (( BLt = '1' ) AND ( LessThanZero = '1' ))))
		else '0';

END behavior;


