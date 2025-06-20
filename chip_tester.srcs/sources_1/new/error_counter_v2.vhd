----------------------------------------------------------------------------------
-- This block receives the bits from the chip and detects the number of errors
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;


entity error_counter_v2 is
    Port ( clk100MHz : in STD_LOGIC;
           clk_gen : in STD_LOGIC;
           en_lock : in STD_LOGIC;
           ch : in unsigned (6 downto 0);
           n_chains : in unsigned (16 downto 0);
           bit_chip : in STD_LOGIC;
           num_errors : out unsigned ((max_errors_size - 1) downto 0);
           p_errors : out unsigned (6 downto 0);
           check_running : out STD_LOGIC;
           check_complete: out STD_LOGIC);
end error_counter_v2;

architecture Behavioral of error_counter_v2 is


signal bit_reg, bit_next, check_running_reg, check_running_next, check_complete_reg, check_complete_next: std_logic;
signal count_100_reg, count_100_next: integer;
signal n_chains_count_reg, n_chains_count_next : unsigned (16 downto 0);

signal count_start_check_reg, count_start_check_next: integer;
signal start_check_reg, start_check_next: std_logic;

signal step: integer;
signal percentage : integer;

signal num_errors_next, num_errors_reg : unsigned ((max_errors_size - 1) downto 0);
signal p_errors_reg, p_errors_next : unsigned (6 downto 0);

--Synchronization signals
signal clk_gen_sync_1, clk_gen_sync_2 : std_logic;
signal clk_gen_falling_edge, clk_gen_rising_edge : std_logic;


begin

--STATE_REGISTER:

process (clk100MHz)
begin
    if rising_edge(clk100MHz) then
        if (en_lock = '0') then
            clk_gen_sync_1 <= '0';
            clk_gen_sync_2 <= '0';
            clk_gen_falling_edge <= '0';
            clk_gen_rising_edge <= '0';
            -- Bit array test 
            count_100_reg <= 0;
            bit_reg <= '0';
            check_running_reg <= '0';
            check_complete_reg <= '0';
            n_chains_count_reg <= (others => '0');
            -- Errors check
            count_start_check_reg <= 0;
            start_check_reg <= '0';
            num_errors_reg <= (others=>'0');
            p_errors_reg <= (others=>'0');
        else
            -- Clk_gen synchronization
            clk_gen_sync_1 <= clk_gen;
            clk_gen_sync_2 <= clk_gen_sync_1;
            
            -- CLk_gen rising_edge detection
            if (clk_gen_sync_1 = '1' and clk_gen_sync_2 = '0') then
                clk_gen_rising_edge <= '1';
            else
                clk_gen_rising_edge <= '0';
            end if;
            
            if (clk_gen_rising_edge = '1') then
                -- Bit array test 
                start_check_reg <= start_check_next;
                count_100_reg <= count_100_next;
                bit_reg <= bit_next;
                check_running_reg <= check_running_next;
                check_complete_reg <= check_complete_next;
            end if;
            
            -- CLk_gen falling_edge detection
            if (clk_gen_sync_1 = '0' and clk_gen_sync_2 = '1') then
                clk_gen_falling_edge <= '1';
            else
                clk_gen_falling_edge <= '0';
            end if;
            
            if (clk_gen_falling_edge = '1') then
                -- Errors check
                count_start_check_reg <= count_start_check_next;
                n_chains_count_reg <= n_chains_count_next;
                num_errors_reg <= num_errors_next;
                p_errors_reg <= p_errors_next;
            end if;
        end if;
    end if;
end process;

--NEXT_STATE_LOGIC:

--Counter to wait for the bits to exit from the chip
start_check_next <= '1' when ((en_lock = '1') and (count_start_check_reg = (reg_num_chip - 1))) else 
               '0';

count_start_check_next <= count_start_check_reg + 1 when ((en_lock = '1') and (count_start_check_reg < (reg_num_chip-1))) else
                          count_start_check_reg;


--Same protocol as the test_gen to have the same bits chain

step <= (100/(to_integer(ch)+1)) when (to_integer(ch) < 100) else
        1;

bit_next <= '0' when (((count_100_reg = 0) and (start_check_reg = '1')) or (to_integer(ch) = 0)) else

            (not bit_reg) when ((to_integer(ch) >= 100) and (count_100_reg <= 100) and (n_chains_count_reg < n_chains) and (start_check_reg = '1')) else -- ch is 100
            (not bit_reg) when (((to_integer(ch) rem 2) /= 0) and (count_100_reg < 100) and (n_chains_count_reg < n_chains) and (count_100_reg rem step = 0) and (start_check_reg = '1')) else -- ch is odd
            (not bit_reg) when (((to_integer(ch) rem 2) = 0) and (count_100_reg < 99) and (n_chains_count_reg < n_chains) and (count_100_reg rem step = 0) and (start_check_reg = '1')) else -- ch is even
            bit_reg when ((count_100_reg <= 100) and (n_chains_count_reg < n_chains) and (start_check_reg = '1')) else
            '0';

count_100_next <= count_100_reg + 1 when ((count_100_reg < 100) and (n_chains_count_reg < n_chains) and (start_check_reg = '1')) else
                  1 when ((count_100_reg = 100) and (n_chains_count_reg < n_chains) and (start_check_reg = '1')) else
                  count_100_reg;
                 
n_chains_count_next <= n_chains_count_reg + 1 when ((n_chains_count_reg < n_chains) and (count_100_reg = 100) and (start_check_reg = '1')) else
                       n_chains_count_reg;
                       
--Error counter
num_errors_next <= num_errors_reg + 1 when ((bit_chip /= bit_reg) and (count_100_reg > 0) and (start_check_reg = '1')) else
                   num_errors_reg;

percentage <= ((to_integer(num_errors_reg) + (to_integer(n_chains) - 1))/to_integer(n_chains)) when (n_chains > 0) else
              0 ;
p_errors_next <= to_unsigned(percentage,7) when ((n_chains > 0) and (start_check_reg = '1')) else
                 p_errors_reg;

--Error check state
check_running_next <= '1' when ((start_check_reg = '1') and (en_lock = '1') and (n_chains_count_reg < n_chains)) else
                   '0';

check_complete_next <= '1' when ((en_lock = '1') and (n_chains_count_reg = n_chains)) else
                      '0';
                      

--OUTPUT_LOGIC:
num_errors <= num_errors_reg;
p_errors <= p_errors_reg;
check_running <= check_running_reg;
check_complete <= check_complete_reg;

end Behavioral;
