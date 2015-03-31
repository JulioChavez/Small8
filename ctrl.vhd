-- Julio Chavez
-- University of Florida

-- Small8 Microprocessor
-- Internal Architecture Controller

library ieee;
use ieee.std_logic_1164.all;

entity ctrl is
	generic(
		width : positive := 8);
	port(
		clk       		: in  std_logic;
		rst       		: in  std_logic;
		address_bus		: in  std_logic_vector(15 downto 0);
		IR_output		: in  std_logic_vector(7 downto 0);
		C				: in  std_logic;
		V				: in  std_logic;
		S				: in  std_logic;
		Z				: in  std_logic;

		-- Enables decide who is going to drive the internal bus in the internal architecture data path
		CPU_bus_in_en 	: out std_logic;
		CPU_bus_out_en 	: out std_logic;
		IR_en   : out  std_logic;
		PC_H_en : out  std_logic;
		PC_L_en : out  std_logic;
		D_en    : out  std_logic;
		A_en    : out  std_logic;
		SP_H_en : out  std_logic;
		SP_L_en : out  std_logic;
		X_H_en  : out  std_logic;
		X_L_en  : out  std_logic;
		C_en    : out  std_logic;
		V_en    : out  std_logic;
		S_en    : out  std_logic;
		Z_en    : out  std_logic;
		ALU_en  : out  std_logic;
		TEMP_1_en : out  std_logic;
		TEMP_2_en : out  std_logic;
		
		-- Load signals for the registers
		AR_H_load : out  std_logic;
		AR_L_load : out  std_logic;
		IR_load   : out  std_logic;
		PC_H_load : out  std_logic;
		PC_L_load : out  std_logic;
		PC_addr_load : out  std_logic;
		D_load    : out  std_logic;
		A_load    : out  std_logic;
		SP_H_load : out  std_logic;
		SP_L_load : out  std_logic;
		X_H_load  : out  std_logic;
		X_L_load  : out  std_logic;
		X_b_load  : out  std_logic;
		C_load    : out  std_logic;
		V_load    : out  std_logic;
		S_load    : out  std_logic;
		Z_load    : out  std_logic;
		ALU_load  : out  std_logic;
		TEMP_1_load : out  std_logic;
		TEMP_2_load : out  std_logic;
		input0_input_load   : out std_logic;
		input1_input_load   : out std_logic;
		input0_data_load    : out std_logic;
		input1_data_load    : out std_logic;

		-- Select for the ALU
		ALU_sel : out  std_logic_vector(3 downto 0);
		ALU_mult_sel : out std_logic;
		
		-- Individual resets for the status registers
		C_rst	: out  std_logic;
		V_rst	: out  std_logic;
		S_rst	: out  std_logic;
		Z_rst	: out  std_logic;
		C_set	: out  std_logic;
		V_set	: out  std_logic;
		S_set	: out  std_logic;
		Z_set	: out  std_logic;
		
		-- Increments the PC register output by 1
		PC_inc	: out  std_logic;
		A_inc	: out  std_logic;
		X_inc	: out  std_logic;
		SP_inc	: out  std_logic;
		
		-- Decrements the register's output by 1
		A_dec	: out  std_logic;
		X_dec	: out  std_logic;
		SP_dec	: out  std_logic;
		
		-- Decides what drives the address bus
		
	    AR_addr_en	: out  std_logic;
	    SP_addr_en	: out  std_logic;
	    X_addr_en	: out  std_logic;
	    PC_addr_en	: out  std_logic;
		X_indexed_addr_en : out  std_logic;
		
		-- Goes to the wren input of the RAM
		-- Write = '1', Read = '0'
		RD, WR 	: out std_logic;
		output0_read : out std_logic;
		output1_read : out std_logic
	);
end ctrl;

architecture BHV of ctrl is
	
	-- Constants for the ALU
	constant C_ADD		 			: std_logic_vector(3 downto 0) := "0000";
	constant C_SUB					: std_logic_vector(3 downto 0) := "0001";
	constant C_CMPR					: std_logic_vector(3 downto 0) := "0010";
	constant C_AND  				: std_logic_vector(3 downto 0) := "0011";
	constant C_OR 					: std_logic_vector(3 downto 0) := "0100";
	constant C_XOR 					: std_logic_vector(3 downto 0) := "0101";
	constant C_SLRL					: std_logic_vector(3 downto 0) := "0110";
	constant C_SRRL					: std_logic_vector(3 downto 0) := "0111";
	constant C_ROLC					: std_logic_vector(3 downto 0) := "1000";
	constant C_RORC 				: std_logic_vector(3 downto 0) := "1001";
	constant C_DEC_ACC				: std_logic_vector(3 downto 0) := "1010";
	constant C_INC_ACC				: std_logic_vector(3 downto 0) := "1011";
	constant C_MULT					: std_logic_vector(3 downto 0) := "1100";
	constant ONE					: std_logic_vector(7 downto 0) := "00000001";
	constant TWO					: std_logic_vector(7 downto 0) := "00000010";
	
	-- Constants for the opcode fetch cycle
	constant OP_LDAI		: std_logic_vector(7 downto 0) := x"84";
	constant OP_LDAA		: std_logic_vector(7 downto 0) := x"88";
	constant OP_LDAD		: std_logic_vector(7 downto 0) := x"81";
	
	constant OP_STAA		: std_logic_vector(7 downto 0) := x"F6";
	constant OP_STAR		: std_logic_vector(7 downto 0) := x"F1";
	
	constant OP_ADCR		: std_logic_vector(7 downto 0) := x"01";
	constant OP_SBCR		: std_logic_vector(7 downto 0) := x"11";
	constant OP_CMPR		: std_logic_vector(7 downto 0) := x"91";
	
	constant OP_ANDR		: std_logic_vector(7 downto 0) := x"21";
	constant OP_ORR			: std_logic_vector(7 downto 0) := x"31";
	constant OP_XORR		: std_logic_vector(7 downto 0) := x"41";
	
	constant OP_SLRL		: std_logic_vector(7 downto 0) := x"51";
	constant OP_SRRL		: std_logic_vector(7 downto 0) := x"61";
	
	constant OP_ROLC		: std_logic_vector(7 downto 0) := x"52";
	constant OP_RORC		: std_logic_vector(7 downto 0) := x"62";
	
	constant OP_BCCA		: std_logic_vector(7 downto 0) := x"B0";
	constant OP_BCSA		: std_logic_vector(7 downto 0) := x"B1";
	constant OP_BEQA		: std_logic_vector(7 downto 0) := x"B2";
	constant OP_BMIA		: std_logic_vector(7 downto 0) := x"B3";
	constant OP_BNEA		: std_logic_vector(7 downto 0) := x"B4";
	constant OP_BPLA		: std_logic_vector(7 downto 0) := x"B5";
	constant OP_BVCA		: std_logic_vector(7 downto 0) := x"B6";
	constant OP_BVSA		: std_logic_vector(7 downto 0) := x"B7";
	
	constant OP_DECA		: std_logic_vector(7 downto 0) := x"FB";
	constant OP_INCA		: std_logic_vector(7 downto 0) := x"FA";
	
	constant OP_SETC		: std_logic_vector(7 downto 0) := x"F8";
	constant OP_CLRC		: std_logic_vector(7 downto 0) := x"F9";
	
	constant OP_LDSI		: std_logic_vector(7 downto 0) := x"89";
	constant OP_CALL		: std_logic_vector(7 downto 0) := x"C8";
	constant OP_RET			: std_logic_vector(7 downto 0) := x"C0";
	
	constant OP_LDXI		: std_logic_vector(7 downto 0) := x"8A";
	constant OP_LDAA_INDX	: std_logic_vector(7 downto 0) := x"BC";
	constant OP_STAA_INDX	: std_logic_vector(7 downto 0) := x"EC";
	
	constant OP_INCX		: std_logic_vector(7 downto 0) := x"FC";
	constant OP_DECX		: std_logic_vector(7 downto 0) := x"FD";
	
	constant OP_MULT		: std_logic_vector(7 downto 0) := x"AD";
	
	type STATE_TYPE is (
		UNKNOWN_STATE, 
		START, 
		DECODE, 
		LDAI, 
		LDAA, 
		LDAD,
		 
		STAA, 
		STAR, 
		
		ADCR, ADCR2, 
		SBCR, 
		CMPR, 
		ANDR, 
		ORR, 
		XORR, 
		SLRL,
		SRRL, 
		ROLC, 
		RORC, 
		BCCA, 
		BCSA, 
		BEQA, 
		BMIA, 
		BNEA, 
		BPLA, 
		BVCA, 
		BVSA, 
		DECA, 
		INCA, 
		SETC, CLRC, LDSI, CALL, RET, LDXI, LDAA_INDX, STAA_INDX, INCX, DECX, 
		LDAI2, LDAI3, LDAA2, LDAA3, LDAA4, LDAA5, LDAA6, LDAD2, LDAD3, STAA2, STAA3, STAA4, STAA5, STAA6, STAA7, 
		STAR2, STAR3, BCCA2, BCCA3, BCCA4, BCCA5, BCCA6, BCSA2, BCSA3, BCSA4, BCSA5,
		BEQA2, BEQA3, BEQA4,BEQA5, BMIA2, BMIA3, BMIA4, BMIA5,
		BNEA2, BNEA3, BNEA4, BNEA5, BPLA2, BPLA3, BPLA4, BPLA5, 
		BVCA2, BVCA3, BVCA4, BVCA5, BVSA2, BVSA3, BVSA4, BVSA5, 
		LDSI2, LDSI3, LDSI4, LDSI5, LDSI6, LDSI7, CALL2, CALL3, CALL4, CALL5, CALL6, CALL7, CALL8, CALL9, CALL10, CALL11, CALL12, CALL13, 
		RET2, RET3, RET4, RET5, RET6, RET7, RET8, RET9, RET10, RET11, RET12,
		LDXI2, LDXI3, LDXI4, LDAA_INDX2, LDAA_INDX3, LDAA_INDX4, LDAA_INDX5,LDAA_INDX6,LDAA_INDX7, MULT, MULT2, MULT3, MULT4, MULT5,
		FETCH, FETCH_WITH_NO_PC_INC, BRANCH_TAKEN);
	signal state 		: STATE_TYPE;
	signal next_state	: STATE_TYPE;
	
begin                                   -- BHV
	
	process(clk, rst)
	begin
		if (rst = '1') then
			state	<= START;
			
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;

	process(IR_output, state)
	begin

		-- Assigning default values to all of the outputs.
		-- The final value is then modified by the corresponding states in the FSM.
		IR_en   <= '0';
		PC_H_en <= '0';
		PC_L_en <= '0';
		D_en    <= '0';
		A_en    <= '0';
		SP_H_en <= '0';
		SP_L_en <= '0';
		X_H_en  <= '0';
		X_L_en  <= '0';
		C_en    <= '0';
		V_en    <= '0';
		S_en    <= '0';
		Z_en    <= '0';
		ALU_en  <= '0';
		TEMP_1_en <= '0';
		TEMP_2_en <= '0';
		AR_H_load <= '0';
		AR_L_load <= '0';
		IR_load   <= '0';
		PC_H_load <= '0';
		PC_L_load <= '0';
		PC_addr_load <= '0';
		D_load    <= '0';
		A_load    <= '0';
		SP_H_load <= '0';
		SP_L_load <= '0';
		X_H_load  <= '0';
		X_L_load  <= '0';
		X_b_load  <= '0';
		C_load    <= '0';
		V_load    <= '0';
		S_load    <= '0';
		Z_load    <= '0';
		ALU_load  <= '0';
		TEMP_1_load <= '0';
		TEMP_2_load <= '0';
		ALU_sel   <= "0000";
		ALU_mult_sel <= '0';
		input0_input_load <= '0';
		input1_input_load <= '0';
		input0_data_load <= '0';
		input1_data_load <= '0';
		C_rst <= '0';
		V_rst <= '0';
		S_rst <= '0';
		Z_rst <= '0';
		C_set <= '0';
		V_set <= '0';
		S_set <= '0';
		Z_set <= '0';
	  	
	  	CPU_bus_in_en	<= '0';
		CPU_bus_out_en <= '0';

		next_state <= state;		
		RD	<= '0';
		WR	<= '0';	
		output0_read <= '0';
		output1_read <= '0';
		
		PC_addr_en <= '0';
		AR_addr_en <= '0';
		SP_addr_en <= '0';
		X_addr_en  <= '0';
		X_indexed_addr_en <= '0';
		PC_inc <='0';
		A_inc <= '0';
		X_inc <= '0';
		SP_inc <= '0';
		A_dec <= '0';
		X_dec <= '0';
		SP_dec <= '0';

		case state is 
			
			-- Setup for an opcode fetch state
			when START =>	
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
--				IR_load	<= '1';
				next_state <= FETCH;
				
			when FETCH =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				IR_load	<= '1';
				PC_inc <= '1';
				next_state <= DECODE;
			
			when FETCH_WITH_NO_PC_INC =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				IR_load	<= '1';
				next_state <= DECODE;
----------------------------------------------------------------------------------------------------------------------------
			when DECODE =>
				
				-- Decoding the opcode that was stored on the IR register
				case IR_output is
					
					-- Requires to read from 3 address lines
					when OP_LDAI =>			-- Load Acc (Imm)
						next_state <= LDAI;
						
					when OP_LDAA =>			-- Load Acc (Abs)
						PC_inc <= '1';
						next_state <= LDAA;
						
					when OP_LDAD =>			-- Load Acc (RR)
						D_en <= '1';
						A_load <= '1';
						next_state <= LDAD;
						
					------------------------------
					
					-- Requires to read from 2 address lines
					
					when OP_STAA =>			-- Store Acc (Abs)
						next_state <= STAA;
						
					when OP_STAR =>			-- Store Acc (RR), D <-- (A)
						A_en <= '1';
						D_load <= '1';
						next_state <= STAR;
						
					------------------------------
					
					-- Requires to read from 1 address line
					
					when OP_ADCR =>			-- Add with Carry
						ALU_sel	<= C_ADD;
						ALU_load <= '1';
						C_load <= '1';
						V_load <= '1';
						S_load <= '1';
						Z_load <= '1';
						next_state <= ADCR;
						
					when OP_SBCR =>			-- Subtract with Carry
						next_state <= SBCR;
						
					when OP_CMPR =>			-- Compare
						next_state <= CMPR;
						
					----------------
					
					when OP_ANDR =>			-- AND
						ALU_sel <= C_AND;
						ALU_load <= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= ANDR;
						
					when OP_ORR	 =>			-- OR
						ALU_sel <= C_OR;
						ALU_load <= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= ORR;
						
					when OP_XORR =>			-- XOR
						ALU_sel <= C_XOR;
						ALU_load <= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= XORR;
						
					----------------
					
					when OP_SLRL =>			-- Shift Left Logical
						ALU_sel <= C_SLRL;
						ALU_load <= '1';
						C_load	<= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= SLRL;
						
					when OP_SRRL =>			-- Shift Right Logical
						ALU_sel <= C_SRRL;
						ALU_load <= '1';
						C_load	<= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= SRRL;
						
					----------------
					
					when OP_ROLC =>			-- Rotate Left through Carry
						ALU_sel <= C_ROLC;
						ALU_load <= '1';
						C_load	<= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= ROLC;
						
					when OP_RORC =>			-- Rotate Right through Carry
						ALU_sel <= C_RORC;
						ALU_load <= '1';
						C_load	<= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= RORC;
						
					------------------------------
					
					-- Requires to read from 3 address lines
					
					when OP_BCCA =>			-- Branch on /C (Inh)
						next_state <= BCCA;
						
					when OP_BCSA =>			-- Branch on C (Inh)
						next_state <= BCSA;
						
					when OP_BEQA =>			-- Branch on Z (Inh)	
						next_state <= BEQA;
						
					when OP_BMIA =>			-- Branch on S (Inh)
						next_state <= BMIA;
						
					when OP_BNEA =>			-- Branch on /Z (Inh)
						next_state <= BNEA;
						
					when OP_BPLA =>			-- Branch on /S (Inh)
						next_state <= BPLA;
						
					when OP_BVCA =>			-- Branch on /V (Inh)
						next_state <= BVCA;
						PC_inc 	<= '1';
						
					when OP_BVSA =>			-- Branch on V (Inh)
						next_state <= BVSA;
						
					------------------------------
					
					-- Requires to read from 1 address line
					
					when OP_DECA =>			-- Decrement A
						A_dec <= '1';
						ALU_sel <= C_DEC_ACC;
						S_load <= '1';
						Z_load <= '1';
						next_state <= DECA;
						
					when OP_INCA =>			-- Increment A
						A_inc <= '1';
						ALU_sel <= C_INC_ACC;
						S_load <= '1';
						Z_load <= '1';
						next_state <= INCA;
						
					----------------
					
					when OP_SETC =>			-- Set Carry Flag
						C_set <= '1';
						next_state <= SETC;
						
					when OP_CLRC =>			-- Clear Carry Flag
						C_rst <= '1';
						next_state <= CLRC;
						
					------------------------------
					
					-- Requires to read from 3 address lines
						
					when OP_LDSI =>			-- Load SP (Imm)
						next_state <= LDSI;
						
					when OP_CALL =>			-- Call
						next_state <= CALL;
					
					when OP_RET =>			-- Return
						next_state <= RET;
						
					------------------------------
					
					-- Requires to read from 2 address lines
					
					when OP_LDXI =>					-- Load X (Imm)
						next_state <= LDXI;
						
					when OP_LDAA_INDX =>			-- Load Acc (Indx)
						next_state <= LDAA_INDX;
						
					when OP_STAA_INDX =>			-- Store Acc (Indx)
						next_state <= STAA_INDX;
						
					------------------------------
					
					-- Requires to read from 1 address line
					
					when OP_INCX =>			-- Increase X
						X_inc <= '1';
						next_state <= INCX;
						
					when OP_DECX =>			-- Decrease X
						X_dec <= '1';
						next_state <= DECX;
					
					------------------------------
					
					when OP_MULT =>
						ALU_sel <= C_MULT;
						ALU_mult_sel <= '1';
						A_load <= '1';
						D_load <= '1';
						Z_load	<= '1';
						S_load	<= '1';
						next_state <= MULT;
						
					------------------------------
					
					when others =>
						next_state <= FETCH;
					
				end case;
----------------------------------------------------------------------------------------------------------------------------
			when LDAI =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
				A_load <= '1';
				
				PC_inc <= '1';
				next_state <= LDAI2;
			when LDAI2 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when LDAA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
				AR_L_load	<= '1';
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= LDAA2;
			when LDAA2 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
				AR_H_load	<= '1';
				
--				AR_addr_en <= '1';
				next_state <= LDAA3;
			when LDAA3 =>
				AR_addr_en <= '1';
			
				next_state <= LDAA4;
			when LDAA4 =>
				AR_addr_en <= '1';
				if (address_bus = x"FFFE") then
					input0_input_load <= '1';
				elsif (address_bus = x"FFFF") then
					input1_input_load <= '1';
				end if;
				next_state <= LDAA5;
			when LDAA5 =>
				CPU_bus_in_en <= '1';
--				RD	<= '1';
				A_load <= '1';
				
				AR_addr_en <= '1';
				if(address_bus = x"FFFE") then
					output0_read <= '1';
				elsif(address_bus = x"FFFF") then
					output1_read <= '1';
				else
					RD <= '1';
				end if;
				next_state <= LDAA6;
			when LDAA6 =>
--				next_state <= LDAA7;
--			when LDAA7 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when LDAD =>
				next_state <= LDAD2;
			when LDAD2 => 			-- Potentially remove this state
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when STAA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
				AR_L_load <= '1';
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= STAA2;
			when STAA2 =>
				next_state <= STAA3;
			when STAA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
				AR_H_load <= '1';
				PC_inc <= '1';
--				A_en <= '1';
--				CPU_bus_out_en <= '1';
--				WR	<= '1';
--						
--				AR_addr_en <= '1';
				next_state <= STAA4;
				
			when STAA4 =>
				AR_addr_en <= '1';
				next_state <= STAA5;
			when STAA5 =>
				A_en <= '1';
				CPU_bus_out_en <= '1';
				AR_addr_en <= '1';
				if (address_bus = x"FFFE") then
					input0_data_load <= '1';
				elsif (address_bus = x"FFFF") then
					input1_data_load <= '1';
				else
					WR <= '1';
				end if;
				
				next_state <= STAA6;
			when STAA6 =>		 -- Debug state, used to verify that address at AR was indeed written to the RAM
				AR_addr_en <= '1';
--				RD <= '1';
--				output0_read <= '1';
				next_state <= STAA7;
			when STAA7 =>
				output0_read <= '1';
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when STAR =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when ADCR =>
				ALU_en <= '1';
				A_load <= '1';
				next_state <= ADCR2;
			when ADCR2 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when SBCR =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when CMPR =>
				next_state <= FETCH;
			when MULT =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when ANDR =>
				ALU_sel <= C_AND;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when ORR =>
				ALU_sel <= C_OR;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when XORR =>
				ALU_sel <= C_XOR;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when SLRL =>
				ALU_sel <= C_SLRL;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when SRRL =>
				ALU_sel <= C_SRRL;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when ROLC =>
				ALU_sel <= C_ROLC;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when RORC =>
				ALU_sel <= C_RORC;
				ALU_en <= '1';
				A_load <= '1';
				
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BCCA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BCCA2;
			when BCCA2 =>			-- Buffer stage
				next_state <= BCCA3;
			when BCCA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';

				next_state <= BCCA4;
				
			when BCCA4 =>			-- Buffer stage
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (C = '0') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BCCA5;
				end if;
			when BCCA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BCSA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BCSA2;
			when BCSA2 =>			-- Buffer stage
				next_state <= BCSA3;
			when BCSA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BCSA4;
				
			when BCSA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (C = '1') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BCSA5;
				end if;
			when BCSA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BEQA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BEQA2;
			when BEQA2 =>			-- Buffer stage
				next_state <= BEQA3;
			when BEQA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BEQA4;
			when BEQA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (Z = '1') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BEQA5;
				end if;
			when BEQA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BMIA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BMIA2;
			when BMIA2 =>			-- Buffer stage
				next_state <= BMIA3;
			when BMIA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BMIA4;
			when BMIA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (S = '1') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BMIA5;
				end if;
			when BMIA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BNEA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BNEA2;
			when BNEA2 =>			-- Buffer stage
				next_state <= BNEA3;
			when BNEA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BNEA4;
			when BNEA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (Z = '0') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BNEA5;
				end if;
			when BNEA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BPLA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BPLA2;
			when BPLA2 =>			-- Buffer stage
				next_state <= BPLA3;
			when BPLA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BPLA4;
			when BPLA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (S = '0') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BPLA5;
				end if;
			when BPLA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BVCA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BVCA2;
			when BVCA2 =>			-- Buffer stage
				next_state <= BVCA3;
			when BVCA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BVCA4;
			when BVCA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (V = '0') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BVCA5;
				end if;
			when BVCA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BVSA =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= BVSA2;
			when BVSA2 =>			-- Buffer stage
				next_state <= BVSA3;
			when BVSA3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';
				
				next_state <= BVSA4;
			when BVSA4 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				
				if (V = '1') then
					PC_addr_load <= '1';
					next_state <= BRANCH_TAKEN;
				else
					PC_inc <= '1';
					next_state <= BVSA5;
				end if;
			when BVSA5 =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when BRANCH_TAKEN =>
				next_state <= FETCH;
--				next_state <= FETCH_WITH_NO_PC_INC;
---------------------------------------------------------------------------------------------
			when DECA =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when INCA =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when SETC =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when CLRC =>
				next_state <= FETCH;
-----***----------------------------------------------------------------------------------------
			when LDSI =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				SP_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= LDSI2;
			when LDSI2 =>
				next_state <= LDSI3;
			when LDSI3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				SP_H_load	<= '1';	
				
				PC_inc <= '1';
				next_state <= LDSI4;
			when LDSI4 =>
				next_state <= FETCH;
-----***----------------------------------------------------------------------------------------
			when CALL =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_L_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= CALL2;
			when CALL2 =>
				next_state <= CALL3;
			when CALL3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_H_load	<= '1';	
				
				PC_inc <= '1';		-- in order to fetch addr_H from next cycle
				next_state <= CALL4;
			when CALL4 =>
				next_state <= CALL5;
			when CALL5 =>
				next_state <= CALL6;
			when CALL6 =>				-- SP register is driving the address bus
				SP_addr_en <= '1';
				next_state <= CALL7;
			when CALL7 =>				-- Writing PC_H to addr(SP)
				SP_addr_en <= '1';
				CPU_bus_out_en <= '1';
				WR <= '1';
				PC_H_en <= '1';
				
				next_state <= CALL8;
			when CALL8 =>				-- SP = SP - 1
				SP_addr_en <= '1';
				SP_dec <= '1';
				
				next_state <= CALL9;
			when CALL9 =>				-- Writing PC_L to addr(SP)
				SP_addr_en <= '1';
				CPU_bus_out_en <= '1';
				WR <= '1';
				PC_L_en <= '1';
				
				next_state <= CALL10;
			when CALL10 =>				-- SP = SP - 1
				SP_addr_en <= '1';
				SP_dec <= '1';
				
				next_state <= CALL11;
			when CALL11 =>				-- PC register is driving the address bus
				PC_addr_en <= '1';
				next_state <= CALL12;
			when CALL12 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				PC_addr_load <= '1';
				next_state <= CALL13;
			when CALL13 =>
				next_state <= FETCH;
-----***----------------------------------------------------------------------------------------
			when RET =>					-- SP = SP + 1
				SP_addr_en <= '1';
				SP_inc <= '1';
				next_state <= RET2;
			when RET2 =>
				SP_addr_en <= '1';
				next_state <= RET3;
			when RET3 =>				-- Load AR_L from SP
				CPU_bus_in_en <= '1';
				RD	<= '1';
				SP_addr_en <= '1';
				
				AR_L_load <= '1';
				
				next_state <= RET4;
			when RET4 =>
				SP_addr_en <= '1';
				next_state <= RET5;
			when RET5 =>				-- SP = SP + 1
				SP_addr_en <= '1';
				SP_inc <= '1';
				next_state <= RET6;
			when RET6 =>
				SP_addr_en <= '1';
				next_state <= RET7;
			when RET7 =>				-- Load AR_H from SP
				CPU_bus_in_en <= '1';
				RD	<= '1';
				SP_addr_en <= '1';
				
				AR_H_load <= '1';
				
				next_state <= RET8;
			when RET8 =>
				SP_addr_en <= '1';
				next_state <= RET9;
			when RET9 =>				-- SP = SP + 1
				SP_addr_en <= '1';
--				SP_inc <= '1';
				next_state <= RET10;
			when RET10 =>
				PC_addr_en <= '1';
				next_state <= RET11;
			when RET11 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				AR_addr_en <= '1';
				PC_addr_load <= '1';
				next_state <= RET12;
			when RET12 =>
				next_state <= FETCH;
-----***----------------------------------------------------------------------------------------
			when LDXI =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				X_L_load <= '1';
				
				PC_inc <= '1';
				next_state <= LDXI2;
			when LDXI2 =>
				next_state <= LDXI3;
			when LDXI3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				X_H_load <= '1';
				
				next_state <= LDXI4;
			when LDXI4 =>
				next_state <= FETCH;
-----***----------------------------------------------------------------------------------------
			when LDAA_INDX =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				
				X_b_load <= '1';
				
				next_state <= LDAA_INDX2;
			when LDAA_INDX2 =>
				X_indexed_addr_en <= '1';
				next_state <= LDAA_INDX3;
			when LDAA_INDX3 =>
				CPU_bus_in_en <= '1';
				RD	<= '1';
				X_indexed_addr_en <= '1';
				
				A_load <= '1';
				next_state <= LDAA_INDX4;
			when LDAA_INDX4 =>
				next_state <= FETCH;
-----***----------------------------------------------------------------------------------------
			when STAA_INDX =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when INCX =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
			when DECX =>
				next_state <= FETCH;
---------------------------------------------------------------------------------------------
				
			when others =>
				next_state <= UNKNOWN_STATE;
		end case;

	end process;
end BHV;
