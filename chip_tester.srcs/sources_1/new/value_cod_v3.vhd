----------------------------------------------------------------------------------
-- This block obtains the display values and saves them in the memory according
-- to the switch that determines which value they represent.
-- V2 -> Values: Frequency divider & percentage of changes
-- V3 -> Values: Previous + Number of chains
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity value_cod_v3 is
    Port(en_conf_f : in STD_LOGIC;
         en_conf_ch : in STD_LOGIC;
         en_conf_n : in STD_LOGIC;
         disp_5 : in unsigned (3 downto 0);
         disp_4 : in unsigned (3 downto 0);
         disp_3 : in unsigned (3 downto 0);
         disp_2 : in unsigned (3 downto 0);
         disp_1 : in unsigned (3 downto 0);
         disp_0 : in unsigned (3 downto 0);
         ch_in : in unsigned (6 downto 0);
         ch_out : out unsigned (6 downto 0);
         n_chains_in : in unsigned (16 downto 0);
         n_chains_out : out unsigned (16 downto 0);
         freq_div_in : in unsigned (16 downto 0);
         freq_div_out : out unsigned (16 downto 0));
end value_cod_v3;

architecture Behavioral of value_cod_v3 is

signal s_freq_div, s_n_chains : unsigned (16 downto 0);
signal s_ch : unsigned (6 downto 0);

begin

s_freq_div <= resize(disp_0, 17) + 
          resize(resize(disp_1, 17) * 10, 17) + 
          resize(resize(disp_2, 17) * 100, 17) + 
          resize(resize(disp_3, 17) * 1000, 17) + 
          resize(resize(disp_4, 17) * 10000, 17) + 
          resize(resize(disp_5, 17) * 100000, 17);

s_n_chains <= resize(disp_0, 17) + 
          resize(resize(disp_1, 17) * 10, 17) + 
          resize(resize(disp_2, 17) * 100, 17) + 
          resize(resize(disp_3, 17) * 1000, 17) + 
          resize(resize(disp_4, 17) * 10000, 17) + 
          resize(resize(disp_5, 17) * 100000, 17);

s_ch <= resize(disp_0, 7) + 
        resize(resize(disp_1, 7) * 10, 7) + 
        resize(resize(disp_2, 7) * 100, 7);
 

-- They keep the same value when other value is being modified or their enable in not active.
freq_div_out <= freq_div_in when (en_conf_f = '0' or en_conf_ch = '1' or en_conf_n = '1') else
            s_freq_div;
n_chains_out <= n_chains_in when (en_conf_n = '0' or en_conf_ch = '1' or en_conf_f = '1') else
            s_n_chains;
ch_out <= ch_in when (en_conf_ch = '0' or en_conf_f = '1' or en_conf_n = '1') else
         s_ch (6 downto 0);

         
end Behavioral;
