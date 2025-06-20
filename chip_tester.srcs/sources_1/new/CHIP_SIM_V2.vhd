----------------------------------------------------------------------------------
-- Top_level: Display in NEXYS A7 some values that can be modified
-- V2 -> Values: Frequency divider & percentage of changes
-- V3 -> Values: Previous + Number of chains
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;


entity CHIP_SIM_V2 is
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
end CHIP_SIM_V2;

architecture Behavioral of CHIP_SIM_V2 is


component VALUES_V4_test 
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
           bit_chip : in STD_LOGIC;
           freq_generated: out STD_LOGIC;
           bit_test : out STD_LOGIC;
           test_running : out STD_LOGIC;
           test_complete : out STD_LOGIC;
           check_running : out STD_LOGIC;
           check_complete : out STD_LOGIC;
           chip_enable : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           sg : out STD_LOGIC_VECTOR (6 downto 0));

end component;

component test_chip 
    Port (enable : in STD_LOGIC;
          clk_in_chip: in STD_LOGIC;
          bit_in_chip: in STD_LOGIC;
          bit_out_chip: out STD_LOGIC );
end component;

signal bit_2_chip, bit_2_tester, freq_signal, chip_enable_s: STD_LOGIC;

begin

VALUES: VALUES_V4_test
    port map ( CLK100MHZ => CLK100MHZ,
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
           bit_chip => bit_2_tester,
           freq_generated => freq_signal,
           bit_test => bit_2_chip,
           test_running => test_running,
           test_complete => test_complete,
           check_running => check_running,
           check_complete => check_complete,
           chip_enable => chip_enable_s,
           an => an,
           sg => sg);

CHIP: test_chip
    port map ( enable => chip_enable_s,
            clk_in_chip => freq_signal,
            bit_in_chip => bit_2_chip,
            bit_out_chip => bit_2_tester);


freq_generated <= freq_signal;

end Behavioral;
