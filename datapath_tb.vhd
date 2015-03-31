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
		port(clk            : in  std_logic;
			 rst            : in  std_logic;
			 CPU_bus_in     : in  std_logic_vector(width - 1 downto 0);
			 CPU_bus_out    : out std_logic_vector(width - 1 downto 0);
			 address_bus    : out std_logic_vector(2 * width - 1 downto 0);
			 C              : out std_logic;
			 V              : out std_logic;
			 S              : out std_logic;
			 Z              : out std_logic;
			 CPU_bus_in_en  : in  std_logic;
			 CPU_bus_out_en : in  std_logic;
			 IR_en          : in  std_logic;
			 PC_H_en        : in  std_logic;
			 PC_L_en        : in  std_logic;
			 D_en           : in  std_logic;
			 A_en           : in  std_logic;
			 SP_H_en        : in  std_logic;
			 SP_L_en        : in  std_logic;
			 X_H_en         : in  std_logic;
			 X_L_en         : in  std_logic;
			 ALU_en         : in  std_logic;
			 AR_H_load      : in  std_logic;
			 AR_L_load      : in  std_logic;
			 IR_load        : in  std_logic;
			 PC_H_load      : in  std_logic;
			 PC_L_load      : in  std_logic;
			 D_load         : in  std_logic;
			 A_load         : in  std_logic;
			 SP_H_load      : in  std_logic;
			 SP_L_load      : in  std_logic;
			 X_H_load       : in  std_logic;
			 X_L_load       : in  std_logic;
			 C_load         : in  std_logic;
			 V_load         : in  std_logic;
			 S_load         : in  std_logic;
			 Z_load         : in  std_logic;
			 ALU_load       : in  std_logic;
			 ALU_sel        : in  std_logic_vector(3 downto 0);
			 PC_inc         : in  std_logic;
			 PC_addr_en     : in  std_logic;
			 AR_addr_en     : in  std_logic);
	end component datapath;

	signal	width			 : positive := 8;
	signal	clk              : std_logic;
	signal	rst              : std_logic;
	signal	CPU_bus_in  : std_logic_vector(width - 1 downto 0);
	signal	CPU_bus_out : std_logic_vector(width - 1 downto 0);
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
	signal	ALU_sel          : std_logic_vector(3 downto 0);
	signal CPU_bus_in_en : std_logic;
	signal CPU_bus_out_en : std_logic;
	signal	AR_H_load          : std_logic;
	signal	AR_L_load          : std_logic;
	signal	IR_load            : std_logic;
	signal	PC_H_load          : std_logic;
	signal	PC_L_load          : std_logic;
	signal	D_load             : std_logic;
	signal	A_load             : std_logic;
	signal	SP_H_load          : std_logic;
	signal	SP_L_load          : std_logic;
	signal	X_H_load           : std_logic;
	signal	X_L_load           : std_logic;
	signal	C_load             : std_logic;
	signal	V_load             : std_logic;
	signal	S_load             : std_logic;
	signal	Z_load             : std_logic;
	signal	ALU_load           : std_logic;
	signal CPU_bus_in_load : std_logic;
	signal CPU_bus_out_load : std_logic;
	signal PC_inc : std_logic;
	signal PC_addr_en : std_logic;
	signal AR_addr_en : std_logic;
	
begin
	
	UUT	: component datapath
		generic map(width => width)
		port map(clk            => clk,
			     rst            => rst,
			     CPU_bus_in     => CPU_bus_in,
			     CPU_bus_out    => CPU_bus_out,
			     address_bus    => address_bus,
			     C              => C,
			     V              => V,
			     S              => S,
			     Z              => Z,
			     CPU_bus_in_en  => CPU_bus_in_en,
			     CPU_bus_out_en => CPU_bus_out_en,
			     IR_en          => IR_en,
			     PC_H_en        => PC_H_en,
			     PC_L_en        => PC_L_en,
			     D_en           => D_en,
			     A_en           => A_en,
			     SP_H_en        => SP_H_en,
			     SP_L_en        => SP_L_en,
			     X_H_en         => X_H_en,
			     X_L_en         => X_L_en,
			     ALU_en         => ALU_en,
			     AR_H_load      => AR_H_load,
			     AR_L_load      => AR_L_load,
			     IR_load        => IR_load,
			     PC_H_load      => PC_H_load,
			     PC_L_load      => PC_L_load,
			     D_load         => D_load,
			     A_load         => A_load,
			     SP_H_load      => SP_H_load,
			     SP_L_load      => SP_L_load,
			     X_H_load       => X_H_load,
			     X_L_load       => X_L_load,
			     C_load         => C_load,
			     V_load         => V_load,
			     S_load         => S_load,
			     Z_load         => Z_load,
			     ALU_load       => ALU_load,
			     ALU_sel        => ALU_sel,
			     PC_inc         => PC_inc,
			     PC_addr_en     => PC_addr_en,
			     AR_addr_en     => AR_addr_en);
	
	
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
		AR_H_load <= '0';
		AR_L_load <= '0';
		IR_load   <= '0';
		PC_H_load <= '0';
		PC_L_load <= '0';
		D_load    <= '0';
		A_load    <= '0';
		SP_H_load <= '0';
		SP_L_load <= '0';
		X_H_load  <= '0';
		X_L_load  <= '0';
		C_load    <= '0';
		V_load    <= '0';
		S_load    <= '0';
		Z_load    <= '0';
		ALU_load  <= '0';
		ALU_sel <= "0000";
		
	  	wait for 10 ns;
	  	rst 	<= '0';
	  	CPU_bus_out_en	<= '0';
	  	CPU_bus_in_en	<= '0';
	  	
	  	-- Toggle clock
	  	clk 	<= '0';
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
	  	
	  	-- Load 15 onto the CPU bus
	  	CPU_bus_in_en	<= '1';
	  	CPU_bus_in_load <= '1';
	  	CPU_bus_in <= x"01";	
	  	-- Load CPU bus value onto AR_H
	  	AR_H_load <= '1';
	  	
----------------------------------------------------------------------------
	  	-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------

	  	AR_H_load <= '0';
	  	
	  	CPU_bus_in <= x"02";

	  	-- Load CPU bus value onto AR_L
	  	AR_L_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------

		AR_L_load <= '0';
	  	
	  	CPU_bus_in <= x"03";	
	  	
	  	-- Load CPU bus value onto IR_load
	  	IR_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------

	  	IR_load <= '0';
	  	
	  	CPU_bus_in <= x"04";	
	  	
	  	-- Load CPU bus value onto PC_H
	  	PC_H_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
  		
  		PC_H_load <= '0';
	  	
	  	CPU_bus_in <= x"05";	
	  	
	  	-- Load CPU bus value onto PC_L
	  	PC_L_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		PC_L_load <= '0';
	  	
	  	CPU_bus_in <= x"06";	
	  	
	  	-- Load CPU bus value onto D
	  	D_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		D_load <= '0';
	  	
	  	CPU_bus_in <= x"07";	
	  	
	  	-- Load CPU bus value onto A
	  	A_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		A_load <= '0';
	  	
	  	CPU_bus_in <= x"08";	
	  	
	  	-- Load CPU bus value onto SP_H
	  	SP_H_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		SP_H_load <= '0';
	  	
	  	CPU_bus_in <= x"09";	
	  	
	  	-- Load CPU bus value onto SP_L
	  	SP_L_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		SP_L_load <= '0';
	  	
	  	CPU_bus_in <= x"0A";	
	  	
	  	-- Load CPU bus value onto X_H
	  	X_H_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		X_H_load <= '0';
	  	
	  	CPU_bus_in <= x"0B";	
	  	
	  	-- Load CPU bus value onto X_L
	  	X_L_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		X_L_load <= '0';	

	  	-- Load CPU bus value onto PC_L
	  	ALU_load <= '1';
	  	
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		ALU_load <= '0';
		CPU_bus_in_en <= '0';
		
		-- END OF THE READING CYCLES ---------------------------------------------------------------------------------------------------------------------------------------
		-- START OF THE WRITING CYCLES -------------------------------------------------------------------------------------------------------------------------------------
		
		CPU_bus_out_en <= '1';
		ALU_en <= '1';
		
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
  		
		ALU_en <= '0';
		X_L_en <= '1';
  		
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		X_L_en <= '0';
		X_H_en <= '1';
  		
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		X_H_en <= '0';
		SP_L_en <= '1';
  		
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		SP_L_en <= '0';
		SP_H_en <= '1';

----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		SP_H_en <= '0';
		A_en <= '1';

----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		A_en <= '0';
		D_en <= '1';

----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		D_en <= '0';
		PC_L_en <= '1';

----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		PC_L_en <= '0';
		PC_H_en <= '1';

----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		PC_H_en <= '0';
		IR_en <= '1';
		
----------------------------------------------------------------------------
  		-- Toggle clock
	  	wait for 10 ns;
	  	clk 	<= '1';
	  	wait for 10 ns;
	  	clk 	<= '0';
----------------------------------------------------------------------------
		
		IR_en <= '0';
  		
  		wait;
  	end process;
		
end TB;
