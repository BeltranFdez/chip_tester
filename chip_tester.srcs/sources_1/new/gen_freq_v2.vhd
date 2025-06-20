----------------------------------------------------------------------------------
-- This block generates the frequency divided from the system clock (100 MHz)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gen_freq_v2 is
    Port ( clk100Mhz : in STD_LOGIC;
           div_freq: in unsigned (16 downto 0);
           en_lock : in STD_LOGIC;
           freq_out : out STD_LOGIC);
end gen_freq_v2;

architecture Behavioral of gen_freq_v2 is

signal count_reg, count_next, sum : unsigned (16 downto 0);

begin

STATE_REGISTER:  
process(clk100MHz, en_lock)
    begin
        if(en_lock = '0') then
            count_reg <= (others => '0');
        else 
            if (rising_edge(clk100MHz)) then
                count_reg <= count_next;
            else
                count_reg <= count_reg;
            end if;
        end if;
end process;

NEXT_STATE_LOGIC:
sum <= count_reg + 1;
count_next <= (others => '0') when (count_reg >= (div_freq -1)) else
               sum;


OUTPUT_LOGIC:
freq_out <= clk100MHz when ((to_integer(div_freq) = 1) and en_lock = '1') else
            '1' when ((count_reg < (div_freq/2)) and (en_lock = '1')) else
            '0';

end Behavioral;
