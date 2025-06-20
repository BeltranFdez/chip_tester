----------------------------------------------------------------------------------
-- This block shows the 7seg words in the displays 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;


entity displayer_7seg is
    Port (p0 : in STD_LOGIC_VECTOR (6 downto 0);
          p1 : in STD_LOGIC_VECTOR (6 downto 0);
          p2 : in STD_LOGIC_VECTOR (6 downto 0);
          p3 : in STD_LOGIC_VECTOR (6 downto 0);
          p4 : in STD_LOGIC_VECTOR (6 downto 0);
          p5 : in STD_LOGIC_VECTOR (6 downto 0);
          p6 : in STD_LOGIC_VECTOR (6 downto 0);
          p7 : in STD_LOGIC_VECTOR (6 downto 0);
          clk5MHZ: in std_logic;
          an_prov : out STD_LOGIC_VECTOR (7 downto 0);
          sg : out STD_LOGIC_VECTOR (6 downto 0));
end displayer_7seg;

architecture Behavioral of displayer_7seg is

signal current_reg , next_reg, sum_reg : unsigned (15 downto 0);

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
next_reg <= (others => '0') when (sum_reg = unsigned(Hz100)) else
             sum_reg;
             
-- output logic
an_prov <="01111111" when (current_reg < unsigned(Hz800)) else
     "10111111" when (current_reg < 2*unsigned(Hz800)) else
     "11011111" when (current_reg < 3*unsigned(Hz800)) else
     "11101111" when (current_reg < 4*unsigned(Hz800)) else
     "11110111" when (current_reg < 5*unsigned(Hz800)) else
     "11111011" when (current_reg < 6*unsigned(Hz800)) else
     "11111101" when (current_reg < 7*unsigned(Hz800)) else
     "11111110" when (current_reg < 8*unsigned(Hz800)) else
     "00000000";
 
sg <=p7 when (current_reg < unsigned(Hz800)) else
     p6 when (current_reg < 2*unsigned(Hz800)) else
     p5 when (current_reg < 3*unsigned(Hz800)) else
     p4 when (current_reg < 4*unsigned(Hz800)) else
     p3 when (current_reg < 5*unsigned(Hz800)) else
     p2 when (current_reg < 6*unsigned(Hz800)) else
     p1 when (current_reg < 7*unsigned(Hz800)) else
     p0 when (current_reg < 8*unsigned(Hz800)) else
     dash_7seg;




end Behavioral;
