-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Register with width > 1

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_inc_dec is
  generic (
    width  :     positive := 8);
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    load   : in  std_logic;
    inc	   : in  std_logic;
    dec	   : in  std_logic;
    input  : in  std_logic_vector(width-1 downto 0);
    output : out std_logic_vector(width-1 downto 0));
end reg_inc_dec;


architecture BHV of reg_inc_dec is
begin
	process(clk, rst)
		variable temp : unsigned((width-1) downto 0);
	begin
		if (rst = '1') then
			temp := (others => '0');
			output <= (others => '0');
		elsif (clk'event and clk = '1') then
			if (load = '1') then
				temp := unsigned(input);
				output <= input;
			elsif(inc = '1') then
				temp := temp + 1;
				output <= std_logic_vector(temp);
			elsif(dec = '1') then
				temp := temp - 1;
				output <= std_logic_vector(temp);
			end if;
		end if;
	end process;
end BHV;
