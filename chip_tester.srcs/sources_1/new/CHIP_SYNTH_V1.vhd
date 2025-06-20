----------------------------------------------------------------------------------
-- This block incorporates the system VALUES and a chip for synthesis.
-- It needs to be wired through the JA and JB ports
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;


entity CHIP_SYNTH_V1 is
    Port ( -- VALUES_V4 
           CLK100MHZ : in STD_LOGIC;
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
           bit_chip: in STD_LOGIC; -- JB[3]
           freq_generated : out STD_LOGIC; -- JB[1]
           bit_test : out STD_LOGIC; -- JB[10]
           test_running : out STD_LOGIC;
           test_complete : out STD_LOGIC;
           check_running : out STD_LOGIC;
           check_complete : out STD_LOGIC;
           chip_enable : out STD_LOGIC; -- JB [8]
           an : out STD_LOGIC_VECTOR (7 downto 0);
           sg : out STD_LOGIC_VECTOR (6 downto 0);
           -- test_chip_synth
           enable : in STD_LOGIC; -- JA[8]
           clk_in_chip: in STD_LOGIC; -- JA[1]
           bit_in_chip: in STD_LOGIC; -- JA[10]
           bit_out_chip: out STD_LOGIC); -- JA[3]
end CHIP_SYNTH_V1;

architecture Behavioral of CHIP_SYNTH_V1 is


component VALUES_V4 
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


begin

VALUES: VALUES_V4
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
           bit_chip => bit_chip,
           freq_generated => freq_generated,
           bit_test => bit_test,
           test_running => test_running,
           test_complete => test_complete,
           check_running => check_running,
           check_complete => check_complete,
           chip_enable => chip_enable,
           an => an,
           sg => sg);

CHIP: test_chip
    port map ( enable => enable,
            clk_in_chip => clk_in_chip,
            bit_in_chip => bit_in_chip,
            bit_out_chip => bit_out_chip);

end Behavioral;
