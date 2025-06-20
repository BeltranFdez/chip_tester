----------------------------------------------------------------------------------
-- This block is a flip_flop that introduces an error each X bits (for synthesis)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL; -- For rng

use work.dictionary.All;

entity reg_error_synth is
    Generic (error_place : integer := 99);
    Port ( clk_in_reg : in STD_LOGIC;
           en : in STD_LOGIC;
           bit_in_reg : in STD_LOGIC;
           bit_out_reg : out STD_LOGIC);
end reg_error_synth;

architecture Behavioral of reg_error_synth is

signal bit_reg, bit_next: STD_LOGIC;
signal count_reg, count_next : integer;


begin

-- Next state logic
process (clk_in_reg, en)
begin
    if (en = '1') then
        if rising_edge(clk_in_reg) then
            bit_reg <= bit_next;
            count_reg <= count_next;
        else 
            bit_reg <= bit_reg;
            count_reg <= count_reg;
        end if;
    else 
        count_reg <= 0;
    end if;
end process;

-- Current state logic
bit_next <= bit_in_reg;
count_next <= 0 when (count_reg >= error_place) else
              count_reg + 1;

-- Output logic
bit_out_reg <= not (bit_reg) when (count_reg = (error_place - 1)) else
           bit_reg;
   
end Behavioral;
