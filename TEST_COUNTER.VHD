
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TEST_COUNTER IS
END TEST_COUNTER;

ARCHITECTURE TB OF TEST_COUNTER IS
  COMPONENT COUNTER
	PORT (CLR: IN STD_LOGIC;
				CLK: IN STD_LOGIC;
				Q: INOUT STD_LOGIC_VECTOR(0 TO 1) := "00");
  END COMPONENT;

  SIGNAL T_CLR, T_CLK: STD_LOGIC;
  SIGNAL T_Q: STD_LOGIC_VECTOR (0 TO 1);

BEGIN
  U_COUNTER: COUNTER PORT MAP (T_CLR, T_CLK, T_Q);
  PROCESS
    VARIABLE ERR_CNT: INTEGER := 0;
  BEGIN
--CASE 1: 00
  T_CLR <= '0';
  T_CLK <= '0';
  WAIT FOR 1 NS;
  ASSERT (T_Q="00") REPORT "ERROR1!" SEVERITY ERROR;
  IF (T_Q/="00") THEN
    ERR_CNT := ERR_CNT + 1;
  END IF;
  WAIT FOR 10 NS;
--CASE 2: 01
  T_CLK <= '1';
  WAIT FOR 1 NS;
  ASSERT (T_Q="01") REPORT "ERROR2!" SEVERITY ERROR;
  IF (T_Q/="01") THEN
    ERR_CNT := ERR_CNT + 1;
  END IF;
  WAIT FOR 10 NS;
--CASE 3: 10
  T_CLK <= '0';
  WAIT FOR 1 NS;
  T_CLK <= '1';
  WAIT FOR 1 NS;
  ASSERT (T_Q="10") REPORT "ERROR3!" SEVERITY ERROR;
  IF (T_Q/="10") THEN
    ERR_CNT := ERR_CNT + 1;
  END IF;
  WAIT FOR 10 NS;
--CASE 4: 11
  T_CLK <= '0';
  WAIT FOR 1 NS;
  T_CLK <= '1';
  WAIT FOR 1 NS;
  ASSERT (T_Q="11") REPORT "ERROR4!" SEVERITY ERROR;
  IF (T_Q/="11") THEN
    ERR_CNT := ERR_CNT + 1;
  END IF;
  WAIT FOR 10 NS;

  IF ERR_CNT=0 THEN
    ASSERT FALSE
    REPORT "TESTBENCH OF COUNTER COMPLETED SUCCESSFULLY!" SEVERITY NOTE;
  ELSE
    ASSERT FALSE
    REPORT "SOMETHING WRONG. :(" SEVERITY ERROR;
  END IF;
  WAIT;
  END PROCESS;
END TB;