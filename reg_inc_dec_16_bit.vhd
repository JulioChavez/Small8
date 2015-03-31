-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- PC Register with width > 1

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_inc_dec_16_bit is
	generic(
		width : positive := 8);
	port(
		clk         	: in  std_logic;
		rst         	: in  std_logic;
		input       	: in  std_logic_vector(width - 1 downto 0);
		inc      	: in  std_logic;
		dec			: in  std_logic;
		L_load   	: in  std_logic;
		H_load   	: in  std_logic;
		L_output 	: out std_logic_vector(width - 1 downto 0);
		H_output 	: out std_logic_vector(width - 1 downto 0);
		output		: out std_logic_vector(2*width-1 downto 0)
	);
end reg_inc_dec_16_bit;

architecture BHV of reg_inc_dec_16_bit is
begin
	process(clk, rst)
		constant ZERO : std_logic_vector(15 downto 0) := x"0000";
--		constant ONE : std_logic_vector(15 downto 0) := x"0001";
		variable output_var : unsigned((2 * width - 1) downto 0);
	begin
		if (rst = '1') then
			L_output <= (others => '0');
			H_output <= (others => '0');
			output_var := unsigned(ZERO);
			output	<= (others => '0');

		elsif (clk'event and clk = '1') then
		
			-- Load bottom 8-bits of the PC register
			if (L_load = '1') then
				L_output <= input;
				output_var(7 downto 0) := unsigned(input);
				output	<= std_logic_vector(output_var);
				
			-- Load top 8-bits of the PC register
			elsif (H_load = '1') then
				H_output <= input;
				output_var(15 downto 8) := unsigned(input);
				output	<= std_logic_vector(output_var);
			
			-- Increment PC register by 1
			elsif (inc = '1') then
				output_var := output_var + 1;
				L_output <= std_logic_vector(output_var(7 downto 0));
				H_output <= std_logic_vector(output_var(15 downto 8));
				output	<= std_logic_vector(output_var);
			
			-- Decrement PC register by 1
			elsif (dec = '1') then
				output_var := output_var - 1;
				L_output <= std_logic_vector(output_var(7 downto 0));
				H_output <= std_logic_vector(output_var(15 downto 8));
				output	<= std_logic_vector(output_var);
				
			end if;
		end if;
	end process;
end BHV;
