-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity opcode_fetch_tb is
end opcode_fetch_tb;

architecture TB of opcode_fetch_tb is

	constant WIDTH     : positive := 8;
	signal clk : std_logic;
	signal rst : std_logic;
	signal input0 : std_logic_vector(width-1 downto 0);
	signal input1 : std_logic_vector(width-1 downto 0);
	signal output0 : std_logic_vector(width-1 downto 0);
	signal output1 : std_logic_vector(width-1 downto 0);

begin                                   -- TB

	U_EXTERNAL_DATA_PATH : entity work.external_datapath
		generic map(width => width)
		port map(clk     => clk,
			     rst     => rst,
			     input0  => input0,
			     input1  => input1,
			     output0 => output0,
			     output1 => output1);

	process
	begin
	
		rst <= '1';
		input0 <= x"30";
		input1 <= x"1F";

		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';

		rst <= '0';
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		
--		for i in 0 to 50 loop
--			clk <= '0';
--			wait for 10 ns;
--			clk <= '1';
--			wait for 10 ns;
--			clk <= '0';
--		end loop;
--		
--		rst <= '1';
--
--		clk <= '0';
--		wait for 10 ns;
--		clk <= '1';
--		wait for 10 ns;
--		clk <= '0';
--
--		rst <= '0';
--		
--		clk <= '0';
--		wait for 10 ns;
--		clk <= '1';
--		wait for 10 ns;
--		clk <= '0';
		
		for i in 0 to 2000 loop
			clk <= '0';
			wait for 10 ns;
			clk <= '1';
			wait for 10 ns;
			clk <= '0';
		end loop;

		wait;

	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	end process;
end TB;