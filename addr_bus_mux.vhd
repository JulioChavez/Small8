-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Address Bus Mux

-- This multiplexer will decide who is driving the address lines 
-- of the Small8 at any given moment

library ieee;
use ieee.std_logic_1164.all;

entity addr_bus_mux is
	generic(
		width : positive := 8);
	port(
		AR_output      	  : in  std_logic_vector(2*width - 1 downto 0);
		SP_output		  : in  std_logic_vector(2*width - 1 downto 0);
		X_output		  : in	std_logic_vector(2*width - 1 downto 0);
		X_indexed_output  : in  std_logic_vector(2*width - 1 downto 0);
		PC_output      	  : in  std_logic_vector(2*width - 1 downto 0);
		
		sel               : in  std_logic_vector(4 downto 0);
		address_bus 	  : out std_logic_vector(2*width - 1 downto 0));
end addr_bus_mux;

architecture BHV of addr_bus_mux is
begin
	with sel select address_bus <=
		AR_output when "10000",
		SP_output when "01000",
		X_output  when "00100",
		X_indexed_output when "00010",
		PC_output when others;
end BHV;
