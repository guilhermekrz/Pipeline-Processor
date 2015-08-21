library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sevenSegment4 is
port (      
		sevenSegmentVector4 : OUT std_logic_vector(27 downto 0);
        
		numberDesired4 : IN std_logic_vector(15 downto 0);        
		clock, reset 	: IN std_logic );
end sevenSegment4;

architecture behavior of sevenSegment4 is

begin
	process (clock,numberDesired4)
	BEGIN
		if (clock'event and clock='1') then
			case  numberDesired4 (3 downto 0) is
				when "0000"=> sevenSegmentVector4 (6 downto 0) <="0000001";--0
				when "0001"=> sevenSegmentVector4 (6 downto 0) <="1001111";--1
				when "0010"=> sevenSegmentVector4 (6 downto 0) <="0010010";--2
				when "0011"=> sevenSegmentVector4 (6 downto 0) <="0000110";--3
				when "0100"=> sevenSegmentVector4 (6 downto 0) <="1001100";--4
				when "0101"=> sevenSegmentVector4 (6 downto 0) <="0100100";--5
				when "0110"=> sevenSegmentVector4 (6 downto 0) <="0100000";--6
				when "0111"=> sevenSegmentVector4 (6 downto 0) <="0001111";--7
				when "1000"=> sevenSegmentVector4 (6 downto 0) <="0000000";--8
				when "1001"=> sevenSegmentVector4 (6 downto 0) <="0000100";--9
				when "1010"=> sevenSegmentVector4 (6 downto 0) <="0001000";--A
				when "1011"=> sevenSegmentVector4 (6 downto 0) <="1100000";--b
				when "1100"=> sevenSegmentVector4 (6 downto 0) <="0110001";--C
				when "1101"=> sevenSegmentVector4 (6 downto 0) <="1000010";--d
				when "1110"=> sevenSegmentVector4 (6 downto 0) <="0110000";--E
				when "1111"=> sevenSegmentVector4 (6 downto 0) <="0111000";--F
				when others=> sevenSegmentVector4 (6 downto 0) <="1111111";--' ' 
			end case;
			
			case  numberDesired4 (7 downto 4) is
				when "0000"=> sevenSegmentVector4 (13 downto 7) <="0000001";--0
				when "0001"=> sevenSegmentVector4 (13 downto 7) <="1001111";--1
				when "0010"=> sevenSegmentVector4 (13 downto 7) <="0010010";--2
				when "0011"=> sevenSegmentVector4 (13 downto 7) <="0000110";--3
				when "0100"=> sevenSegmentVector4 (13 downto 7) <="1001100";--4
				when "0101"=> sevenSegmentVector4 (13 downto 7) <="0100100";--5
				when "0110"=> sevenSegmentVector4 (13 downto 7) <="0100000";--6
				when "0111"=> sevenSegmentVector4 (13 downto 7) <="0001111";--7
				when "1000"=> sevenSegmentVector4 (13 downto 7) <="0000000";--8
				when "1001"=> sevenSegmentVector4 (13 downto 7) <="0000100";--9
				when "1010"=> sevenSegmentVector4 (13 downto 7) <="0001000";--A
				when "1011"=> sevenSegmentVector4 (13 downto 7) <="1100000";--b
				when "1100"=> sevenSegmentVector4 (13 downto 7) <="0110001";--C
				when "1101"=> sevenSegmentVector4 (13 downto 7) <="1000010";--d
				when "1110"=> sevenSegmentVector4 (13 downto 7) <="0110000";--E
				when "1111"=> sevenSegmentVector4 (13 downto 7) <="0111000";--F
				when others=> sevenSegmentVector4 (13 downto 7) <="1111111";--' ' 
			end case;
			
			case  numberDesired4 (11 downto 8) is
				when "0000"=> sevenSegmentVector4 (20 downto 14) <="0000001";--0
				when "0001"=> sevenSegmentVector4 (20 downto 14) <="1001111";--1
				when "0010"=> sevenSegmentVector4 (20 downto 14) <="0010010";--2
				when "0011"=> sevenSegmentVector4 (20 downto 14) <="0000110";--3
				when "0100"=> sevenSegmentVector4 (20 downto 14) <="1001100";--4
				when "0101"=> sevenSegmentVector4 (20 downto 14) <="0100100";--5
				when "0110"=> sevenSegmentVector4 (20 downto 14) <="0100000";--6
				when "0111"=> sevenSegmentVector4 (20 downto 14) <="0001111";--7
				when "1000"=> sevenSegmentVector4 (20 downto 14) <="0000000";--8
				when "1001"=> sevenSegmentVector4 (20 downto 14) <="0000100";--9
				when "1010"=> sevenSegmentVector4 (20 downto 14) <="0001000";--A
				when "1011"=> sevenSegmentVector4 (20 downto 14) <="1100000";--b
				when "1100"=> sevenSegmentVector4 (20 downto 14) <="0110001";--C
				when "1101"=> sevenSegmentVector4 (20 downto 14) <="1000010";--d
				when "1110"=> sevenSegmentVector4 (20 downto 14) <="0110000";--E
				when "1111"=> sevenSegmentVector4 (20 downto 14) <="0111000";--F
				when others=> sevenSegmentVector4 (20 downto 14) <="1111111";--' ' 
			end case;
			
			case  numberDesired4 (15 downto 12) is
				when "0000"=> sevenSegmentVector4 (27 downto 21) <="0000001";--0
				when "0001"=> sevenSegmentVector4 (27 downto 21) <="1001111";--1
				when "0010"=> sevenSegmentVector4 (27 downto 21) <="0010010";--2
				when "0011"=> sevenSegmentVector4 (27 downto 21) <="0000110";--3
				when "0100"=> sevenSegmentVector4 (27 downto 21) <="1001100";--4
				when "0101"=> sevenSegmentVector4 (27 downto 21) <="0100100";--5
				when "0110"=> sevenSegmentVector4 (27 downto 21) <="0100000";--6
				when "0111"=> sevenSegmentVector4 (27 downto 21) <="0001111";--7
				when "1000"=> sevenSegmentVector4 (27 downto 21) <="0000000";--8
				when "1001"=> sevenSegmentVector4 (27 downto 21) <="0000100";--9
				when "1010"=> sevenSegmentVector4 (27 downto 21) <="0001000";--A
				when "1011"=> sevenSegmentVector4 (27 downto 21) <="1100000";--b
				when "1100"=> sevenSegmentVector4 (27 downto 21) <="0110001";--C
				when "1101"=> sevenSegmentVector4 (27 downto 21) <="1000010";--d
				when "1110"=> sevenSegmentVector4 (27 downto 21) <="0110000";--E
				when "1111"=> sevenSegmentVector4 (27 downto 21) <="0111000";--F
				when others=> sevenSegmentVector4 (27 downto 21) <="1111111";--' ' 
			end case;
		end if;
	end process;
end behavior;