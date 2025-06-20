----------------------------------------------------------------------------------
-- This block generates 100 bits (1 by 1) with the % of changes given by "ch"
-- and the state of the test
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test_gen_v3 is
    Port ( clk100MHz : in STD_LOGIC;
           clk_gen : in STD_LOGIC;
           en_lock : in STD_LOGIC;
           ch : in unsigned (6 downto 0);
           n_chains : in unsigned (16 downto 0);
           bit_test : out STD_LOGIC;
           test_running: out STD_LOGIC;
           test_complete: out STD_LOGIC);
end test_gen_v3;

architecture Behavioral of test_gen_v3 is

signal bit_reg, bit_next, test_running_reg, test_running_next, test_complete_reg, test_complete_next: std_logic;
signal count_100_reg, count_100_next: integer;
signal n_chains_count_reg, n_chains_count_next : unsigned (16 downto 0);

signal step : integer;

--Synchronization signals
signal clk_gen_sync_1, clk_gen_sync_2 : std_logic;
signal clk_gen_falling_edge : std_logic;


begin

--STATE_REGISTER:

process (clk100MHz)
begin
    if rising_edge(clk100MHz) then
        if en_lock = '0' then
            clk_gen_sync_1 <= '0';
            clk_gen_sync_2 <= '0';
            clk_gen_falling_edge <= '0';
            count_100_reg <= 0;
            bit_reg <= '0';
            test_running_reg <= '0';
            test_complete_reg <= '0';
            n_chains_count_reg <= (others => '0');
        else
            -- Clk_gen synchronization
            clk_gen_sync_1 <= clk_gen;
            clk_gen_sync_2 <= clk_gen_sync_1;

            -- CLk_gen rising_edge detection
            if (clk_gen_sync_1 = '0' and clk_gen_sync_2 = '1') then
                clk_gen_falling_edge <= '1';
            else
                clk_gen_falling_edge <= '0';
            end if;

            if clk_gen_falling_edge = '1' then
                count_100_reg <= count_100_next;
                bit_reg <= bit_next;
                test_running_reg <= test_running_next;
                test_complete_reg <= test_complete_next;
                n_chains_count_reg <= n_chains_count_next;
            end if;
        end if;
    end if;
end process;

--NEXT_STATE_LOGIC:

step <= (100/(to_integer(ch)+1)) when (to_integer(ch) < 100) else
        1;

bit_next <= '0' when ((count_100_reg = 0) or (to_integer(ch) = 0)) else
            (not bit_reg) when ((to_integer(ch) >= 100) and (count_100_reg <= 100) and (n_chains_count_reg < n_chains)) else -- ch is 100
            (not bit_reg) when (((to_integer(ch) rem 2) /= 0) and (count_100_reg < 100) and (n_chains_count_reg < n_chains) and (count_100_reg rem step = 0)) else -- ch is odd
            (not bit_reg) when (((to_integer(ch) rem 2) = 0) and (count_100_reg < 99) and (n_chains_count_reg < n_chains) and (count_100_reg rem step = 0)) else -- ch is even
            bit_reg when ((count_100_reg <= 100) and (n_chains_count_reg < n_chains)) else
            '0';

test_running_next <= '1' when ((en_lock = '1') and (n_chains_count_reg < n_chains)) else
                   '0';

test_complete_next <= '1' when ((en_lock = '1') and (n_chains_count_reg = n_chains)) else
                      '0';

count_100_next <= count_100_reg + 1 when ((count_100_reg < 100) and (n_chains_count_reg < n_chains) and (en_lock = '1')) else
                  1 when ((count_100_reg = 100) and (n_chains_count_reg < n_chains) and (en_lock = '1')) else
                  count_100_reg;
                                   
n_chains_count_next <= n_chains_count_reg + 1 when ((n_chains_count_reg < n_chains) and (count_100_reg = 100)) else
                       n_chains_count_reg;

--OUTPUT_LOGIC:
bit_test <= bit_reg;
test_running <= test_running_reg;
test_complete <= test_complete_reg;

end Behavioral;
