----------------------------------------------------------------------------------
-- This block is a 5 register chip simulator for testing
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test_chip is
    Port (enable : in STD_LOGIC;
          clk_in_chip: in STD_LOGIC;
          bit_in_chip: in STD_LOGIC;
          bit_out_chip: out STD_LOGIC );
end test_chip;

architecture Behavioral of test_chip is

component reg
    Port ( clk_in_reg : in STD_LOGIC;
           bit_in_reg : in STD_LOGIC;
           bit_out_reg : out STD_LOGIC);
end component;

component reg_error
    Port ( clk_in_reg : in STD_LOGIC;
           bit_in_reg : in STD_LOGIC;
           bit_out_reg : out STD_LOGIC);
end component;

component reg_error_synth
    Port ( clk_in_reg : in STD_LOGIC;
           en : in STD_LOGIC;
           bit_in_reg : in STD_LOGIC;
           bit_out_reg : out STD_LOGIC);
end component;

signal bit_1, bit_2, bit_3, bit_4, clk_en: STD_LOGIC;

begin

clk_en <= clk_in_chip when (enable = '1') else
          '0';

REGISTER_1: reg
    port map ( clk_in_reg => clk_en,
        bit_in_reg => bit_in_chip,
        bit_out_reg => bit_1);

REGISTER_2:reg
    port map ( clk_in_reg => clk_en,
        bit_in_reg => bit_1,
        bit_out_reg => bit_2);

REGISTER_3:reg
    port map ( clk_in_reg => clk_en,
        bit_in_reg => bit_2,
        bit_out_reg => bit_3);


REGISTER_4: reg_error_synth -- For a chip with errors
--REGISTER_4:reg -- For a chip without errors
    port map ( clk_in_reg => clk_en,
        en => enable,
        bit_in_reg => bit_3,
        bit_out_reg => bit_4);

REGISTER_5:reg
    port map ( clk_in_reg => clk_en,
        bit_in_reg => bit_4,
        bit_out_reg => bit_out_chip);

end Behavioral;
