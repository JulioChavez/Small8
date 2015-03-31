-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic (
		WIDTH : positive := 8
	);
	port (
		A 			: in  std_logic_vector(WIDTH-1 downto 0);
		D	 		: in  std_logic_vector(WIDTH-1 downto 0);
		carry_in	: in  std_logic;
		sel 		: in  std_logic_vector(3 downto 0);
		output 		: out std_logic_vector(WIDTH-1 downto 0);
		ALU_A_mult_output	: out std_logic_vector(WIDTH-1 downto 0);
		ALU_D_mult_output	: out std_logic_vector(WIDTH-1 downto 0);
		V 			: out std_logic;
		C			: out std_logic;
		S			: out std_logic;
		Z			: out std_logic
	);
end alu;

architecture BHV of alu is

	constant C_ADD		 			: std_logic_vector(3 downto 0) := "0000";
	constant C_SUB					: std_logic_vector(3 downto 0) := "0001";
	constant C_COMPARE				: std_logic_vector(3 downto 0) := "0010";
	constant C_AND  				: std_logic_vector(3 downto 0) := "0011";
	constant C_OR 					: std_logic_vector(3 downto 0) := "0100";
	constant C_XOR 					: std_logic_vector(3 downto 0) := "0101";
	constant C_LSL_INPUT1			: std_logic_vector(3 downto 0) := "0110";
	constant C_LSR_INPUT1			: std_logic_vector(3 downto 0) := "0111";
	constant C_ROTATE_LEFT_INPUT1	: std_logic_vector(3 downto 0) := "1000";
	constant C_ROTATE_RIGHT_INPUT1 	: std_logic_vector(3 downto 0) := "1001";
	constant C_DEC_ACC				: std_logic_vector(3 downto 0) := "1010";
	constant C_INC_ACC				: std_logic_vector(3 downto 0) := "1011";
	constant C_MULT					: std_logic_vector(3 downto 0) := "1100";
	constant ONE					: std_logic_vector(7 downto 0) := "00000001";
	constant TWO					: std_logic_vector(7 downto 0) := "00000010";
	constant ZERO					: std_logic_vector(7 downto 0) := "0000000000000000";
	signal   temp_add_signal		: std_logic_vector(WIDTH downto 0);
	signal   temp_sub_signal		: std_logic_vector(WIDTH downto 0);
	
begin
	process(A, D, carry_in, sel)
	
		variable temp_add : unsigned(WIDTH downto 0);
		variable temp_sub : signed(WIDTH downto 0);
		variable temp_compare : signed(WIDTH downto 0);
		variable temp_dec_A : unsigned(WIDTH-1 downto 0);
		variable temp_inc_A : unsigned(WIDTH-1 downto 0);
		variable temp_mult	: unsigned(2*WIDTH-1 downto 0);
		
		
	begin
		case sel is
		
------------------------------------------------------------------------------------------------------------
		
		-- A + D
			when C_ADD => 
				-- Reset flags
				C 		<= '0';
				S  		<= '0';
				V 	    <= '0';
				Z		<= '0';
				temp_add	:= (others => '0');
				
				if(carry_in = '1') then
					temp_add := resize("0" & unsigned(A),WIDTH+1) + resize("0" + unsigned(D),WIDTH+1) + resize(unsigned(ONE),WIDTH+1);
				else
					temp_add := resize(unsigned(A),WIDTH+1) + resize(unsigned(D),WIDTH+1);
				end if;
				output <= std_logic_vector(temp_add((WIDTH - 1) downto 0));
				ALU_A_mult_output <= ZERO;
				ALU_D_mult_output <= ZERO;
				
				-- Assign Carry (C) and Sign (S)
				C <= std_logic(temp_add(WIDTH));
				S <= std_logic(temp_add(WIDTH-1));
				
				-- Check for Overflow (V)
				V <= temp_add(WIDTH) xor temp_add(WIDTH-1) xor D(WIDTH-1) xor A(WIDTH-1);
				
				-- Check if Zero (Z)
				if (temp_add = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				temp_add_signal <= std_logic_vector(temp_add);
		
------------------------------------------------------------------------------------------------------------
		
		-- A - D + C
			when C_SUB => 

				-- Reset flags
				C 		<= '0';
				S  		<= '0';
				V 		<= '0';
				Z		<= '0';
				
--				temp_sub := signed('0' & A) + signed(not('0' & D)) + 1 + carry_in;
				if(carry_in = '1') then
					temp_sub := signed('0' & A) + signed(not('0' & D)) + signed('0' & TWO);
				else
					temp_sub := signed('0' & A) + signed(not('0' & D)) + 1;
				end if;
				
				output <= std_logic_vector(temp_sub(WIDTH-1 downto 0));
				ALU_A_mult_output <= ZERO;
				ALU_D_mult_output <= ZERO;
				
				-- Assign Carry (C) and Sign (S)
				C <= std_logic(temp_sub(WIDTH));
				S <= std_logic(temp_sub(WIDTH-1));
				
				-- Check for Overflow (V)
				V <= temp_sub(WIDTH) xor temp_sub(WIDTH-1) xor D(WIDTH-1) xor A(WIDTH-1);
				
				-- Check if Zero (Z)
				if (temp_sub = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				temp_sub_signal <= std_logic_vector(temp_sub);
				
		
------------------------------------------------------------------------------------------------------------
		
		-- Compare A and B, but only update flags
			when C_COMPARE =>
				if(carry_in = '1') then
					temp_compare := signed('0' & A) + signed(not('0' & D)) + signed('0' & TWO);
				else
					temp_compare := signed('0' & A) + signed(not('0' & D)) + 1;
				end if;
				
				-- Assign Carry (C) and Sign (S)
				C <= temp_compare(WIDTH);
				S <= std_logic(temp_compare(WIDTH-1));
				
				-- Check for Overflow (V)
				V <= temp_sub(WIDTH) xor temp_sub(WIDTH-1) xor D(WIDTH-1) xor A(WIDTH-1);
				
				-- Check if Zero (Z)
				if (temp_compare = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- A and D
			when C_AND =>
				output <= A and D;
				
				-- Assign Sign (S)
				S <= A(WIDTH-1) and D(WIDTH-1);
				
				-- Check if Zero (Z)
				if (unsigned(A and D) = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- A or D
			when C_OR =>
				output <= A or D;
				
				-- Assign Sign (S)
				S <= A(WIDTH-1) or D(WIDTH-1);
				
				-- Check if Zero (Z)
				if (unsigned(A or D) = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- A xor D
			when C_XOR => 
				output <= A xor D;
				
				-- Assign Sign (S)
				S <= A(WIDTH-1) xor D(WIDTH-1);
				
				-- Check if Zero (Z)
				if (unsigned(A xor D) = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- Shift A left by 1 bit
			when C_LSL_INPUT1 => 
				output <= A((WIDTH-2) downto 0) & "0";
				
				-- Assign Carry (C) and Sign (S)
				C <= A(WIDTH-1);
				S <= A(WIDTH-2);
				
				-- Check if Zero (Z)
				if (unsigned(A((WIDTH-2) downto 0) & "0") = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- Shift A right by 1 bit
			when C_LSR_INPUT1 => 
				output <= "0" & A((WIDTH-1) downto 1);
				
				-- Assign Carry (C) and Sign (S)
				C <= A(0);
				S <= '0';
				
				-- Check if Zero (Z)
				if (unsigned("0" & A((WIDTH-1) downto 1)) = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- Rotate A left by 1 bit through Carry
			when C_ROTATE_LEFT_INPUT1 => 
				output <= A((WIDTH - 2) downto 0) & carry_in;
				
				-- Assign Carry (C) and Sign (S)
				C <= A(WIDTH-1);
				S <= A(WIDTH-2);
				
				-- Check if Zero (Z)
				if (unsigned(A((WIDTH-2) downto 0) & A(WIDTH-1)) = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- Rotate A right by 1 bit through Carry
			when C_ROTATE_RIGHT_INPUT1 => 
				output <= carry_in & A((WIDTH-1) downto 1);
				
				-- Assign Carry (C) and Sign (S)
				C <= A(0);
				S <= '0';
				
				-- Check if Zero (Z)
				if (unsigned(A(0) & A((WIDTH-1) downto 1)) = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- Decrease A by 1
			when C_DEC_ACC =>
				temp_dec_A := resize((unsigned(A) - 1), WIDTH);
				output <= std_logic_vector(temp_dec_A);
				
				-- Assign Sign (S)
				S <= temp_dec_A(WIDTH-1);
				
				-- Check if Zero (Z)
				if (temp_dec_A = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
			
		
------------------------------------------------------------------------------------------------------------
		
		-- Increase A by 1
			when C_INC_ACC =>
				temp_inc_A := resize((unsigned(A) + 1), WIDTH);
				output <= std_logic_vector(temp_inc_A);
				
				-- Assign Sign (S)
				S <= temp_inc_A(WIDTH-1);
				
				-- Check if Zero (Z)
				if (temp_inc_A = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;
				
		
------------------------------------------------------------------------------------------------------------
		
		-- A * D
			when C_MULT =>
				temp_mult := unsigned(A)*unsigned(D);
				ALU_A_mult_output <= std_logic_vector(temp_mult(2*WIDTH-1 downto WIDTH));
				ALU_D_mult_output <= std_logic_vector(temp_mult(WIDTH-1 downto 0));
				
				-- Assign Sign (S)
				S <= temp_mult(2*WIDTH-1);
				
				-- Check if Zero (Z)
				if (temp_mult = 0) then
					Z <= '1';
				else
					Z <= '0';
				end if;

------------------------------------------------------------------------------------------------------------
				
			when others =>
				null;
		
		end case;
		
	end process;
	
end BHV;