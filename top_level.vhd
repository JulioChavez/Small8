-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Top-level Entity

library ieee;
use ieee.std_logic_1164.all;

entity top_level is
	port(
		clk		      : in  std_logic;
		rst           : in  std_logic;
		FPGA_switch	  : in  std_logic_vector(7 downto 0);
		DIP_switch    : in  std_logic_vector(7 downto 0);
		
		seg_led0_hi   : out std_logic_vector(6 downto 0);
		seg_led0_lo   : out std_logic_vector(6 downto 0);
		seg_led1_hi   : out std_logic_vector(6 downto 0);
		seg_led1_lo   : out std_logic_vector(6 downto 0));
end top_level;

architecture STR of top_level is
	constant width : positive := 8;
	signal output0 : std_logic_vector(7 downto 0);
	signal output1 : std_logic_vector(7 downto 0);
	
begin                                   -- STR
	
	U_EXTERNAL_DATAPATH : entity work.external_datapath
		generic map(width => width)
		port map(clk     => clk,
			     rst     => rst,
			     input0  => FPGA_switch,
			     input1  => DIP_switch,
			     output0 => output0,
			     output1 => output1);
	
	U_LED0_HI : entity work.decoder7seg 
	port map(
			input  => output1(7 downto 4),
			output => seg_led0_hi);

	U_LED0_LO : entity work.decoder7seg 
	port map(
			input  => output1(3 downto 0),
			output => seg_led0_lo);
	
	U_LED1_HI : entity work.decoder7seg 
	port map(
			input  => output0(7 downto 4),
			output => seg_led1_hi);

	U_LED1_LO : entity work.decoder7seg 
	port map(
			input  => output0(3 downto 0),
			output => seg_led1_lo);

--	led_dp_n <= '1';

end STR;
