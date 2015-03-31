-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- 1-Bit Register

library ieee;
use ieee.std_logic_1164.all;

entity reg_1_bit is
	port(
		clk    : in  std_logic;
		rst    : in  std_logic;
		set    : in  std_logic;
		load   : in  std_logic;
		input  : in  std_logic;
		output : out std_logic);
end reg_1_bit;

architecture BHV of reg_1_bit is
begin
	process(clk, rst)
	begin
		if (rst = '1') then
			output <= '0';
		elsif (set = '1') then
			output <= '1';
		elsif (clk'event and clk = '1') then
			if (load = '1') then
				output <= input;
			end if;
		end if;
	end process;
end BHV;
