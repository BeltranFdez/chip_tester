----------------------------------------------------------------------------------
-- This block is a flip_flop
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg is
    Port ( clk_in_reg : in STD_LOGIC;
           bit_in_reg : in STD_LOGIC;
           bit_out_reg : out STD_LOGIC);
end reg;

architecture Behavioral of reg is

signal bit_reg, bit_next: STD_LOGIC;

begin

-- next state logic
process (clk_in_reg)
begin
    if rising_edge(clk_in_reg) then
        bit_reg <= bit_next;
    else 
        bit_reg <= bit_reg;
    end if;
end process;

-- current state logic
bit_next <= bit_in_reg;

-- output logic
bit_out_reg <= bit_reg;
   
end Behavioral;
