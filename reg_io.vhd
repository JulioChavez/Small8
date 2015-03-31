-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Register with width > 1

library ieee;
use ieee.std_logic_1164.all;

entity reg_io is
	generic(
		width : positive := 8);
	port(
		clk         : in  std_logic;
		rst         : in  std_logic;
		load		: in  std_logic_vector(1 downto 0);
		input       : in  std_logic_vector(width - 1 downto 0);
		data		: in  std_logic_vector(width - 1 downto 0); 
		output 	: out std_logic_vector(width - 1 downto 0)
		);
end reg_io;

architecture BHV of reg_io is
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			output <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (load = "10") then
				output <= input;
			elsif (load = "01") then	
				output <= data;
			end if;
		end if;
	end process;
end BHV;
