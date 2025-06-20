----------------------------------------------------------------------------------
-- This block makes the display position that is being modified
-- blink giving feedback to the user.
-- V2 -> Values: Frequency divider & percentage of changes
-- V3 -> Values: Previous + Number of chains
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;


entity blinker_v3 is 
    Port (clk5MHZ: in std_logic;
          en_conf_f : in STD_LOGIC;
          en_conf_ch : in STD_LOGIC;
          en_conf_n : in STD_LOGIC;
          en_lock : in STD_LOGIC;
          index : in integer range 0 to 5;
          an_prov : in STD_LOGIC_VECTOR (7 downto 0);
          an : out STD_LOGIC_VECTOR (7 downto 0));
end blinker_v3;

architecture Behavioral of blinker_v3 is

signal current_reg , next_reg, sum_reg : unsigned (22 downto 0);
signal mask: std_logic_vector (7 downto 0);


begin

-- next state logic
process ( clk5MHZ)
begin
    if (rising_edge ( clk5MHZ )) then
        current_reg <= next_reg ;
    end if;   
end process;

-- current state logic
sum_reg <= (current_reg +1);
next_reg <= (others => '0') when (sum_reg = unsigned(one_sec)) else
             sum_reg;

-- output logic
mask <= "00000001" when (index = 0) else
        "00000010" when (index = 1) else
        "00000100" when (index = 2) else
        "00001000" when (index = 3) else
        "00010000" when (index = 4) else
        "00100000";


an <=(an_prov or mask) when ((current_reg > unsigned(half_sec)) and ((en_conf_f = '1') or (en_conf_ch = '1') or (en_conf_n = '1')) and (en_lock = '0')) else
      an_prov;


end Behavioral;
