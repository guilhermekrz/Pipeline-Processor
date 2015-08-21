						--  Idecode module (implements the register file for
LIBRARY IEEE; 			-- the MIPS computer)
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(read_data_1: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			
			-----Registers output-------------------------------
			registerT0  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT1  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT2  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT3  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT4  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT5  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT6  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT7  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT8  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			registerT9  : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );			
			------------------------------------------------------
			write_register_addressToMemory : OUT STD_LOGIC_VECTOR(4 downto 0);
			
			--flush
			flushP				: IN		STD_LOGIC;
			
			--stall
			stall		: OUT std_LOGIC;
			
			----------------
			alu_result0			: IN		STD_LOGIC_vector(31 downto 0);
			RegWrite0 			: IN 		STD_LOGIC;
			write_register_addressFromMemory0: IN STD_LOGIC_VECTOR(4 downto 0);
			MemToReg0				: IN 		STD_LOGIC;
			---------------
			
			write_register_addressFromMemory: IN STD_LOGIC_VECTOR(4 downto 0);			
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			--ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC;			
			clock,reset	: IN 	STD_LOGIC );
END Idecode;


ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	--SIGNAL write_data					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_1		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_register_address_0		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL Instruction_immediate_value	: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	
	SIGNAL aux		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL aux2,aux3		: STD_LOGIC_VECTOR (31 downto 0);

BEGIN
		read_register_1_address 	<= Instruction( 25 DOWNTO 21 ); --$t0
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 ); --$t0
   	write_register_address_1	<= Instruction( 15 DOWNTO 11 ); --$zero
   	write_register_address_0 	<= Instruction( 20 DOWNTO 16 ); --$t0
   	Instruction_immediate_value <= Instruction( 15 DOWNTO 0 ); --0
		
		--Hazard detection unit: check if the destination register of the previous intruction (write_register_addressFromMemory) is equal
		--to the  source registers of the current instruction
		--if (memtoReg='1') -> stall one cycle
		stall <= '1' WHEN (MemToReg0 = '1' AND RegWrite0 = '1'  AND write_register_addressFromMemory0 /= 0 AND (CONV_INTEGER(read_register_1_address) = CONV_INTEGER(write_register_addressFromMemory0)))
									OR (MemToReg0 = '1' AND RegWrite0 = '1'  AND write_register_addressFromMemory0 /= 0 AND (CONV_INTEGER(read_register_2_address) = CONV_INTEGER(write_register_addressFromMemory0)))
						ELSE '0';
		
		aux2 <= read_data WHEN (RegWrite = '1'  AND write_register_addressFromMemory /= 0 AND (CONV_INTEGER(read_register_1_address) = CONV_INTEGER(write_register_addressFromMemory)))
							ELSE register_array( CONV_INTEGER( read_register_1_address ) );
		read_data_1  <= alu_result0 WHEN (RegWrite0 = '1'  AND write_register_addressFromMemory0 /= 0 AND (CONV_INTEGER(read_register_1_address) = CONV_INTEGER(write_register_addressFromMemory0)))
							ELSE aux2;
		
		aux3 <= read_data WHEN (RegWrite = '1'  AND write_register_addressFromMemory /= 0 AND (CONV_INTEGER(read_register_2_address) = CONV_INTEGER(write_register_addressFromMemory)))
							ELSE register_array( CONV_INTEGER( read_register_2_address ) );
		read_data_2 <= alu_result0 WHEN (RegWrite0 = '1'  AND write_register_addressFromMemory0 /= 0 AND (CONV_INTEGER(read_register_2_address) = CONV_INTEGER(write_register_addressFromMemory0)))
							ELSE aux3;
							
							
		--read_data_1 <= aux2;
		--read_data_2 <= aux3;
		
		-- Read Register 1 Operation
		--read_data_1 <= register_array( CONV_INTEGER( read_register_1_address ) );
		
		-- Read Register 2 Operation		 
		--read_data_2 <= register_array( CONV_INTEGER( read_register_2_address ) );
		
		--Output the register T1 and T2
		--registerT1 <= register_array(8);
		--registerT2 <= register_array(9);
		registerT0 <= register_array(8);
		registerT1 <= register_array(9);
		registerT2 <= register_array(10);
		registerT3 <= register_array(11);
		registerT4 <= register_array(12);
		registerT5 <= register_array(13);
		registerT6 <= register_array(14);
		registerT7 <= register_array(15);
		registerT8 <= register_array(24);
		registerT9 <= register_array(25);
		--$t0 = 8 = initial index
		--$t1 = 9 = final index
		--$t2 = 10
		--$t3 = 11
		--$t4 = 12
		--$t5 = 13
		--$t6 = 14 = index (ret) = 3
		--$t7 = 15
		--$t8 = 24
		--$t9 = 25 = length (z) = 6
					
		-- Mux for Register Write Address
		aux <= write_register_address_1 WHEN RegDst = '1'
											ELSE write_register_address_0;
		write_register_addressToMemory <=aux WHEN flushP='0' --$t0
											ELSE "00000";
		
		--write_register_addressToMemory <=write_register_address_1 WHEN RegDst = '1'
		--									ELSE write_register_address_0;
		
		-- Mux to bypass data memory for Rformat instructions
		--write_data <= ALU_result( 31 DOWNTO 0 ) WHEN ( MemtoReg = '0' ) 	
		--					ELSE read_data;
							
		--write_data <= read_data;
					
		-- Sign Extend 16-bits to 32-bits
    	Sign_extend <= X"0000" & Instruction_immediate_value	WHEN Instruction_immediate_value(15) = '0'
							ELSE	X"FFFF" & Instruction_immediate_value;

--PROCESS 
PROCESS (clock,reset)
	BEGIN
		
		----Previous version----------
		--WAIT UNTIL clock'EVENT AND clock = '1';
		--
		--IF reset = '1' THEN
		--	-- Initial register values on reset are register = (reg#). Use loop to automatically generate reset logic for all registers
		--	FOR i IN 0 TO 31 LOOP
		--		register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
 		--	END LOOP;
		--	
		-- Write back to register - don't write to register 0
  		--ELSIF RegWrite = '1' AND write_register_addressFromMemory /= 0 THEN
		--      register_array( CONV_INTEGER( write_register_addressFromMemory)) <= read_data;
		--END IF;
		-----------------------------------
		IF reset = '1' THEN
			FOR i IN 0 TO 31 LOOP
				register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
			END LOOP;
			--aux2 <= "00000000000000000000000000000000";
			--aux3 <= "00000000000000000000000000000000";
		elsif (clock'event and clock = '1') then
			IF RegWrite = '1' AND write_register_addressFromMemory /= 0 THEN
		      register_array( CONV_INTEGER( write_register_addressFromMemory)) <= read_data;
			end if;
			
			--if(flushP='0' AND RegWrite = '1'  AND write_register_addressFromMemory /= 0 AND (CONV_INTEGER(read_register_1_address) = CONV_INTEGER(write_register_addressFromMemory))) then
			--	aux2 <= read_data;
			--else
			--	aux2 <= register_array( CONV_INTEGER( read_register_1_address ) );
			--end if;
			
			-- if(flushP='0' AND RegWrite = '1'  AND write_register_addressFromMemory /= 0 AND (CONV_INTEGER(read_register_2_address) = CONV_INTEGER(write_register_addressFromMemory))) then
			--	aux3 <= read_data;
			--else
			--	aux3 <= register_array( CONV_INTEGER( read_register_2_address ) );
			--end if;
		elsif (clock'event and clock = '0') then
			
		end if;		
	END PROCESS;
END behavior;




