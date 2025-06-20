----------------------------------------------------------------------------------
-- This block is a memory that changes next to reg
-- V2 -> Values: Frequency divider & percentage of changes
-- V3 -> Values: Previous + Number of chains
-- V4 -> NUmber of errors
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;

entity mem_v4 is
    Port ( clk5MHz : in STD_LOGIC;
           BTNC_stable : in STD_LOGIC;
           en_lock : in STD_LOGIC;
           ch_in : in unsigned (6 downto 0);
           ch_out : out unsigned (6 downto 0);
           n_chains_in : in unsigned (16 downto 0);
           n_chains_out : out unsigned (16 downto 0);
           freq_div_out : out unsigned (16 downto 0);
           freq_div_in : in unsigned (16 downto 0);
           num_errors_in : in unsigned ((max_errors_size - 1) downto 0);
           num_errors_out : out unsigned ((max_errors_size - 1) downto 0);
           p_errors_in : in unsigned (6 downto 0);
           p_errors_out : out unsigned (6 downto 0));
end mem_v4;

architecture Behavioral of mem_v4 is


begin

process (clk5MHz, BTNC_stable, en_lock)
begin
    if (BTNC_stable = '1' and en_lock = '0') then 
        freq_div_out <= (others => '0');
        ch_out <= (others => '0');
        n_chains_out <= (others => '0');
        num_errors_out <= (others => '0');
        p_errors_out <= (others => '0');
    else 
        if rising_edge(clk5MHz) then
            freq_div_out <= freq_div_in;
            ch_out <= ch_in;
            n_chains_out <= n_chains_in;
            num_errors_out <= num_errors_in;
            p_errors_out <= p_errors_in;
        end if;
    end if;
end process;
          
end Behavioral;
