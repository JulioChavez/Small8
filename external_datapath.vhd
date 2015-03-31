-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- External Architecture Data Path

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity external_datapath is
	generic(
		width : positive := 8);
	port(
		clk     			: in  std_logic;
		rst     			: in  std_logic;
		input0				: in  std_logic_vector(width-1 downto 0);
		input1				: in  std_logic_vector(width-1 downto 0);
		output0				: out std_logic_vector(width-1 downto 0);
		output1				: out std_logic_vector(width-1 downto 0)
		
	);
end external_datapath;

architecture STR of external_datapath is
	
	signal IR_output           : std_logic_vector(width - 1 downto 0);
	
	signal internal_data_bus   : std_logic_vector(width - 1 downto 0);
	
	signal CPU_bus_in_en  	   : std_logic;
	signal CPU_bus_out_en 	   : std_logic;
	signal IR_en               : std_logic;
	signal PC_H_en             : std_logic;
	signal PC_L_en             : std_logic;
	signal D_en                : std_logic;
	signal A_en                : std_logic;
	signal SP_H_en             : std_logic;
	signal SP_L_en             : std_logic;
	signal X_H_en              : std_logic;
	signal X_L_en              : std_logic;
	signal ALU_en              : std_logic;
	signal TEMP_1_en		   : std_logic;
	signal TEMP_2_en		   : std_logic;
	signal C_en 			   : std_logic;
	signal V_en 			   : std_logic;
	signal S_en 			   : std_logic;
	signal Z_en 			   : std_logic;
	
	signal AR_H_load           : std_logic;
	signal AR_L_load           : std_logic;
	signal IR_load             : std_logic;
	signal D_load              : std_logic;
	signal PC_H_load           : std_logic;
	signal PC_L_load           : std_logic;
	signal PC_addr_load           : std_logic;
	signal A_load              : std_logic;
	signal SP_H_load           : std_logic;
	signal SP_L_load           : std_logic;
	signal X_H_load            : std_logic;
	signal X_L_load            : std_logic;
	signal C_load              : std_logic;
	signal V_load              : std_logic;
	signal S_load              : std_logic;
	signal Z_load              : std_logic;
	signal ALU_load            : std_logic;
	signal TEMP_1_load		   : std_logic;
	signal TEMP_2_load		   : std_logic;
	signal ALU_sel             : std_logic_vector(3 downto 0);
	signal PC_inc              : std_logic;
	signal A_inc			   : std_logic;
	signal X_inc			   : std_logic;
	signal SP_inc			   : std_logic;
	signal A_dec			   : std_logic;
	signal X_dec			   : std_logic;
	signal SP_dec			   : std_logic;
	signal address_bus 		   : std_logic_vector(2*width - 1 downto 0);
	signal CPU_data_out 	   : std_logic_vector(width - 1 downto 0);
	signal RAM_data_out 	   : std_logic_vector (7 downto 0);
	signal RD 				   : std_logic;
	signal WR 				   : std_logic;
	signal PC_addr_en 		   : std_logic;
	signal AR_addr_en 		   : std_logic;
	signal SP_addr_en 		   : std_logic;
	signal X_addr_en  		   : std_logic;
	signal C 				   : std_logic;
	signal V 				   : std_logic;
	signal S 				   : std_logic;
	signal Z 				   : std_logic;
	signal C_rst 			   : std_logic;
	signal V_rst 			   : std_logic;
	signal S_rst 			   : std_logic;
	signal Z_rst 			   : std_logic;
	signal C_set 			   : std_logic;
	signal V_set 			   : std_logic;
	signal S_set 			   : std_logic;
	signal Z_set 			   : std_logic;
	signal input0_input_load   : std_logic;
	signal input1_input_load   : std_logic;
	signal input0_data_load    : std_logic;
	signal input1_data_load    : std_logic;
	signal output0_read : std_logic;
	signal output1_read : std_logic;
	signal output0_signal : std_logic_vector(width - 1 downto 0);
	signal output1_signal : std_logic_vector(width - 1 downto 0);
	signal X_b_load : std_logic;
	signal X_indexed_addr_en : std_logic;
	signal ALU_mult_sel : std_logic;

begin

------------ External Architecture Data Path --------------------------------------------------------------------------------------
	
	
	U_INTERNAL_ARCH_DATAPATH : entity work.datapath
		generic map(width => width)
		port map(clk                 => clk,
			     rst                 => rst,
			     IR_output			 => IR_output,
			     CPU_bus_in     	 => internal_data_bus,
			     CPU_bus_out    	 => CPU_data_out,
			     address_bus         => address_bus,
			     C                   => C,
			     V                   => V,
			     S                   => S,
			     Z                   => Z,
			     CPU_bus_in_en  	 => CPU_bus_in_en,
			     CPU_bus_out_en 	 => CPU_bus_out_en,
			     IR_en               => IR_en,
			     PC_H_en             => PC_H_en,
			     PC_L_en             => PC_L_en,
			     D_en                => D_en,
			     A_en                => A_en,
			     SP_H_en             => SP_H_en,
			     SP_L_en             => SP_L_en,
			     X_H_en              => X_H_en,
			     X_L_en              => X_L_en,
			     ALU_en              => ALU_en,
			     TEMP_1_en			 => TEMP_1_en,
			     TEMP_2_en			 => TEMP_2_en,
			     AR_H_load           => AR_H_load,
			     AR_L_load           => AR_L_load,
			     IR_load             => IR_load,
			     PC_H_load           => PC_H_load,
			     PC_L_load           => PC_L_load,
			     PC_addr_load		 => PC_addr_load,
			     D_load              => D_load,
			     A_load              => A_load,
			     SP_H_load           => SP_H_load,
			     SP_L_load           => SP_L_load,
			     X_H_load            => X_H_load,
			     X_L_load            => X_L_load,
			     X_b_load			 => X_b_load,
			     C_load              => C_load,
			     V_load              => V_load,
			     S_load              => S_load,
			     Z_load              => Z_load,
			     ALU_load            => ALU_load,
			     TEMP_1_load		 => TEMP_1_load,
			     TEMP_2_load		 => TEMP_2_load,
			     ALU_sel             => ALU_sel,
			     ALU_mult_sel		 => ALU_mult_sel,
			     C_rst				 => C_rst,
			     V_rst				 => V_rst,
			     S_rst				 => S_rst,
			     Z_rst				 => Z_rst,
			     C_set				 => C_set,
			     V_set				 => V_set,
			     S_set				 => S_set,
			     Z_set				 => Z_set,
			     PC_inc              => PC_inc,
			     A_inc				 => A_inc,
			     A_dec				 => A_dec,
			     X_inc				 => X_inc,
			     X_dec				 => X_dec,
			     SP_inc				 => SP_inc,
			     SP_dec				 => SP_dec,
			     AR_addr_en			 => AR_addr_en,
			     SP_addr_en			 => SP_addr_en,
			     X_addr_en			 => X_addr_en,
			     X_indexed_addr_en   => X_indexed_addr_en,
			     PC_addr_en			 => PC_addr_en);
			     
	U_CONTROLLER : entity work.ctrl
		generic map(width => width)
		port map(clk                   => clk,
			     rst                   => rst,
			     address_bus		   => address_bus,
			     IR_output             => IR_output,
			     C                     => C,
			     V                     => V,
			     S                     => S,
			     Z                     => Z,
			     CPU_bus_in_en    	   => CPU_bus_in_en,
			     CPU_bus_out_en   	   => CPU_bus_out_en,
			     IR_en                 => IR_en,
			     PC_H_en               => PC_H_en,
			     PC_L_en               => PC_L_en,
			     D_en                  => D_en,
			     A_en                  => A_en,
			     SP_H_en               => SP_H_en,
			     SP_L_en               => SP_L_en,
			     X_H_en                => X_H_en,
			     X_L_en                => X_L_en,
			     C_en                  => C_en,
			     V_en                  => V_en,
			     S_en                  => S_en,
			     Z_en                  => Z_en,
			     ALU_en                => ALU_en,
			     TEMP_1_en			   => TEMP_1_en,
			     TEMP_2_en			   => TEMP_2_en,
			     AR_H_load             => AR_H_load,
			     AR_L_load             => AR_L_load,
			     IR_load               => IR_load,
			     PC_H_load             => PC_H_load,
			     PC_L_load             => PC_L_load,
			     PC_addr_load		   => PC_addr_load,
			     D_load                => D_load,
			     A_load                => A_load,
			     SP_H_load             => SP_H_load,
			     SP_L_load             => SP_L_load,
			     X_H_load              => X_H_load,
			     X_L_load              => X_L_load,
			     X_b_load			   => X_b_load,
			     C_load                => C_load,
			     V_load                => V_load,
			     S_load                => S_load,
			     Z_load                => Z_load,
			     ALU_load              => ALU_load,
			     TEMP_1_load		   => TEMP_1_load,
			     TEMP_2_load		   => TEMP_2_load,
			     input0_input_load	   => input0_input_load,
			     input1_input_load	   => input1_input_load,
			     input0_data_load	   => input0_data_load,
			     input1_data_load	   => input1_data_load,
			     output0_read		   => output0_read,
			     output1_read		   => output1_read,
			     ALU_sel               => ALU_sel,
			     ALU_mult_sel		   => ALU_mult_sel,
			     C_rst				   => C_rst,
			     V_rst				   => V_rst,
			     S_rst				   => S_rst,
			     Z_rst				   => Z_rst,
			     C_set				   => C_set,
			     V_set				   => V_set,
			     S_set				   => S_set,
			     Z_set				   => Z_set,
			     PC_inc                => PC_inc,
			     A_inc				   => A_inc,
			     A_dec				   => A_dec,
			     X_inc				   => X_inc,
			     X_dec				   => X_dec,
			     SP_inc				   => SP_inc,
			     SP_dec				   => SP_dec,
			     AR_addr_en			   => AR_addr_en,
			     SP_addr_en			   => SP_addr_en,
			     X_addr_en			   => X_addr_en,
			     X_indexed_addr_en     => X_indexed_addr_en,
			     PC_addr_en			   => PC_addr_en,
			     RD					   => RD,
			     WR				   	   => WR);
	
	-- External RAM
	-- There are several RAM declarations commented out for ease when testing out the different RAMs during the EEL4712 limited lab period.
--	U_RAM : entity work.TestCase1
--		port map(address => address_bus(7 downto 0),
--			     clock   => clk,
--			     data    => internal_data_bus,
--			     wren    => WR,
--			     q       => RAM_data_out);
			     
	U_RAM : entity work.TestCase2
		port map(address => address_bus(7 downto 0),
			     clock   => clk,
			     data    => internal_data_bus,
			     wren    => WR,
			     q       => RAM_data_out);

--	U_RAM : entity work.TestCase3
--		port map(address => address_bus(7 downto 0),
--			     clock   => clk,
--			     data    => internal_data_bus,
--			     wren    => WR,
--			     q       => RAM_data_out);
	
--	U_RAM : entity work.mult
--		port map(address => address_bus(7 downto 0),
--			     clock   => clk,
--			     data    => internal_data_bus,
--			     wren    => WR,
--			     q       => RAM_data_out);

--	U_RAM : entity work.TestCase1WithSubroutine
--		port map(address => address_bus(7 downto 0),
--			     clock   => clk,
--			     data    => internal_data_bus,
--			     wren    => WR,
--			     q       => RAM_data_out);
			     
--	U_RAM : entity work.deliverable6b
--		port map(address => address_bus(7 downto 0),
--			     clock   => clk,
--			     data    => internal_data_bus,
--			     wren    => WR,
--			     q       => RAM_data_out);
			     
	U_INPUT0_REG : entity work.reg_io
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load(1)	=> input0_input_load,
			     load(0) 	=> input0_data_load,
			     input  => input0,
			     data   => internal_data_bus,
			     output => output0_signal);
	output0 <= output0_signal;
	
	U_INPUT1_REG : entity work.reg_io
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load(1)	=> input1_input_load,
			     load(0) 	=> input1_data_load,
			     input  => input1,
			     data   => internal_data_bus,
			     output => output1_signal);
	output1 <= output1_signal;
			     
	U_INTERNAL_MUX : entity work.external_datapath_mux
		generic map(width => width)
		port map(CPU_data_out      => CPU_data_out,
			     RAM_data_out      => RAM_data_out,
			     output0		   => output0_signal,
			     output1		   => output1_signal,
			     sel(3)            => CPU_bus_out_en,
			     sel(2)			   => RD,
			     sel(1)			   => output0_read,
			     sel(0)			   => output1_read,
			     internal_data_bus => internal_data_bus);
end STR;
