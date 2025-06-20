----------------------------------------------------------------------------------
-- nC = 1, ch = 100, f = 100
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CHIP_SIM3_tb is
end CHIP_SIM3_tb;

architecture Behavioral of CHIP_SIM3_tb is

component CHIP_SIM_V2
    Port ( CLK100MHZ : in STD_LOGIC;
           en_conf_f : in STD_LOGIC;
           en_conf_ch : in STD_LOGIC;
           en_conf_n : in STD_LOGIC;
           en_lock: in STD_LOGIC;
           en_num_errors : in STD_LOGIC;
           en_p_errors : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           freq_generated : out STD_LOGIC;
           test_running : out STD_LOGIC;
           test_complete : out STD_LOGIC;
           check_running : out STD_LOGIC;
           check_complete : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           sg : out STD_LOGIC_VECTOR (6 downto 0));
end component ;


signal clk100Mhz, en_conf_f, en_conf_ch, en_conf_n, en_lock, BTNU, BTND, BTNL, BTNR, BTNC, freq_generated, test_running, test_complete, en_num_errors, en_p_errors, check_running, check_complete: std_logic;
signal an : STD_LOGIC_VECTOR (7 downto 0);
signal sg : STD_LOGIC_VECTOR (6 downto 0);


constant clk_period : time := 10 ns;
constant clk_5MHz_period : time := 200 ns;

begin
-- Unity Under Test
UUT : CHIP_SIM_V2
    port map (
     clk100Mhz => clk100Mhz,
     en_conf_f => en_conf_f,
     en_conf_ch => en_conf_ch,
     en_conf_n => en_conf_n,
     en_lock => en_lock,
     en_num_errors => en_num_errors,
     en_p_errors => en_p_errors,
     BTNU => BTNU,
     BTND => BTND,
     BTNL => BTNL,
     BTNR => BTNR,
     BTNC => BTNC,
     freq_generated => freq_generated,
     test_running => test_running,
     test_complete => test_complete,
     check_running => check_running,
     check_complete => check_complete,
     an => an,
     sg => sg);


-- Clock process definition ( 50% duty cycle)
clk_100Mhz_process : process
    begin
        clk100Mhz <= '0';
        wait for clk_period/2;
        clk100Mhz <= '1';
        wait for clk_period/2;
end process ;

en_conf_n_process: process
    begin   
        en_conf_n <= '0';
        wait for clk_5MHz_period* 4;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        en_conf_n <= '1'; 
        wait for clk_5MHz_period * 6;
        en_conf_n <= '0';
        wait for 15 ms;
end process;

en_conf_ch_process: process
    begin   
        en_conf_ch <= '0';
        wait for clk_5MHz_period * 13;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        en_conf_ch <= '1';
        wait for clk_5MHz_period * 12;
        en_conf_ch <= '0';
        wait for 15 ms;
end process;

en_conf_f_process: process
    begin   
        en_conf_f <= '0';
        wait for clk_5MHz_period * 26;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        en_conf_f <= '1';
        wait for clk_5MHz_period * 17;
        en_conf_f <= '0';
        wait for 15 ms;
end process;

en_num_errors_process: process
    begin
        en_num_errors <= '0';
        wait for clk_5MHz_period * 20; -- *20 to let the clk_wiz start
        wait for 10 ms;
        en_num_errors <= '1';
        wait for 1 ms;
        en_num_errors <= '0';
        wait for 13 ms;
end process;

en_p_errors_process: process
    begin
        en_p_errors <= '0';
        wait for clk_5MHz_period * 20; -- *20 to let the clk_wiz start
        wait for 11 ms;
        en_p_errors <= '1';
        wait for 1 ms;
        en_p_errors <= '0';
        wait for 12 ms;
end process;

en_lock_process: process
    begin   
        en_lock <= '0';
        wait for clk_5MHz_period * 44;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        en_lock <= '1';
        wait for 15 ms;
end process;

BTNL_process: process
    begin
        BTNL <= '0';
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        wait for clk_5MHz_period*27;
        BTNL <= '1';
        wait for clk_5MHz_period*4;
        BTNL <= '0';
        wait for clk_5MHz_period*1;
        BTNL <= '1';
        wait for clk_5MHz_period*4;
        BTNL <= '0';
        wait for 15 ms;
end process;

BTNR_process: process
    begin
        BTNR <= '0';
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        wait for clk_5MHz_period * 14;
        BTNR <= '1';
        wait for clk_5MHz_period * 4;
        BTNR <= '0';
        wait for 15 ms;
end process;

BTNU_process: process
    begin
        BTNU <= '0';
        wait for clk_5MHz_period*5;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        BTNU <= '1';
        wait for clk_5MHz_period*4;
        BTNU <= '0';
        wait for clk_5MHz_period*11;
        BTNU <= '1';
        wait for clk_5MHz_period*4;
        BTNU <= '0';
        wait for clk_5MHz_period*13;
        BTNU <= '1';
        wait for clk_5MHz_period*4;
        BTNU <= '0';
        wait for 15 ms;
    end process;

BTND_process: process
    begin
        BTND <= '0';
        wait for clk_5MHz_period;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
--        BTND <= '1';
--        wait for clk_5MHz_period;
    end process;
    
BTNC_process: process
    begin
        BTNC <= '0';
        wait for clk_5MHz_period;
        wait for clk_5MHz_period  * 20; -- *20 to let the clk_wiz start
        BTNC <= '1';
        wait for clk_5MHz_period * 3;
        BTNC <= '0';
        wait for 100 ms;
    end process;
    
end Behavioral;
