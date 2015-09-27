LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.ALL;

ENTITY DEMONSTRATION IS
END DEMONSTRATION;

ARCHITECTURE TB OF DEMONSTRATION IS
	COMPONENT PROCESSOR
	PORT(CLK: IN STD_LOGIC;
			 DIN: IN STD_LOGIC_VECTOR (0 TO 15);
			 RUN: IN STD_LOGIC;
			 RESET: IN STD_LOGIC;
			 U_BUS: INOUT STD_LOGIC_VECTOR (0 TO 15);
			 DONE: OUT STD_LOGIC);
	END COMPONENT;
  SIGNAL T_CLK: STD_LOGIC;
	SIGNAL T_DIN: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL T_RUN: STD_LOGIC;
	SIGNAL T_RESET: STD_LOGIC;
	SIGNAL T_BUS: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL T_DONE: STD_LOGIC;
  
BEGIN
  U_PROCESSOR: PROCESSOR PORT MAP (T_CLK, T_DIN, T_RUN, T_RESET, T_BUS, T_DONE);
  PROCESS
    VARIABLE ERR_CNT: INTEGER := 0;
  BEGIN
    -- SETUP
		T_CLK <= '0';
		T_RUN <= '1';
		T_RESET <= '0';
		-- MOVI INSTRUCTION (001)
		T_DIN <= "0010001110000000";

		WAIT FOR 10 NS;
		T_CLK <= '1';														-- 00
		-- INSTRUCTION HAS BEEN LOADED.
		WAIT FOR 10 NS;
		T_CLK <= '0';
		-- ENTER AN IMMEDIATE
		T_DIN <= "0000000000001100"; -- 12 --- WE CAN ENTER THE IMMEDIATE RIGHT HERE
		WAIT FOR 10 NS;
		T_CLK <= '1';														-- 01
		-- R(0) IS ACCEPTING INPUT. (01)
		WAIT FOR 10 NS;
		-- IMMEDIATE (12) HAS BEEN LOADED INTO R(0).


		WAIT FOR 10 NS;	-- 50 NS
		T_CLK <= '0';

		-- INSTRUCTION: MVI 001 XXX
		T_DIN <= "0010010000000000"; 
		WAIT FOR 10 NS;	-- 60 NS
		T_CLK <= '1';														-- 00 (CLR)
		WAIT FOR 10 NS;
		WAIT FOR 10 NS;	-- 80 NS
		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';														-- 01
		WAIT FOR 10 NS;
		-- INSTRUCTION HAS BEEN LOADED.
		T_CLK <= '0';
		T_DIN <= "0000000000010100"; -- 20 ---- LOAD SECOND IMMEDIATE --- TYPE IT IN HERE !!!
		WAIT FOR 10 NS;
		T_CLK <= '1';														-- 10

		WAIT FOR 10 NS; -- 120 NS
		-- PUT INPUT INTO R(1) (01)
		-- IMMEDIATE (20) HAS BEEN LOADED INTO R(1).  (10)
		-- CASE 2: CHECK THAT DONE IS BEING ASSERTED.

		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';	
		-- AND NOW, AN ADD CASE!
		-- R(0) = R(0) + R(1)
		-- 12345 + 12 = 12357
		WAIT FOR 10 NS;

		T_DIN <= "0100000010000000"; -- INSTRUCTION FOR ADD
		-- T_DIN <= "0110000010000000"; -- INSTRUCTION FOR SUB
		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';	
		-- NOW DATA FROM R(0) IS GOING INTO A. (01)
		WAIT FOR 10 NS;
		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';
		WAIT FOR 10 NS; -- 180 NS

		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';
		WAIT FOR 10 NS; -- 180 NS
		-- NOW DATA FROM A AND R(1) ARE GOING INTO THE ALU. (10)
		-- NOW DATA FROM THE ALU IS GOING INTO R(0). (11)
		-- CASE 3
		-- CHECK THAT DONE IS ASSERTED
		-- CHECK THAT THE BUS CONTAINS THE RESULT?
		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';
		WAIT FOR 10 NS;
		T_CLK <= '0';
		WAIT FOR 10 NS;
		T_CLK <= '1';

    WAIT;
  END PROCESS;
END TB;
