-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Internal Architecture Data Path Mux

library ieee;
use ieee.std_logic_1164.all;

entity internal_datapath_mux is
  generic (
    width  :     positive);
  port (
  	CPU_bus_in_output	 : in  std_logic_vector(width-1 downto 0);
	IR_output        : in  std_logic_vector(width-1 downto 0);
	PC_H_output      : in  std_logic_vector(width-1 downto 0);
	PC_L_output      : in  std_logic_vector(width-1 downto 0);
	D_output         : in  std_logic_vector(width-1 downto 0);
	A_output         : in  std_logic_vector(width-1 downto 0);
	SP_H_output      : in  std_logic_vector(width-1 downto 0);
	SP_L_output      : in  std_logic_vector(width-1 downto 0);
	X_H_output       : in  std_logic_vector(width-1 downto 0);
	X_L_output       : in  std_logic_vector(width-1 downto 0);
	TEMP_1_output	 : in  std_logic_vector(width-1 downto 0);
	TEMP_2_output	 : in  std_logic_vector(width-1 downto 0);
	ALU_reg_output   : in  std_logic_vector(width-1 downto 0);
	
	sel				 : in  std_logic_vector(12 downto 0);
	
    internal_bus 	 : out std_logic_vector(width-1 downto 0));
    
end internal_datapath_mux;

architecture BHV of internal_datapath_mux is
begin

	with sel select
		internal_bus <=
			CPU_bus_in_output 		when "1000000000000",
			IR_output 				when "0100000000000",
			PC_H_output				when "0010000000000",
			PC_L_output				when "0001000000000",
			D_output				when "0000100000000",
			A_output				when "0000010000000",
			SP_H_output				when "0000001000000",
			SP_L_output				when "0000000100000",
			X_H_output				when "0000000010000",
			X_L_output				when "0000000001000",
			TEMP_1_output			when "0000000000100",
			TEMP_2_output			when "0000000000010",
			ALU_reg_output			when "0000000000001",
			
			(others => 'Z') 		when others;
end BHV;
