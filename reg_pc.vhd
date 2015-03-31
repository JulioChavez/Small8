-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- PC Register with width > 1

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_pc is
	generic(
		width : positive := 8);
	port(
		clk         	: in  std_logic;
		rst         	: in  std_logic;
		input       	: in  std_logic_vector(width - 1 downto 0);
		address_bus		: in  std_logic_vector(2*width-1 downto 0);
		PC_inc      	: in  std_logic;
		PC_L_load   	: in  std_logic;
		PC_H_load   	: in  std_logic;
		PC_addr_load	: in  std_logic;
		PC_L_output 	: out std_logic_vector(width - 1 downto 0);
		PC_H_output 	: out std_logic_vector(width - 1 downto 0);
		PC_output		: out std_logic_vector(2*width-1 downto 0)
	);
end reg_pc;

library ieee;
architecture BHV of reg_pc is
begin
	process(clk, rst)
		constant ZERO : std_logic_vector(15 downto 0) := x"0000";
		variable PC_output_var : unsigned((2 * width - 1) downto 0);
	begin
		if (rst = '1') then
			PC_L_output <= (others => '0');
			PC_H_output <= (others => '0');
			PC_output_var := unsigned(ZERO);
			PC_output	<= (others => '0');

		elsif (clk'event and clk = '1') then
		
			-- Load bottom 8-bits of the PC register
			if (PC_addr_load = '1') then
				PC_output_var := unsigned(address_bus);
				PC_L_output <= address_bus(7 downto 0);
				PC_H_output <= address_bus(15 downto 8);
				PC_output	<= address_bus;
			elsif (PC_L_load = '1') then
				PC_L_output <= input;
				PC_output_var(7 downto 0) := unsigned(input);
				PC_output	<= std_logic_vector(PC_output_var);
				
			-- Load top 8-bits of the PC register
			elsif (PC_H_load = '1') then
				PC_H_output <= input;
				PC_output_var(15 downto 8) := unsigned(input);
				PC_output	<= std_logic_vector(PC_output_var);
			
			-- Increment PC register by 1
			elsif (PC_inc = '1') then
				PC_output_var := PC_output_var + 1;
				PC_L_output <= std_logic_vector(PC_output_var(7 downto 0));
				PC_H_output <= std_logic_vector(PC_output_var(15 downto 8));
				PC_output	<= std_logic_vector(PC_output_var);
				
			end if;
		end if;
	end process;
end BHV;
