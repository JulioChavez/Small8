-- Julio Chavez
-- University of Florida 

-- Small8 Microprocessor
-- External Architecture Datapath Mux

library ieee;
use ieee.std_logic_1164.all;

entity external_datapath_mux is
  generic (
    width  :     positive);
  port (
  	CPU_data_out	 : in  std_logic_vector(width-1 downto 0);
	RAM_data_out     : in  std_logic_vector(width-1 downto 0);
	output0			 : in  std_logic_vector(width-1 downto 0);
	output1			 : in  std_logic_vector(width-1 downto 0);
	
    sel				 : in  std_logic_vector(3 downto 0);
	
    internal_data_bus 	 : out std_logic_vector(width-1 downto 0));
end external_datapath_mux;

architecture BHV of external_datapath_mux is
begin

	with sel select
		internal_data_bus <=
			CPU_data_out 			when "1000",
			RAM_data_out 			when "0100",
			output0					when "0010",
			output1					when "0001",
			(others => 'Z') 		when others;
end BHV;
