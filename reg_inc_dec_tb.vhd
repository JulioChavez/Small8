-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reg_inc_dec_tb is
end reg_inc_dec_tb;

architecture TB of reg_inc_dec_tb is

  component reg_inc_dec_16_bit_and_indexing
  	generic(width : positive := 8);
  	port(clk         : in  std_logic;
  		 rst         : in  std_logic;
  		 input       : in  std_logic_vector(width - 1 downto 0);
  		 PC_inc      : in  std_logic;
  		 PC_L_load   : in  std_logic;
  		 PC_H_load   : in  std_logic;
  		 PC_L_output : out std_logic_vector(width - 1 downto 0);
  		 PC_H_output : out std_logic_vector(width - 1 downto 0));
  end component reg_inc_dec_16_bit_and_indexing;
  
  component reg_inc_dec
  	generic(width : positive := 8);
  	port(clk    : in  std_logic;
  		 rst    : in  std_logic;
  		 load   : in  std_logic;
  		 inc    : in  std_logic;
  		 dec    : in  std_logic;
  		 input  : in  std_logic_vector(width - 1 downto 0);
  		 output : out std_logic_vector(width - 1 downto 0));
  end component reg_inc_dec;
  
  constant WIDTH  : positive := 8;
  signal clk         :  std_logic;
  signal rst         :  std_logic;
  signal inc		 :  std_logic;
  signal dec		 :  std_logic;
  signal load   	 :  std_logic;
  signal input       :  std_logic_vector(width - 1 downto 0);
  signal output 	 :  std_logic_vector(width - 1 downto 0);

begin  -- TB

	U_REG_INC_DEC : reg_inc_dec
		generic map(width => width)
		port map(clk    => clk,
			     rst    => rst,
			     load   => load,
			     inc    => inc,
			     dec    => dec,
			     input  => input,
			     output => output);
			     

  process
  begin
  
  	--	Default starting values
    rst <= '1';
    inc <= '0';
    dec <= '0';
    load <= '0';
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    rst <= '0';
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    load <= '1';
    input <= x"EA";
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    load <= '0';
    inc <= '1';
    
   	for i in 0 to 30 loop
	    clk <= '0';
	    wait for 10 ns;
	    clk <= '1';
	    wait for 10 ns;
	    clk <= '0';
    end loop;
    
	inc <= '0';
	dec <= '1';
    
    
    for i in 0 to 20 loop
	    clk <= '0';
	    wait for 10 ns;
	    clk <= '1';
	    wait for 10 ns;
	    clk <= '0';
    end loop;
    dec <= '0';
    
    wait;
    
    
    
    

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  end process;
end TB;