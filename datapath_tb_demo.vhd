-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Internal Architecture Data Path

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_tb is
end datapath_tb;

architecture TB of datapath_tb is

	component datapath
		generic(width : positive := 8);
		port(clk              : in  std_logic;
			 rst              : in  std_logic;
			 external_bus_in  : in  std_logic_vector(width - 1 downto 0);
			 external_bus_out : out std_logic_vector(width - 1 downto 0);
			 address_bus      : out std_logic_vector(2 * width - 1 downto 0);
			 C                : out std_logic;
			 V                : out std_logic;
			 S                : out std_logic;
			 Z                : out std_logic;
			 Read             : in  std_logic;
			 Write            : in  std_logic;
			 AR_H_en          : in  std_logic;
			 AR_L_en          : in  std_logic;
			 IR_en            : in  std_logic;
			 PC_H_en          : in  std_logic;
			 PC_L_en          : in  std_logic;
			 D_en             : in  std_logic;
			 A_en             : in  std_logic;
			 SP_H_en          : in  std_logic;
			 SP_L_en          : in  std_logic;
			 X_H_en           : in  std_logic;
			 X_L_en           : in  std_logic;
			 C_en             : in  std_logic;
			 V_en             : in  std_logic;
			 S_en             : in  std_logic;
			 Z_en             : in  std_logic;
			 ALU_en           : in  std_logic;
			 sel_alu          : in  std_logic_vector(3 downto 0));
	end component datapath;

	signal	width			 : positive := 8;
	signal	clk              : std_logic;
	signal	rst              : std_logic;
	signal	external_bus_in  : std_logic_vector(width - 1 downto 0);
	signal	external_bus_out : std_logic_vector(width - 1 downto 0);
	signal	address_bus      : std_logic_vector(2 * width - 1 downto 0);
	signal	C                : std_logic;
	signal	V                : std_logic;
	signal	S                : std_logic;
	signal	Z                : std_logic;
	signal	Read             : std_logic;
	signal	Write            : std_logic;
	signal	AR_H_en          : std_logic;
	signal	AR_L_en          : std_logic;
	signal	IR_en            : std_logic;
	signal	PC_H_en          : std_logic;
	signal	PC_L_en          : std_logic;
	signal	D_en             : std_logic;
	signal	A_en             : std_logic;
	signal	SP_H_en          : std_logic;
	signal	SP_L_en          : std_logic;
	signal	X_H_en           : std_logic;
	signal	X_L_en           : std_logic;
	signal	C_en             : std_logic;
	signal	V_en             : std_logic;
	signal	S_en             : std_logic;
	signal	Z_en             : std_logic;
	signal	ALU_en           : std_logic;
	signal	sel_alu          : std_logic_vector(3 downto 0);
	
begin
	
	UUT	: component datapath
		generic map(width => width)
		port map(clk              => clk,
			     rst              => rst,
			     external_bus_in  => external_bus_in,
			     external_bus_out => external_bus_out,
			     address_bus      => address_bus,
			     C                => C,
			     V                => V,
			     S                => S,
			     Z                => Z,
			     Read             => Read,
			     Write            => Write,
			     AR_H_en          => AR_H_en,
			     AR_L_en          => AR_L_en,
			     IR_en            => IR_en,
			     PC_H_en          => PC_H_en,
			     PC_L_en          => PC_L_en,
			     D_en             => D_en,
			     A_en             => A_en,
			     SP_H_en          => SP_H_en,
			     SP_L_en          => SP_L_en,
			     X_H_en           => X_H_en,
			     X_L_en           => X_L_en,
			     C_en             => C_en,
			     V_en             => V_en,
			     S_en             => S_en,
			     Z_en             => Z_en,
			     ALU_en           => ALU_en,
			     sel_alu          => sel_alu);
	
	
	process
  	begin
	  	
		rst 	<= '1';		-- Reset all of the registers
	  	clk 	<= '0';
	  	Read    <= '0';
		Write   <= '0';
		AR_H_en <= '0';
		AR_L_en <= '0';
		IR_en   <= '0';
		PC_H_en <= '0';
		PC_L_en <= '0';
		D_en    <= '0';
		A_en    <= '0';
		SP_H_en <= '0';
		SP_L_en <= '0';
		X_H_en  <= '0';
		X_L_en  <= '0';
		C_en    <= '0';
		V_en    <= '0';
		S_en    <= '0';
		Z_en    <= '0';
		ALU_en  <= '0';
		sel_alu <= "0000";
		
	  	wait for 10 ns;
	  	rst 	<= '0';
	  	
	  	-- Toggle clock
	  	clk 	<= '0';
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
	  	
	  	-- Load 15 onto the external bus
	  	Read	<= '1';
	  	external_bus_in <= "00001111";	
	  	-- Load external bus value onto AR_H
	  	AR_H_en <= '1';
	  	
	  	-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
	  	
  		
  		
  		
  		wait;
  	end process;
		
end TB;
