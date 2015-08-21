-- Clock_manual(button 0) = PIN_R22
-- CLock_27 = PIN_D12

-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MIPS IS

	PORT( 
		reset, clock_27,clock_manual		: IN 	STD_LOGIC; 
		switch									: IN STD_LOGIC_VECTOR(9 downto 0);
		
		Branch_out, Zero_out, LessThanZeroOut, BranchLessThanZeroOut	: OUT 	STD_LOGIC;
		flush_out,flushP_out															: OUT 	STD_LOGIC;
		resetOut, clockOut															: OUT		STD_LOGIC;
		sevenSegmentVector4Out 														: OUT 	std_logic_vector(27 downto 0));
END 	MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch
   	     PORT(	
			   Instruction			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		PC_plus_4_out 		: OUT  	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				PC_out 				: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				
				correct				: OUT		STD_LOGIC_VECTOR( 15 downto 0);
				wrong				: OUT		STD_LOGIC_VECTOR( 15 downto 0);

				--Branch Signals
        		Branch 				: IN 		STD_LOGIC;
				Zero 					: IN 		STD_LOGIC;				
				BranchLessThanZero: IN 		STD_LOGIC;
				LessThanZero		: IN		STD_LOGIC;   
				
        		Add_result 			: IN 		STD_LOGIC_VECTOR( 7 DOWNTO 0 );				
        		clock,reset 		: IN 		STD_LOGIC );
	END COMPONENT; 
	
	--------------------------------------------------------

	COMPONENT Idecode
 	     PORT(	read_data_1 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data_2 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Sign_extend 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
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
				
				flushP				: IN		STD_LOGIC;	
				
				----------------
				alu_result0			: IN		STD_LOGIC_vector(31 downto 0);
				RegWrite0 			: IN 		STD_LOGIC;
				write_register_addressFromMemory0: IN STD_LOGIC_VECTOR(4 downto 0);
				MemToReg0				: IN 		STD_LOGIC;
				stall					: OUT 	STD_LOGIC;
				---------------
			
				write_register_addressFromMemory: IN STD_LOGIC_VECTOR(4 downto 0);					
        		Instruction 		: IN 		STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		read_data 			: IN 		STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		RegWrite				: IN 		STD_LOGIC;
        		RegDst 				: IN 		STD_LOGIC;        		
        		clock, reset		: IN 		STD_LOGIC );
	END COMPONENT;

	COMPONENT control
	     PORT( 	
             	
             	ALUSrc 				: OUT 	STD_LOGIC;
					ALUop 				: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
					
             	MemtoReg 			: OUT 	STD_LOGIC;
             	MemRead 				: OUT 	STD_LOGIC;
             	MemWrite 			: OUT 	STD_LOGIC;
					
					RegWrite 			: OUT 	STD_LOGIC;
					RegDst 				: OUT 	STD_LOGIC;					
					
					--Branch Signals
             	Branch 				: OUT 	STD_LOGIC;
					BranchLessThanZero: OUT		STD_LOGIC;
					
					
					--flush
					flush					: OUT		STD_LOGIC;
			
					flushP				: IN		STD_LOGIC;	
					Zero					: IN		STD_LOGIC;
					LessThanZero		: IN		STD_LOGIC;
					
					Opcode 				: IN 		STD_LOGIC_VECTOR( 5 DOWNTO 0 );
             	clock, reset		: IN 		STD_LOGIC );
	END COMPONENT;

	COMPONENT  Execute
   	     PORT(	--Branch Signals
						Zero 					: OUT	STD_LOGIC;
						LessThanZero		: OUT STD_LOGIC;
               	ALU_Result 			: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Add_result 			: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			  
						Read_data_1 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
						Read_data_2 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Sign_Extend 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
               	Function_opcode	: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
               	ALUOp 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
               	ALUSrc 				: IN 	STD_LOGIC;
						
						flushP				: IN		STD_LOGIC;	
               	
               	PC_plus_4 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
               	clock, reset		: IN 	STD_LOGIC );
	END COMPONENT;

	--------------------------------------------------------
	
	COMPONENT dmemory
	     PORT(	read_data 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				alu_result	 		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 				: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite,MemToReg : IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;
	
	COMPONENT sevenSegment4
	     PORT(	numberDesired4 : in 	std_logic_vector(15 downto 0);
        sevenSegmentVector4 	: out std_logic_vector(27 downto 0);
		  clock, reset 			: in 	std_logic);
	END COMPONENT;

	---------------- declare signals used to connect VHDL components---------------------
	--Clock
	SIGNAL clock				: STD_LOGIC;
	
	--IFE
	SIGNAL PC					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
	--IFE to IDE
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	--IFE to EXE
	SIGNAL PC_plus_4 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
	
	--IDE
	SIGNAL registerT0			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT1			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT2			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT3			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT4			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT5			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT6			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT7			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT8			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL registerT9			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	--IDE to EXE
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_extend 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	
	--EXE to IFE
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Zero 				: STD_LOGIC;
	SIGNAL LessThanZero		: STD_LOGIC;
	
	--EXE to (IDE and DMEM)
	SIGNAL ALU_result 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	--(IDE) to (EXE and DMEM)
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	
	--DMEM to IDE
	SIGNAL read_data 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	
	
	--CONTROL to IFE
	SIGNAL Branch 				: STD_LOGIC;
	SIGNAL BranchLessThanZero:STD_LOGIC;
	
	--CONTROL to IDE
	SIGNAL RegDst 				: STD_LOGIC;	
	SIGNAL RegWrite 			: STD_LOGIC;
	SIGNAL MemtoReg 			: STD_LOGIC;	
	
	--CONTROL to EXE
	SIGNAL ALUSrc 				: STD_LOGIC;
	SIGNAL ALUop 				: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	
	--CONTROL to DMEM
	SIGNAL MemWrite 			: STD_LOGIC;
	SIGNAL MemRead 			: STD_LOGIC;
	
	
	--sevenSegment4
	SIGNAL sevenSegmentVector4:STD_LOGIC_VECTOR( 27 DOWNTO 0 );
	
	--Our pipe: IF / ID-EX / DMEM / WB
	
		--Pipe between IFE and (IDE-EXE)
		SIGNAL branchP 					: STD_LOGIC;
		SIGNAL ZeroP 						: STD_LOGIC;
		SIGNAL BranchLessThanZeroP 	: STD_LOGIC;
		SIGNAL LessThanZeroP 			: STD_LOGIC;
		SIGNAL Add_resultP				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		SIGNAL InstructionP				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SIGNAL PC_plus_4_outP 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		
		--Pipe between (IDE-EXE-CONTROL) and (DMEM)
		SIGNAL ALU_resultP				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SIGNAL read_data_2P 				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SIGNAL MemWriteP 					: STD_LOGIC;
		SIGNAL MemReadP 					: STD_LOGIC;
		SIGNAL MemToRegP 					: STD_LOGIC;
		SIGNAL RegWriteP 					: STD_LOGIC;
		SIGNAL write_register_addressP: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		SIGNAL write_register_address : STD_LOGIC_VECTOR(4 downto 0);
		
		--Pipe between (DMEM) and (WB)
		SIGNAL read_dataP 					: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SIGNAL RegWritePP 					: STD_LOGIC;
		SIGNAL write_register_addressPP	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		
		--flush
		SIGNAL flush	: STD_LOGIC;
		SIGNAL flushP	: STD_LOGIC;
		
		--stall
		SIGNAL stall	: STD_LOGIC;
		
		--Branch Prediction Accuracy (static always not-taken)
		SIGNAL correct	:	STD_LOGIC_VECTOR(15 downto 0);
		SIGNAL wrong	:	STD_LOGIC_VECTOR(15 downto 0);
		
	--End of Our pipe: IF / ID-EX / DMEM / WB
	
	--Number to display on the 7-segment display
	SIGNAL numberDesiredToDisplay		: STD_LOGIC_VECTOR(15 downto 0);
	
BEGIN	
	process
	BEGIN
		WAIT UNTIL falling_edge(clock);--clock'EVENT AND clock = '0';
			--if(reset='1') then
			if(reset='0') then
				branchP <= '0';
				ZeroP <= '0';
				BranchLessThanZeroP <= '0';
				LessThanZeroP <= '0';
				Add_resultP <= "00000000";
				InstructionP <= "00000000000000000000000000000000";
				PC_plus_4_outP <= "0000000000";
				--------------
				ALU_resultP	<= "00000000000000000000000000000000";
				read_data_2P 	<= "00000000000000000000000000000000";
				
				MemWriteP <= '0'; 		
				MemReadP <= '0'; 		
				MemToRegP <= '0';
				RegWriteP <= '0';
				write_register_addressP <= "00000";
				--------------
				read_dataP 	<= "00000000000000000000000000000000";
				RegWritePP <= '0';
				write_register_addressPP <= "00000";
				--------------
				flushP <= '0';
				
			elsif (stall='1') then
				branchP <= '1';
				ZeroP <= '1';
				BranchLessThanZeroP <= '0';
				LessThanZeroP <= '0';
				Add_resultP <= PC(9 downto 2);
				--InstructionP <=  "00000000000000000000000000000000";
				--PC_plus_4_outP <= "0000000000";
				--------------------
				
				----------------------
				read_dataP 	<=  read_data;
				RegWritePP <= RegWriteP;
				write_register_addressPP <= write_register_addressP;
				----------------------
				
				--------------------
				ALU_resultP	<=  "00000000000000000000000000000000";
				read_data_2P 	<=  "00000000000000000000000000000000";
				MemWriteP <= '0'; 		
				MemReadP <= '0'; 	
				MemToRegP <= '0';				
				RegWriteP <= '0';
				write_register_addressP <= "00000";
				flushP <= '0';
			
			else
				branchP <= branch;
				ZeroP <= Zero;
				BranchLessThanZeroP <= BranchLessThanZero;
				LessThanZeroP <= LessThanZero;
				Add_resultP <= Add_result;
				InstructionP <= Instruction;
				PC_plus_4_outP <= PC_plus_4;
				--------------------
				
				----------------------
				read_dataP 	<= read_data;
				RegWritePP <= RegWriteP;
				write_register_addressPP <= write_register_addressP;
				----------------------
				
				--------------------
				ALU_resultP	<= ALU_result;
				read_data_2P 	<= read_data_2;
				MemWriteP <= MemWrite; 		
				MemReadP <= MemRead; 	
				MemToRegP <= MemToReg;				
				RegWriteP <= RegWrite;
				write_register_addressP <= write_register_address;
				flushP <= flush;
				
			end if;
	end process;
	
	process (clock_27,clock_manual,switch,registerT0,registerT1,registerT2,registerT3,registerT4,registerT5,registerT6,registerT7,registerT8,registerT9,PC,Alu_Result,correct,wrong)
	begin
		if(switch(8)='1') then
			clock <= clock_manual;
		else
			clock <= clock_27;
		end if;
		if(switch(9)='1') then
			if(switch(7 downto 0)=X"00") then
				numberDesiredToDisplay <= registerT0(15 downto 0);
			elsif (switch(7 downto 0)=X"01") then
				numberDesiredToDisplay <= registerT1(15 downto 0);
			elsif (switch(7 downto 0)=X"02") then
				numberDesiredToDisplay <= registerT2(15 downto 0);
			elsif (switch(7 downto 0)=X"03") then
				numberDesiredToDisplay <= registerT3(15 downto 0);
			elsif (switch(7 downto 0)=X"04") then
				numberDesiredToDisplay <= registerT4(15 downto 0);
			elsif (switch(7 downto 0)=X"05") then
				numberDesiredToDisplay <= registerT5(15 downto 0);
			elsif (switch(7 downto 0)=X"06") then
				numberDesiredToDisplay <= registerT6(15 downto 0);
			elsif (switch(7 downto 0)=X"07") then
				numberDesiredToDisplay <= registerT7(15 downto 0);
			elsif (switch(7 downto 0)=X"08") then
				numberDesiredToDisplay <= registerT8(15 downto 0);
			elsif (switch(7 downto 0)=X"09") then
				numberDesiredToDisplay <= registerT9(15 downto 0);
			elsif (switch(7 downto 0)=X"50") then
				numberDesiredToDisplay <= "000000" & PC;
			elsif (switch(7 downto 0)=X"40") then
				numberDesiredToDisplay <= Alu_Result(15 downto 0);
			elsif (switch(7 downto 0)=X"20") then
				numberDesiredToDisplay <= correct(15 downto 0);
			elsif (switch(7 downto 0)=X"30") then
				numberDesiredToDisplay <= wrong(15 downto 0);
			else
				numberDesiredToDisplay <= X"0000";
			end if;
		else
			numberDesiredToDisplay <= (registerT0(7 downto 0) & registerT1(7 downto 0));
		end if;
	end process;
	
	-- copy important signals to output pins for easy display in Simulator		
   Branch_out 					<= Branch;
	BranchLessThanZeroOut 	<= BranchLessThanZero;
   Zero_out 					<= Zero;
	LessThanZeroOut			<=	LessThanZero;
	
	ResetOut 					<= Reset;
	clockOut						<= clock;
	
	sevenSegmentVector4Out 	<= sevenSegmentVector4;	
	
	flush_out					<= flush;
	flushP_out					<= flushP;
	
	-- connect the 5 MIPS components 
  IFE : Ifetch
	PORT MAP (	Instruction 	=> Instruction,
    	    	PC_plus_4_out 		=> PC_plus_4,
				
				Add_result 			=> Add_resultP,
				
				--Branch Signals
				Branch 				=> branchP,
				Zero 					=> ZeroP,
				BranchLessThanZero=> BranchLessThanZeroP,
				LessThanZero		=> LessThanZeroP,
				
				correct				=> correct,
				wrong					=> wrong,
				
				PC_out 				=> PC,
				clock 				=> clock,
				reset 				=> not reset );
				

   ID : Idecode
   	PORT MAP (	
				read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> InstructionP,
        		read_data 		=> read_dataP,
				
				flushP				=> flushP,
				
				RegWrite 		=> RegWritePP,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
				registerT0		=> registerT0,
				registerT1		=> registerT1,
				registerT2		=> registerT2,
				registerT3		=> registerT3,
				registerT4		=> registerT4,
				registerT5		=> registerT5,
				registerT6		=> registerT6,
				registerT7		=> registerT7,
				registerT8		=> registerT8,
				registerT9		=> registerT9,
				write_register_addressToMemory => write_register_address,		
				write_register_addressFromMemory => write_register_addressPP,	
				
				------------------Forward DMEM to ID
				alu_result0		=> Alu_resultP,
				RegWrite0 		=> RegWriteP,
				write_register_addressFromMemory0 => write_register_addressP,	
				MemToReg0			=> MemToRegP,
				stall => stall,
				------------------
				
				clock 			=>clock,
				reset 			=> not reset );


   CTL:   control
	PORT MAP ( 	Opcode 			=> InstructionP( 31 DOWNTO 26 ),
				RegDst 				=> RegDst,
				ALUSrc 				=> ALUSrc,
				MemToReg 			=> MemToReg,
				RegWrite 			=> RegWrite,
				MemRead 				=> MemRead,
				MemWrite 			=> MemWrite,
				
				--Branch Signals
				Branch 				=> Branch,
				BranchLessThanZero=> BranchLessThanZero,
				
				
				
				--flush
				flush					=> flush,
			
				flushP				=> flushP,
				Zero					=> Zero,
				LessThanZero		=> LessThanZero,
				
				ALUop 				=> ALUop,
				clock 				=> clock,
				reset 				=> not reset );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
            read_data_2 			=> read_data_2,
				Sign_extend 			=> Sign_extend,
            Function_opcode		=> InstructionP( 5 DOWNTO 0 ),
				ALUOp 					=> ALUop,
				ALUSrc 					=> ALUSrc,
				
				--Branch Signals
				Zero 						=> Zero,
				LessThanZero			=> LessThanZero,
				
				flushP				=> flushP,
				
            ALU_result				=> ALU_result,
				Add_result 				=> Add_result,
				PC_plus_4				=> PC_plus_4_outP,
				clock 				=> clock,
				Reset						=> not reset );

   MEM:  dmemory
	PORT MAP (	read_data 	=> read_data,
				address 			=> ALU_resultP (7 DOWNTO 0),
				alu_result		=> ALU_resultP,
				write_data 		=> read_data_2P,
				MemRead 			=> MemReadP, 
				Memwrite 		=> MemWriteP, 
				MemToReg			=> MemToRegP,
				
				clock 				=> clock,				
				reset 			=> not reset );
				
	SEV4:  sevenSegment4
	PORT MAP (	
				numberDesired4 		=> numberDesiredToDisplay,
				sevenSegmentVector4 	=> sevenSegmentVector4,
				clock 				=> clock,
				reset 					=> reset );
END structure;

