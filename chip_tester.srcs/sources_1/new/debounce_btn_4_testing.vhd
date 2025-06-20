----------------------------------------------------------------------------------
-- This block deals with the button bounces
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;

entity debounce_btn_4_testing is
    Port ( clk5Mhz: in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNU_stable : out STD_LOGIC;
           BTND_stable : out STD_LOGIC;
           BTNL_stable : out STD_LOGIC;
           BTNR_stable : out STD_LOGIC;
           BTNC_stable : out STD_LOGIC);
end debounce_btn_4_testing;

architecture Behavioral of debounce_btn_4_testing is

signal BTNU_count : integer range 0 to DEBOUNCE_COUNT_4_TESTING;
signal BTND_count : integer range 0 to DEBOUNCE_COUNT_4_TESTING;
signal BTNL_count : integer range 0 to DEBOUNCE_COUNT_4_TESTING;
signal BTNR_count : integer range 0 to DEBOUNCE_COUNT_4_TESTING;
signal BTNC_count : integer range 0 to DEBOUNCE_COUNT_4_TESTING;

begin

DEBOUNCER_BTN: process (clk5MHz)
begin
if rising_edge(clk5MHz) then
        -- BTNU button
        if BTNU = '1' then
            if BTNU_count = DEBOUNCE_COUNT_4_TESTING - 1 then
                BTNU_stable <= '1';
                BTNU_count <= BTNU_count + 1;
            elsif BTNU_count < DEBOUNCE_COUNT_4_TESTING then
                BTNU_count <= BTNU_count + 1;
                BTNU_stable <= '0';
            else
                BTNU_count <= DEBOUNCE_COUNT_4_TESTING;
                BTNU_stable <= '0';
            end if;
        else
            BTNU_count <= 0;
            BTNU_stable <= '0';
        end if;

        -- BTND button
        if BTND = '1' then
            if BTND_count = DEBOUNCE_COUNT_4_TESTING - 1 then
                BTND_stable <= '1';
                BTND_count <= BTND_count + 1;
            elsif BTND_count < DEBOUNCE_COUNT_4_TESTING then
                BTND_count <= BTND_count + 1;
                BTND_stable <= '0';
            else
                BTND_count <= DEBOUNCE_COUNT_4_TESTING;
                BTND_stable <= '0';
            end if;
        else
            BTND_count <= 0;
            BTND_stable <= '0';
        end if;

        -- BTNL button
        if BTNL = '1' then
            if BTNL_count = DEBOUNCE_COUNT_4_TESTING - 1 then
                BTNL_stable <= '1';
                BTNL_count <= BTNL_count + 1;
            elsif BTNL_count < DEBOUNCE_COUNT_4_TESTING then
                BTNL_count <= BTNL_count + 1;
                BTNL_stable <= '0';
            else
                BTNL_count <= DEBOUNCE_COUNT_4_TESTING;
                BTNL_stable <= '0';
            end if;
        else
            BTNL_count <= 0;
            BTNL_stable <= '0';
        end if;

        -- BTNR button
        if BTNR = '1' then
            if BTNR_count = DEBOUNCE_COUNT_4_TESTING - 1 then
                BTNR_stable <= '1';
                BTNR_count <= BTNR_count + 1;
            elsif BTNR_count < DEBOUNCE_COUNT_4_TESTING then
                BTNR_count <= BTNR_count + 1;
                BTNR_stable <= '0';
            else
                BTNR_count <= DEBOUNCE_COUNT_4_TESTING;
                BTNR_stable <= '0';
            end if;
        else
            BTNR_count <= 0;
            BTNR_stable <= '0';
        end if;
        -- BTNC button
        if BTNC = '1' then
            if BTNC_count = DEBOUNCE_COUNT_4_TESTING - 1 then
                BTNC_stable <= '1';
                BTNC_count <= BTNC_count + 1;
            elsif BTNR_count < DEBOUNCE_COUNT_4_TESTING then
                BTNC_count <= BTNC_count + 1;
                BTNC_stable <= '0';
            else
                BTNC_count <= DEBOUNCE_COUNT_4_TESTING;
                BTNC_stable <= '0';
            end if;
        else
            BTNC_count <= 0;
            BTNC_stable <= '0';
        end if;
    end if;
end process;


end Behavioral;
