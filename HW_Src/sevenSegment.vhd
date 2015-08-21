library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sevenSegment is
port (      
        numberDesired : in std_logic_vector(3 downto 0);
        sevenSegmentVector : out std_logic_vector(6 downto 0);
		  clock, reset : in std_logic
    );
end sevenSegment;

architecture behavior of sevenSegment is

begin
	process (clock,numberDesired)
	BEGIN
		if (clock'event and clock='1') then
			case  numberDesired is
				when "0000"=> sevenSegmentVector <="0000001";--0
				when "0001"=> sevenSegmentVector <="1001111";--1
				when "0010"=> sevenSegmentVector <="0010010";--2
				when "0011"=> sevenSegmentVector <="0000110";--3
				when "0100"=> sevenSegmentVector <="1001100";--4
				when "0101"=> sevenSegmentVector <="0100100";--5
				when "0110"=> sevenSegmentVector <="0100000";--6
				when "0111"=> sevenSegmentVector <="0001111";--7
				when "1000"=> sevenSegmentVector <="0000000";--8
				when "1001"=> sevenSegmentVector <="0000100";--9
				when "1010"=> sevenSegmentVector <="0001000";--A
				when "1011"=> sevenSegmentVector <="1100000";--b
				when "1100"=> sevenSegmentVector <="0110001";--C
				when "1101"=> sevenSegmentVector <="0000011";--d
				when "1110"=> sevenSegmentVector <="0110000";--E
				when "1111"=> sevenSegmentVector <="0111000";--F
				when others=> sevenSegmentVector <="1111111";--' ' 
			end case;
		end if;
	end process;
end behavior;