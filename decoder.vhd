-- Julio Chavez
-- University of Florida

-- Internal Architecture Controller

library ieee;
use ieee.std_logic_1164.all;

entity decoder is
	generic(
		width : positive := 8);
	port(
		address_bus		: in  std_logic_vector((2*width-1) downto 0);
		RD				: in  std_logic;
		WR				: in  std_logic;
		-- Goes to the wren input of the RAM
		-- Write = '1', Read = '0'
		wren 	: out std_logic 
	);
end decoder;

architecture BHV of decoder is
	
begin
	
end BHV;
