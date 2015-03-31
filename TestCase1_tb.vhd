-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity TestCase1_tb is
end TestCase1_tb;

architecture TB of TestCase1_tb is
  
  constant WIDTH  : positive := 8;
  signal clk         :  std_logic;
  signal rst         :  std_logic;
  signal CPU_data_out : std_logic_vector(width - 1 downto 0);
  signal RAM_data_out : std_logic_vector(width - 1 downto 0);
  signal CPU_bus_out_en : std_logic;
  signal WR : std_logic;
  signal internal_data_bus : std_logic_vector(width-1 downto 0);
  signal address : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal data : STD_LOGIC_VECTOR (7 DOWNTO 0);
  signal q : STD_LOGIC_VECTOR (7 DOWNTO 0);


begin  -- TB

  U_INTERNAL_MUX : entity work.TestCase1
  	port map(address => address,
  		     clock   => clk,
  		     data    => data,
  		     wren    => WR,
  		     q       => q);

  process
  		variable addr_var : unsigned(7 downto 0);
  begin
  
  	--	Default starting values
    rst <= '1';
    WR <= '0';
    addr_var := x"00";
    for i in 0 to 255 loop
	    clk <= '0';
	    wait for 10 ns;
	    clk <= '1';
	    wait for 10 ns;
	    clk <= '0';
	    
    	addr_var := addr_var + 1;
    	address <= std_logic_vector(addr_var);
    end loop;
    
    wait;
    
    
    
    

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  end process;
end TB;