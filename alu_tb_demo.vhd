-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu_tb_demo is
end alu_tb_demo;

architecture TB of alu_tb_demo is

  component alu

    generic (
      WIDTH    :     positive := 8
      );
    port (
   		A 			: in  std_logic_vector(WIDTH-1 downto 0);
		D	 		: in  std_logic_vector(WIDTH-1 downto 0);
		carry_in	: in  std_logic;
		sel 		: in  std_logic_vector(3 downto 0);
		output 		: out std_logic_vector(WIDTH-1 downto 0);
		V		 	: out std_logic;
		C		: out std_logic;
		S		: out std_logic;
		Z		: out std_logic
      );

  end component;

  constant WIDTH  : positive := 8;
  signal A        : std_logic_vector(WIDTH - 1 downto 0);
  signal D        : std_logic_vector(WIDTH - 1 downto 0);
  signal carry_in : std_logic;
  signal sel      : std_logic_vector(3 downto 0);
  signal output   : std_logic_vector(WIDTH - 1 downto 0);
  signal V 		  : std_logic;
  signal C    	  : std_logic;
  signal S     	  : std_logic;
  signal Z     	  : std_logic;


begin  -- TB

  UUT : alu
  	generic map(WIDTH => WIDTH)
  	port map(A        => A,
  		     D        => D,
  		     carry_in => carry_in,
  		     sel      => sel,
  		     output   => output,
  		     V 		  => V,
  		     C 		  => C,
  		     S 	      => S,
  		     Z        => Z);

  process
  begin
  
  	--	Default starting values
    A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    carry_in <= '0';
    sel	<= "0000";
    wait for 40 ns;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	ADD FUNCTION
	sel <= "0000";

	-- test 2+6
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(2, A'length);
    D <= conv_std_logic_vector(6, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(8, output'length)) report "Error : 2+6 = " & integer'image(conv_integer(output)) & " instead of 8" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for 2+8" severity warning;

    -- test 127+1 (overflow)
	-- C = 0
	-- V = 1
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(127, A'length);
    D <= conv_std_logic_vector(1, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-128, output'length)) report "Error : 127+1 = " & integer'image(conv_integer(output)) & " instead of -255" severity warning;
    assert(V = '1') report "Error                                     : V incorrect for 250+50" severity warning;

	-- test 30 + 2
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(30, A'length);
    D <= conv_std_logic_vector(2, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(32, output'length)) report "Error : 30+2 = " & integer'image(conv_integer(output)) & " instead of 32" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for 30+2" severity warning;
    
    -- test -50+100 (no V)
	-- C = 
	-- V = 
	-- S = 
	-- Z = 
    A <= conv_std_logic_vector(-50, A'length);
    D <= conv_std_logic_vector(100, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(50, output'length)) report "Error : -50+100 = " & integer'image(conv_integer(output)) & " instead of 50" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for -50+100" severity warning;
   
    -- test -19+(-7) (no V)
	-- C = 0
	-- V = 0
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(-19, A'length);
    D <= conv_std_logic_vector(-7, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-26, output'length)) report "Error : -19+(-7) = " & integer'image(conv_integer(output)) & " instead of -26" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for -19+(-7)" severity warning;
    
    -- test 255 + 4 (V and C should be '1')
	-- C = 1
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(4, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(3, output'length)) report "Error : 255 + 4 = " & integer'image(conv_integer(output)) & " instead of 259" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for 255 + 4" severity warning;
    
    -- test 0 + 0 (V and C should be '1')
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    wait for 120 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : 0 + 0 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for 0 + 0" severity warning;
    
-------------------------------------------- Carry in = 1 -----------------------------------------------------------------------
    carry_in <= '1';
    
    -- test 2+6 (with carry_in <= '1')
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(2, A'length);
    D <= conv_std_logic_vector(6, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(9, output'length)) report "Error : 2 + 6 + 1 = " & integer'image(conv_integer(output)) & " instead of 8" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for 2+8+1" severity warning;

    -- test 127+1 (overflow) (with carry_in <= '1')
	-- C = 0
	-- V = 1
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(127, A'length);
    D <= conv_std_logic_vector(1, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-127, output'length)) report "Error : 127 + 1 + 1 = " & integer'image(conv_integer(output)) & " instead of -127" severity warning;
    assert(V = '1') report "Error                                     : V incorrect for 250+50+1" severity warning;

	-- test 30 + 2 (with carry_in <= '1')
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(30, A'length);
    D <= conv_std_logic_vector(2, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(33, output'length)) report "Error : 30 + 2 + 1 = " & integer'image(conv_integer(output)) & " instead of 32" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for 30+2+1" severity warning;
    
    -- test -50+100 (no V) (with carry_in <= '1')
	-- C = 
	-- V = 
	-- S = 
	-- Z = 
    A <= conv_std_logic_vector(-50, A'length);
    D <= conv_std_logic_vector(100, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(51, output'length)) report "Error : -50 + 100 + 1 = " & integer'image(conv_integer(output)) & " instead of 50" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for -50+100+1" severity warning;
   
    -- test -19+(-7) (no V) (with carry_in <= '1')
	-- C = 0
	-- V = 0
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(-19, A'length);
    D <= conv_std_logic_vector(-7, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-25, output'length)) report "Error : -19 + (-7) + 1 = " & integer'image(conv_integer(output)) & " instead of -26" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for -19+(-7)+1" severity warning;
    
    -- test 255 + 4 (V and C should be '1') (with carry_in <= '1')
	-- C = 1
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(4, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(4, output'length)) report "Error : 255 + 4 + 1 = " & integer'image(conv_integer(output)) & " instead of 260" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for 255 + 4 + 1" severity warning;
    
    -- test -1 + 0 (V and C should be '1')
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(-1, A'length);
    D <= conv_std_logic_vector(0, D'length);
    wait for 120 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : -1 + 0 + 1 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
    assert(V = '0') report "Error                                    : V incorrect for -1 + 0 + 1" severity warning;
    

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	SUB FUNCTION
	sel <= "0001";

	carry_in <= '0';
	
	-- test 4-4
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 1
    A <= conv_std_logic_vector(4, A'length);
    D <= conv_std_logic_vector(4, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : 4 - 4 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for -2-8" severity warning;
	
	-- test -2-6
	-- C = 0
	-- V = 0
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(-2, A'length);
    D <= conv_std_logic_vector(6, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-8, output'length)) report "Error : -2-6 = " & integer'image(conv_integer(output)) & " instead of -8" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for -2-8" severity warning;
    
    -- test 50-6
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(50, A'length);
    D <= conv_std_logic_vector(6, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(44, output'length)) report "Error : 50-6 = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for 50-6" severity warning;

	-- test 3-128
	-- C = 0
	-- V = 1
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(128, D'length);
    wait for 40 ns;
--    assert(output = conv_std_logic_vector(44, output'length)) report "Error : 50-6 = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for 50-6" severity warning;

	-- test 3-7
	-- C = 0
	-- V = 1
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(-128, A'length);
    D <= conv_std_logic_vector(3, D'length);
    wait for 120 ns;
--    assert(output = conv_std_logic_vector(125, output'length)) report "Error : -128-3 = " & integer'image(conv_integer(output)) & " instead of 125" severity warning;
    assert(V = '1') report "Error                                   : overflow incorrect for -128-3" severity warning;
    
----------------------------------------------- Carry-in = 1 ------------------------------------------------

	-- test -2-6
	-- C = 0
	-- V = 0
	-- S = 1
	-- Z = 0
--    A <= conv_std_logic_vector(-2, A'length);
--    D <= conv_std_logic_vector(6, D'length);
--    carry_in <= '1';
--    wait for 40 ns;
--    assert(output = conv_std_logic_vector(-7, output'length)) report "Error : -2-6 = " & integer'image(conv_integer(output)) & " instead of -8" severity warning;
--    assert(V = '0') report "Error                                   : overflow incorrect for -2-8" severity warning;
    
	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	COMPARE FUNCTION
	sel <= "0010";

	-- test -2-6
	-- C = 0
	-- V = 0
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(-2, A'length);
    D <= conv_std_logic_vector(6, D'length);
    carry_in <= '0';
    wait for 40 ns;
--    assert(output = conv_std_logic_vector(-8, output'length)) report "Error : -2-6 = " & integer'image(conv_integer(output)) & " instead of -8" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for -2-8" severity warning;
    
    -- test 50-6
	-- C = 0
	-- V = 0
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(50, A'length);
    D <= conv_std_logic_vector(6, D'length);
    wait for 40 ns;
--    assert(output = conv_std_logic_vector(44, output'length)) report "Error : 50-6 = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for 50-6" severity warning;

	-- test 3-128
	-- C = 0
	-- V = 1
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(128, D'length);
    wait for 40 ns;
--    assert(output = conv_std_logic_vector(44, output'length)) report "Error : 50-6 = " & integer'image(conv_integer(output)) & " instead of 44" severity warning;
    assert(V = '0') report "Error                                   : overflow incorrect for 50-6" severity warning;

	-- test 3-7
	-- C = 0
	-- V = 1
	-- S = 0
	-- Z = 0
    A <= conv_std_logic_vector(-128, A'length);
    D <= conv_std_logic_vector(3, D'length);
    wait for 120 ns;
--    assert(output = conv_std_logic_vector(125, output'length)) report "Error : -128-3 = " & integer'image(conv_integer(output)) & " instead of 125" severity warning;
    assert(V = '1') report "Error                                   : overflow incorrect for -128-3" severity warning;
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	AND FUNCTION
	sel <= "0011";

	-- test 240 and 15
	-- S = 0
	-- Z = 1
    A <= conv_std_logic_vector(240, A'length);
    D <= conv_std_logic_vector(15, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : 240 and 15 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
    assert(S = '0') report "Error                                    : S incorrect for 240 and 15" severity warning;
    assert(Z = '1') report "Error                                    : Z incorrect for 240 and 15" severity warning;

    -- test 255 and 1
    -- S = 0
    -- Z = 0
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(1, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(1, output'length)) report "Error : 255 and 1 = " & integer'image(conv_integer(output)) & " instead of 1" severity warning;
    assert(S = '0') report "Error                                    : S incorrect for 255 and 1" severity warning;
    assert(Z = '0') report "Error                                    : Z incorrect for 255 and 1" severity warning;
    
    -- test 255 and 128
    -- S = 1
    -- Z = 0
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(128, D'length);
    wait for 120 ns;
    assert(output = conv_std_logic_vector(128, output'length)) report "Error : 255 and 128 = " & integer'image(conv_integer(output)) & " instead of 128" severity warning;
    assert(S = '1') report "Error                                    : S incorrect for 255 and 1" severity warning;
    assert(Z = '0') report "Error                                    : Z incorrect for 255 and 1" severity warning;
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	OR FUNCTION					DONE
	sel <= "0100";
	
	-- test 240 or 15 = "1111 1111" = 255
	-- S = 1
	-- Z = 0
    A <= conv_std_logic_vector(240, A'length);
    D <= conv_std_logic_vector(15, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(255, output'length)) report "Error : 240 or 15 = " & integer'image(conv_integer(output)) & " instead of 255" severity warning;
    assert(S = '1') report "Error                                    : S incorrect for 240 and 15" severity warning;
    assert(Z = '0') report "Error                                    : Z incorrect for 240 and 15" severity warning;

    -- test 15 or 85 = "0101 1111" = 95
    -- S = 0
    -- Z = 0
    A <= conv_std_logic_vector(15, A'length);
    D <= conv_std_logic_vector(85, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(95, output'length)) report "Error : 15 or 85 = " & integer'image(conv_integer(output)) & " instead of 95" severity warning;
    assert(S = '0') report "Error                                    : S incorrect for 240 and 15" severity warning;
    assert(Z = '0') report "Error                                    : Z incorrect for 240 and 15" severity warning;
    
    -- test 0 or 0
    -- S = 0
    -- Z = 1
    A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    wait for 120 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : 0 or 0 = " & integer'image(conv_integer(output)) & " instead of 0" severity warning;
    assert(S = '0') report "Error                                    : S incorrect for 0 or 0" severity warning;
    assert(Z = '1') report "Error                                    : Z incorrect for 0 or 0" severity warning;
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	XOR FUNCTION				DONE
	sel <= "0101";
	
	-- test 170 xor 85 = "1111 1111"
    -- S = 1
    -- Z = 0
    A <= conv_std_logic_vector(175, A'length);
    D <= conv_std_logic_vector(85, D'length);
    wait for 40 ns;
    
    -- test 170 or 255 = "0101 0101"
    -- S = 0
    -- Z = 0
    A <= conv_std_logic_vector(170, A'length);
    D <= conv_std_logic_vector(255, D'length);
    wait for 40 ns;
	
	-- test 255 or 255 = "0000 0000"
    -- S = 0
    -- Z = 1
    A <= conv_std_logic_vector(255, A'length);
    D <= conv_std_logic_vector(255, D'length);
    wait for 120 ns;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	LSL_INPUT1 FUNCTION
	sel <= "0110";
	
--	test "0000 0000"
--	C = 0
--	Z = 1
--	S = 0
	A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    wait for 40 ns;
	
--	test "0001 1010"
--	C = 0
--	Z = 0
--	S = 0
	A <= "00011010";
    wait for 40 ns;
    	
--	test "1001 1010"
--	C = 1
--	Z = 0
--	S = 0
	A <= "10011010";
    wait for 40 ns;
    	
--	test "1101 1010"
--	C = 1
--	Z = 0
--	S = 1
	A <= "11011010";
    wait for 120 ns;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	LSR_INPUT1 FUNCTION
	sel <= "0111";
	
--	test "0000 0000"
--	C = 0
--	Z = 1
--	S = 0
	A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    carry_in <= '0';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 0000" severity warning;

--	test "0000 0000" with carry in
--	C = 0
--	Z = 0
--	S = 0
	A <= conv_std_logic_vector(0, A'length);
    carry_in <= '1';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 0000" severity warning;
    
--	test "0001 1010"
--	C = 0
--	Z = 0
--	S = 0
	A <= "00011011";
	carry_in <= '0';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(13, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 1101" severity warning;
    assert(C = '1') report "Error : " & integer'image(conv_integer(C)) & " instead of 1" severity warning;
    
--	test "1111 0000"
--	C = 1
--	Z = 0
--	S = 1
	A <= "00011010";
    wait for 120 ns;
    assert(output = conv_std_logic_vector(13, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 1101" severity warning;
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	ROTATE_LEFT_INPUT1 FUNCTION 
	sel <= "1000";
	
	--	test "0000 0000"
--	C = 0
--	Z = 1
--	S = 0
	A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    carry_in <= '0';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 0000" severity warning;
	
--	test "0000 0000"
--	C = 0
--	Z = 0
--	S = 0
	A <= "00000000";
    carry_in <= '1';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(1, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 0001" severity warning;
    	
--	test "1001 1010"
--	C = 1
--	Z = 0
--	S = 0
	A <= "10011010";
    carry_in <= '1';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(53, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0011 0101" severity warning;
    	
--	test "1101 1010"
--	C = 1
--	Z = 0
--	S = 1
	A <= "11011010";
    carry_in <= '0';
    wait for 120 ns;
    assert(output = conv_std_logic_vector(180, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 1011 0100" severity warning;
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	ROTATE_RIGHT_INPUT1 FUNCTION
	sel <= "1001";
	
--	test "0000 0000"
--	C = 0
--	Z = 1
--	S = 0
	A <= conv_std_logic_vector(0, A'length);
    D <= conv_std_logic_vector(0, D'length);
    carry_in <= '0';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 0000" severity warning;

--	test "0000 0000" with carry in
--	C = 0
--	Z = 0
--	S = 0
	A <= conv_std_logic_vector(0, A'length);
    carry_in <= '1';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-128, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 1000 0000" severity warning;
    
--	test "0001 1010"
--	C = 0
--	Z = 0
--	S = 0
	A <= "00011011";
	carry_in <= '0';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(13, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 1101" severity warning;
    assert(C = '1') report "Error : " & integer'image(conv_integer(C)) & " instead of 1" severity warning;
    
--	test "0001 1010"
--	C = 0
--	Z = 0
--	S = 1
	A <= "00011011";
	carry_in <= '1';
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-115, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 1000 1101" severity warning;
    assert(C = '1') report "Error : " & integer'image(conv_integer(C)) & " instead of 1" severity warning;
    
--	test "1111 0000"
--	C = 1
--	Z = 0
--	S = 1
	A <= "00011010";
	carry_in <= '0';
    wait for 120 ns;
    assert(output = conv_std_logic_vector(13, output'length)) report "Error : " & integer'image(conv_integer(output)) & " instead of 0000 1101" severity warning;	
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	DEC_ACC FUNCTION
	sel <= "1010";
	
-- 	test A = 1: A = A - 1 = 0
--	S = 0
--	Z = 1
    A <= conv_std_logic_vector(1, A'length);
    D <= conv_std_logic_vector(0, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, A'length)) report "Error : A = " & integer'image(conv_integer(A)) & " instead of 0" severity warning;
	  	 
-- 	test A = 0: A = A - 1 = -1
--	S = 1
--	Z = 0
    A <= conv_std_logic_vector(0, A'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(-1, A'length)) report "Error : A = " & integer'image(conv_integer(A)) & " instead of -1" severity warning;
    
-- 	test A = 2: A = A - 1 = 1
--	S = 0
--	Z = 0
    A <= conv_std_logic_vector(2, A'length);
    wait for 120 ns;
    assert(output = conv_std_logic_vector(1, A'length)) report "Error : A = " & integer'image(conv_integer(A)) & " instead of 1" severity warning;
	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 	INC_ACC FUNCTION
	sel <= "1011";
 	
-- 	test A = -1: A = A + 1 = 0
--	S = 0
--	Z = 1
    A <= conv_std_logic_vector(-1, A'length);
    D <= conv_std_logic_vector(0, D'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(0, A'length)) report "Error : A = " & integer'image(conv_integer(A)) & " instead of 0" severity warning;
	  	 
-- 	test A = 0: A = A + 1 = 1
--	S = 0
--	Z = 0
    A <= conv_std_logic_vector(0, A'length);
    wait for 40 ns;
    assert(output = conv_std_logic_vector(1, A'length)) report "Error : A = " & integer'image(conv_integer(A)) & " instead of 1" severity warning;
    
-- 	test A = -2: A = A + 1 = -1
--	S = 1
--	Z = 0
    A <= conv_std_logic_vector(-2, A'length);
    wait for 120 ns;
    assert(output = conv_std_logic_vector(-1, A'length)) report "Error : A = " & integer'image(conv_integer(A)) & " instead of -1" severity warning;
    
    wait;

  end process;
end TB;