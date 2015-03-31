-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Internal Architecture Data Path

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	generic(
		width : positive := 8);
	port(
		clk     			: in  std_logic;
		rst     			: in  std_logic;
		CPU_bus_in		: in  std_logic_vector(width - 1 downto 0);
		CPU_bus_out	: out std_logic_vector(width - 1 downto 0);
		address_bus 		: out std_logic_vector(2*width - 1 downto 0);
		C					: out std_logic;
		V					: out std_logic;
		S					: out std_logic;
		Z					: out std_logic;
		IR_output			: out std_logic_vector(width-1 downto 0);

		-- Signals from controller:
		
		-- The enable inputs decide who is driving the internal data bus
		CPU_bus_in_en : in std_logic;
		CPU_bus_out_en : in std_logic;
		IR_en   : in  std_logic;
		PC_H_en : in  std_logic;
		PC_L_en : in  std_logic;
		D_en    : in  std_logic;
		A_en    : in  std_logic;
		SP_H_en : in  std_logic;
		SP_L_en : in  std_logic;
		X_H_en  : in  std_logic;
		X_L_en  : in  std_logic;
--		X_b_en	: in  std_logic;
		ALU_en  : in  std_logic;
		TEMP_1_en : in  std_logic;
		TEMP_2_en : in  std_logic;
		
		-- Load signals for the registers
		AR_H_load : in  std_logic;
		AR_L_load : in  std_logic;
		IR_load   : in  std_logic;
		PC_H_load : in  std_logic;
		PC_L_load : in  std_logic;
		PC_addr_load : in  std_logic;
		D_load    : in  std_logic;
		A_load    : in  std_logic;
		SP_H_load : in  std_logic;
		SP_L_load : in  std_logic;
		X_H_load  : in  std_logic;
		X_L_load  : in  std_logic;
		X_b_load  : in  std_logic;
		C_load    : in  std_logic;
		V_load    : in  std_logic;
		S_load    : in  std_logic;
		Z_load    : in  std_logic;
		ALU_load  : in  std_logic;
		TEMP_1_load : in  std_logic;
		TEMP_2_load : in  std_logic;

		-- Select for the ALU
		ALU_sel : in  std_logic_vector(3 downto 0);
		ALU_mult_sel : in std_logic;
		
		-- Individual resets/sets for the status registers
		C_rst	: in  std_logic;
		V_rst	: in  std_logic;
		S_rst	: in  std_logic;
		Z_rst	: in  std_logic;
		C_set	: in  std_logic;
		V_set	: in  std_logic;
		S_set	: in  std_logic;
		Z_set	: in  std_logic;
		
		-- Individual reset for D register, to be used when 
		
		-- Increments the register's output by 1
		PC_inc	: in  std_logic;
		A_inc	: in  std_logic;
		X_inc	: in  std_logic;
		SP_inc	: in  std_logic;
		
		-- Decrements the register's output by 1
		A_dec	: in  std_logic;
		X_dec	: in  std_logic;
		SP_dec	: in  std_logic;
		
		-- Decides what drives the address bus
		PC_addr_en	: in  std_logic;
		AR_addr_en	: in  std_logic;
		SP_addr_en	: in  std_logic;
		X_addr_en	: in  std_logic;
		X_indexed_addr_en : in  std_logic
	);
end datapath;

architecture STR of datapath is
	signal C_input    		: std_logic;
	signal V_input    		: std_logic;
	signal S_input    		: std_logic;
	signal Z_input    		: std_logic;

	signal IR_output_signal        : std_logic_vector(width-1 downto 0);
	signal PC_H_output      : std_logic_vector(width-1 downto 0);
	signal PC_L_output      : std_logic_vector(width-1 downto 0);
	signal D_output         : std_logic_vector(width-1 downto 0);
	signal A_output         : std_logic_vector(width-1 downto 0);
	signal SP_H_output      : std_logic_vector(width-1 downto 0);
	signal SP_L_output      : std_logic_vector(width-1 downto 0);
	signal X_H_output       : std_logic_vector(width-1 downto 0);
	signal X_L_output       : std_logic_vector(width-1 downto 0);
	signal ALU_output 		: std_logic_vector(width-1 downto 0);
	signal ALU_reg_output 	: std_logic_vector(width-1 downto 0);
	signal AR_H_output      : std_logic_vector(width-1 downto 0);
	signal AR_L_output      : std_logic_vector(width-1 downto 0);
	signal TEMP_1_output	: std_logic_vector(width-1 downto 0);
	signal TEMP_2_output	: std_logic_vector(width-1 downto 0);
	signal AR_output      : std_logic_vector(2*width-1 downto 0);
	signal PC_output : std_logic_vector(2*width-1 downto 0);
	signal SP_output : std_logic_vector(2*width-1 downto 0);
	signal X_output : std_logic_vector(2*width-1 downto 0);
	signal C_output			: std_logic;
	
	signal C_rst_signal		: std_logic;
	signal V_rst_signal		: std_logic;
	signal S_rst_signal		: std_logic;
	signal Z_rst_signal		: std_logic;
--	signal D_rst_signal		: std_logic;
	
	signal internal_bus 	: std_logic_vector(width-1 downto 0);
	signal address_bus_signal : std_logic_vector(2*width - 1 downto 0);
	signal X_indexed_output : std_logic_vector(2*width-1 downto 0);
	signal ALU_A_mult_output : std_logic_vector(WIDTH-1 downto 0);
	signal ALU_D_mult_output : std_logic_vector(WIDTH-1 downto 0);
	signal A_output_reg : std_logic_vector(width-1 downto 0);
	signal D_output_reg : std_logic_vector(width-1 downto 0);
	signal D_input : std_logic_vector(width-1 downto 0);
	signal A_input : std_logic_vector(width-1 downto 0);

begin

------------ Internal Architecture Data Path --------------------------------------------------------------------------------------
	-- Internal Bus registers
	U_AR_H_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => AR_H_load,
			     input  => internal_bus,
			     output => AR_H_output);

	U_AR_L_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => AR_L_load,
			     input  => internal_bus,
			     output => AR_L_output);
			     
	AR_output <= (AR_H_output & AR_L_output);
			     
	U_ADDR_BUS_MUX : entity work.addr_bus_mux
		generic map(width => width)
		port map(AR_output   => AR_output,
			     SP_output   => SP_output,
			     X_output    => X_output,
			     X_indexed_output => X_indexed_output,
			     PC_output   => PC_output,
			     sel(4)      => AR_addr_en,
			     sel(3)		 => SP_addr_en,
			     sel(2)		 => X_addr_en,
			     sel(1)		 => X_indexed_addr_en,
			     sel(0)		 => PC_addr_en,
			     address_bus => address_bus_signal);
			     
	address_bus <= address_bus_signal;
	
	U_IR_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => IR_load,
			     input  => internal_bus,
			     output => IR_output_signal);
	IR_output <= IR_output_signal;

	U_PC_REG : entity work.reg_pc
		generic map(width => width)
		port map(clk         => clk,
			     rst         => rst,
			     input       => internal_bus,
			     address_bus => address_bus_signal,
			     PC_inc      => PC_inc,
			     PC_L_load   => PC_L_load,
			     PC_H_load   => PC_H_load,
			     PC_addr_load => PC_addr_load,
			     PC_L_output => PC_L_output,
			     PC_H_output => PC_H_output,
			     PC_output	 => PC_output);

	U_D_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => D_load,
			     input  => D_input,
			     output => D_output);

	U_A_REG : entity work.reg_inc_dec
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => A_load,
			     inc    => A_inc,
			     dec    => A_dec,
			     input  => A_input,
			     output => A_output);
			     
	U_ALU_TO_A_REG_2x1_MUX : entity work.mux2x1
		generic map(width => width)
		port map(in1    => ALU_A_mult_output,
			     in2    => internal_bus,
			     sel    => ALU_mult_sel,
			     output => A_input);
			     
	U_ALU_TO_D_REG_2x1_MUX : entity work.mux2x1
		generic map(width => width)
		port map(in1    => ALU_D_mult_output,
			     in2    => internal_bus,
			     sel    => ALU_mult_sel,
			     output => D_input);

	U_SP_REG : entity work.reg_inc_dec_16_bit
		generic map(width => width)
		port map(clk      => clk,
			     rst      => rst,
			     input    => internal_bus,
			     inc      => SP_inc,
			     dec      => SP_dec,
			     L_load   => SP_L_load,
			     H_load   => SP_H_load,
			     L_output => SP_L_output,
			     H_output => SP_H_output,
			     output   => SP_output);
			     
	U_X_REG : entity work.reg_inc_dec_16_bit_and_indexing
		generic map(width => width)
		port map(clk         => clk,
			     rst         => rst,
			     input       => internal_bus,
			     b			 => internal_bus,
			     inc         => X_inc,
			     dec         => X_dec,
			     L_load      => X_L_load,
			     H_load      => X_H_load,
			     b_load		 => X_b_load,
			     L_output    => X_L_output,
			     H_output    => X_H_output,
			     output      => X_output,
			     indexed_output => X_indexed_output);
	
	U_TEMP_1_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => TEMP_1_load,
			     input  => internal_bus,
			     output => TEMP_1_output);
	
	U_TEMP_2_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => TEMP_2_load,
			     input  => internal_bus,
			     output => TEMP_2_output);

	U_ALU : entity work.alu
		generic map(width => width)
		port map(A        => A_output,
			     D        => D_output,
			     carry_in => C_output,
			     sel      => ALU_sel,
			     ALU_A_mult_output => ALU_A_mult_output,
			     ALU_D_mult_output => ALU_D_mult_output,
			     output   => ALU_output,	-- 	U_ALU(output)		 --> ALU_output --> ALU_REG(input)
			     V		  => V_input,		-- 	U_ALU(overflow)		 --> V_input 	--> V_REG(input)
			     C	      => C_input,		-- 	U_ALU(carry) 		 --> C_input 	--> C_REG(input)
			     S	      => S_input,		-- 	U_ALU(sign)	 		 --> S_input 	--> S_REG(input)
			     Z	      => Z_input);		-- 	U_ALU(zero) 		 --> Z_input 	--> Z_REG(input)
			     -- The format of the above is:	[entity(out signal)] --> [signal] 	--> [destination_entity(input signal)]

	U_ALU_REG : entity work.reg
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => ALU_load,
			     input  => ALU_output,
			     output => ALU_reg_output);

	-- HACK: I was having an issue with compiling a register of width=1,
	--		 so I created a one-bit register for the flag signals (C, V, S, Z)
	U_C_REG : entity work.reg_1_bit
		port map(clk    => clk,
			     rst    => C_rst_signal,
			     set	=> C_set,
			     load   => C_load,
			     input  => C_input,
			     output => C_output);
	C_rst_signal <= rst or C_rst;
	C <= C_output;

	U_V_REG : entity work.reg_1_bit
		port map(clk    => clk,
			     rst    => V_rst_signal,
			     set	=> V_set,
			     load   => V_load,
			     input  => V_input,
			     output => V);
	V_rst_signal <= rst or V_rst;

	U_S_REG : entity work.reg_1_bit
		port map(clk    => clk,
			     rst    => S_rst_signal,
			     set	=> S_set,
			     load   => S_load,
			     input  => S_input,
			     output => S);
	S_rst_signal <= rst or S_rst;

	U_Z_REG : entity work.reg_1_bit
		port map(clk    => clk,
			     rst    => Z_rst_signal,
			     set	=> Z_set,
			     load   => Z_load,
			     input  => Z_input,
			     output => Z);
	Z_rst_signal <= rst or Z_rst;

	-- This entity selects who is driving the internal data bus 
	U_INTERNAL_DATA_BUS_MUX : entity work.internal_datapath_mux
		generic map(width => width)
		port map(
				-- The following are all of the signals that could 
				-- potentially drive the internal databus 
				CPU_bus_in_output => CPU_bus_in,
				 IR_output    	 => IR_output_signal,
			     PC_H_output  	 => PC_H_output,
			     PC_L_output  	 => PC_L_output,
			     D_output     	 => D_output,
			     A_output     	 => A_output,
			     SP_H_output  	 => SP_H_output,
			     SP_L_output  	 => SP_L_output,
			     X_H_output   	 => X_H_output,
			     X_L_output   	 => X_L_output,
			     TEMP_1_output	 => TEMP_1_output,
			     TEMP_2_output	 => TEMP_2_output,
			     ALU_reg_output	 => ALU_reg_output,
			     
			     -- The enables serve as the select bits for the mux
			     sel(12)		 => CPU_bus_in_en,
			     sel(11)       	 => IR_en,
			     sel(10)       	 => PC_H_en,
			     sel(9)       	 => PC_L_en,
			     sel(8)       	 => D_en,
			     sel(7)       	 => A_en,
			     sel(6)       	 => SP_H_en,
			     sel(5)       	 => SP_L_en,
			     sel(4)       	 => X_H_en,
			     sel(3)       	 => X_L_en,
			     sel(2)			 => TEMP_1_en,
			     sel(1)			 => TEMP_2_en,
			     sel(0)		  	 => ALU_en,
			     
			     -- The internal_bus signal is connected to the output of the mux
			     internal_bus 	 => internal_bus);
			     
	-- Tri-state buffers for the external bus, going in and out of the internal architecture
	U_TRI_INTERNAL_TO_EXTERNAL_BUS : entity work.tristate
		generic map(width => width)
		port map(input  => internal_bus,
			     en     => CPU_bus_out_en,
			     output => CPU_bus_out);
			     
	U_TRI_EXTERNAL_TO_INTERNAL_BUS : entity work.tristate
		generic map(width => width)
		port map(input  => CPU_bus_in,
			     en     => CPU_bus_in_en,
			     output => internal_bus);
		
end STR;
