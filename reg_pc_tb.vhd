-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reg_pc_tb is
end reg_pc_tb;

architecture TB of reg_pc_tb is

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
  
  constant WIDTH  : positive := 8;
  signal clk         :  std_logic;
  signal rst         :  std_logic;
  signal input       :  std_logic_vector(width - 1 downto 0);
  signal PC_inc      :  std_logic;
  signal PC_L_load   :  std_logic;
  signal PC_H_load   :  std_logic;
  signal PC_L_output : std_logic_vector(width - 1 downto 0);
  signal PC_H_output : std_logic_vector(width - 1 downto 0);


begin  -- TB

  UUT : reg_inc_dec_16_bit_and_indexing
  	generic map(width => width)
  	port map(clk         => clk,
  		     rst         => rst,
  		     input       => input,
  		     PC_inc      => PC_inc,
  		     PC_L_load   => PC_L_load,
  		     PC_H_load   => PC_H_load,
  		     
  		     PC_L_output => PC_L_output,
  		     PC_H_output => PC_H_output);

  process
  begin
  
  	--	Default starting values
    rst <= '1';
    PC_inc <= '0';
    PC_L_load <= '0';
    PC_H_load <= '0';
    
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
    
    PC_L_load <= '1';
    input <= x"FF";
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
    PC_L_load <= '0';
    PC_H_load <= '1';
    input <= x"AA";
    
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
    
    PC_H_load <= '0';
    PC_inc <= '1';
    
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
    
    
    
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
    clk <= '0';
    
--    PC_inc <= '0';
    
    
    for i in 0 to 500 loop
	    clk <= '0';
	    wait for 10 ns;
	    clk <= '1';
	    wait for 10 ns;
	    clk <= '0';
    end loop;
    PC_inc <= '0';
    
    wait;
    
    
    
    

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


  end process;
end TB;