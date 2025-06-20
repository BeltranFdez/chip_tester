----------------------------------------------------------------------------------
-- Top_level: Display in NEXYS A7 some values that can be modified
-- V2 -> Values: Frequency divider & percentage of changes
-- V3 -> Values: Previous + Number of chains
-- V4 -> Error_check
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;


entity VALUES_V4 is
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
end VALUES_V4;

architecture Behavioral of VALUES_V4 is


component clk_wiz_0 
port  ( clk_in1 : in std_logic;
        clk_out1 : out std_logic);
end component;

component debounce_btn
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
end component;

component control_config_v3
    Port ( clk5Mhz: in STD_LOGIC;
           en_conf_f : in STD_LOGIC;
           en_conf_ch : in STD_LOGIC;
           en_conf_n : in STD_LOGIC;
           en_lock : in STD_LOGIC;
           BTNU_stable : in STD_LOGIC;
           BTND_stable : in STD_LOGIC;
           BTNL_stable : in STD_LOGIC;
           BTNR_stable : in STD_LOGIC;
           BTNC_stable : in STD_LOGIC;
           disp_5_in : in unsigned (3 downto 0);
           disp_4_in : in unsigned (3 downto 0);
           disp_3_in : in unsigned (3 downto 0);
           disp_2_in : in unsigned (3 downto 0);
           disp_1_in : in unsigned (3 downto 0);
           disp_0_in : in unsigned (3 downto 0);
           disp_5_out : out unsigned (3 downto 0);
           disp_4_out : out unsigned (3 downto 0);
           disp_3_out : out unsigned (3 downto 0);
           disp_2_out : out unsigned (3 downto 0);
           disp_1_out : out unsigned (3 downto 0);
           disp_0_out : out unsigned (3 downto 0);
           index: out integer range 0 to 5);
end component;

component value_cod_v3
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
end component;

component mem_decod_v1
    Port(en_conf_f : in STD_LOGIC;
         en_conf_ch : in STD_LOGIC;
         en_conf_n : in STD_LOGIC;
         en_num_errors : in STD_LOGIC;
         en_p_errors : in STD_LOGIC;
         check_complete : in STD_LOGIC;
         disp_5 : out unsigned (3 downto 0);
         disp_4 : out unsigned (3 downto 0);
         disp_3 : out unsigned (3 downto 0);
         disp_2 : out unsigned (3 downto 0);
         disp_1 : out unsigned (3 downto 0);
         disp_0 : out unsigned (3 downto 0);
         ch : in unsigned (6 downto 0);
         n_chains : in unsigned (16 downto 0);
         freq_div : in unsigned (16 downto 0);
         num_errors : in unsigned ((max_errors_size - 1) downto 0);
         p_errors : in unsigned (6 downto 0));
end component;

component test_gen_v3
    Port ( clk100MHz : in STD_LOGIC;
           clk_gen : in STD_LOGIC;
           en_lock : in STD_LOGIC;
           ch : in unsigned (6 downto 0);
           n_chains : in unsigned (16 downto 0);
           bit_test : out STD_LOGIC;
           test_running: out STD_LOGIC;
           test_complete : out STD_LOGIC);
end component;

component error_counter_v2
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
end component;

component mem_v4
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
end component;


component gen_freq_v2
    Port ( clk100Mhz : in STD_LOGIC;
           en_lock : in STD_LOGIC;
           div_freq: in unsigned ;
           freq_out : out STD_LOGIC);
end component;

component conv_2_ascii_v2
    Port ( disp_5_reg : in unsigned (3 downto 0);
           disp_4_reg : in unsigned (3 downto 0);
           disp_3_reg : in unsigned (3 downto 0);
           disp_2_reg : in unsigned (3 downto 0);
           disp_1_reg : in unsigned (3 downto 0);
           disp_0_reg : in unsigned (3 downto 0);
           en_conf_f : in STD_LOGIC;
           en_conf_ch : in STD_LOGIC;
           en_conf_n : in STD_LOGIC;
           en_num_errors : in STD_LOGIC;
           en_p_errors : in STD_LOGIC;
           check_running : in STD_LOGIC;
           check_complete : in STD_LOGIC;
           word : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component ASCII_2_7seg
    Port ( word : in STD_LOGIC_VECTOR (63 downto 0);
           w0 : out STD_LOGIC_VECTOR (6 downto 0);
           w1 : out STD_LOGIC_VECTOR (6 downto 0);
           w2 : out STD_LOGIC_VECTOR (6 downto 0);
           w3 : out STD_LOGIC_VECTOR (6 downto 0);
           w4 : out STD_LOGIC_VECTOR (6 downto 0);
           w5 : out STD_LOGIC_VECTOR (6 downto 0);
           w6 : out STD_LOGIC_VECTOR (6 downto 0);
           w7 : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component displayer_7seg
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
end component;

component blinker_v3
    Port (clk5MHZ: in std_logic;
          en_conf_f : in STD_LOGIC;
          en_conf_ch : in STD_LOGIC;
          en_conf_n : in STD_LOGIC;
          en_lock : in STD_LOGIC;
          index : in integer range 0 to 5;
          an_prov : in STD_LOGIC_VECTOR (7 downto 0);
          an : out STD_LOGIC_VECTOR (7 downto 0));
end component;


signal clk5MHz, BTNU_s, BTND_s, BTNL_s, BTNR_s, BTNC_s, freq_gen, test_running_s, check_running_s, check_complete_s: std_logic;
signal a_disp_5, b_disp_5, a_disp_4, b_disp_4, a_disp_3, b_disp_3, a_disp_2, b_disp_2, a_disp_1, b_disp_1, a_disp_0, b_disp_0: unsigned (3 downto 0);
signal s_w0, s_w1, s_w2, s_w3, s_w4, s_w5, s_w6, s_w7: std_logic_vector (6 downto 0);
signal s_word : std_logic_vector (63 downto 0);
signal a_freq_div, b_freq_div, n_chains_s1, n_chains_s2: unsigned (16 downto 0);
signal ch_s1, ch_s2, p_errors_s1, p_errors_s2: unsigned (6 downto 0);
signal index_s: integer range 0 to 5;
signal an_s : std_logic_vector (7 downto 0);
signal num_errors_s1, num_errors_s2 : unsigned ((max_errors_size - 1) downto 0);

begin


CLK_WIZ: clk_wiz_0 port map
    (clk_in1 => CLK100MHZ,
     clk_out1 => clk5MHZ);


DEBOUNCER_BTNs: debounce_btn
    port map ( clk5Mhz => clk5MHz,
               BTNU => BTNU,
               BTND => BTND,
               BTNL => BTNL,
               BTNR => BTNR,
               BTNC => BTNC,
               BTNU_stable => BTNU_s,
               BTND_stable => BTND_s,
               BTNL_stable => BTNL_s,
               BTNR_stable => BTNR_s,
               BTNC_stable => BTNC_s);

VALUE_CODIFIER: value_cod_v3
    port map (en_conf_f => en_conf_f,
         en_conf_ch => en_conf_ch,
         en_conf_n => en_conf_n,
         disp_5 => a_disp_5,
         disp_4 => a_disp_4,
         disp_3 => a_disp_3,
         disp_2 => a_disp_2,
         disp_1 => a_disp_1,
         disp_0 => a_disp_0,
         ch_in => ch_s2,
         ch_out => ch_s1,
         n_chains_in => n_chains_s2,
         n_chains_out => n_chains_s1,
         freq_div_in => b_freq_div,
         freq_div_out => a_freq_div);

MEMORY_DECODIFIER: mem_decod_v1
    port map (en_conf_f => en_conf_f,
         en_conf_ch => en_conf_ch,
         en_conf_n => en_conf_n,
         en_num_errors => en_num_errors,
         en_p_errors => en_p_errors,
         check_complete => check_complete_s,
         disp_5 => b_disp_5,
         disp_4 => b_disp_4,
         disp_3 => b_disp_3,
         disp_2 => b_disp_2,
         disp_1 => b_disp_1,
         disp_0 => b_disp_0,
         ch => ch_s2,
         n_chains => n_chains_s2,
         freq_div => b_freq_div, 
         num_errors => num_errors_s2,
         p_errors => p_errors_s2);

MEM: mem_v4
    port map ( clk5MHz =>clk5MHz,
           BTNC_stable => BTNC_s,
           en_lock => en_lock,
           ch_in => ch_s1,
           ch_out => ch_s2,
           n_chains_in => n_chains_s1,
           n_chains_out => n_chains_s2,
           freq_div_in => a_freq_div,
           freq_div_out => b_freq_div,
           num_errors_in => num_errors_s1,
           num_errors_out => num_errors_s2,
           p_errors_in => p_errors_s1,
           p_errors_out => p_errors_s2);
        

CONTROL_CONFIGURATOR: control_config_v3
    port map(clk5Mhz => clk5MHz,
           en_conf_f => en_conf_f,
           en_conf_ch => en_conf_ch,
           en_conf_n => en_conf_n,
           en_lock => en_lock,
           BTNU_stable => BTNU_s,
           BTND_stable => BTND_s,
           BTNL_stable => BTNL_s,
           BTNR_stable => BTNR_s,
           BTNC_stable => BTNC_s,
           disp_5_in => b_disp_5,
           disp_4_in => b_disp_4,
           disp_3_in => b_disp_3,
           disp_2_in => b_disp_2,
           disp_1_in => b_disp_1,
           disp_0_in => b_disp_0,
           disp_5_out => a_disp_5,
           disp_4_out => a_disp_4,
           disp_3_out => a_disp_3,
           disp_2_out => a_disp_2,
           disp_1_out => a_disp_1,
           disp_0_out => a_disp_0,
           index => index_s);

FREQUENCY_GENERATOR: gen_freq_v2
    port map ( clk100Mhz => CLK100MHZ,
           en_lock => en_lock,
           div_freq => b_freq_div,
           freq_out => freq_gen);
        
TEST_GENERATOR: test_gen_v3
    port map ( clk100MHz => clk100MHz,
           clk_gen => freq_gen,
           en_lock => en_lock,
           ch => ch_s2,
           n_chains => n_chains_s2,
           bit_test => bit_test,
           test_running => test_running_s,
           test_complete => test_complete);



ERROR_CHECK: error_counter_v2
    port map ( clk100MHz => clk100MHz,
           clk_gen => freq_gen,
           en_lock => en_lock,
           ch => ch_s2,
           n_chains => n_chains_s2,
           bit_chip => bit_chip,
           num_errors => num_errors_s1,
           p_errors => p_errors_s1,
           check_running => check_running_S,
           check_complete => check_complete_s);

--Display blocks
CONVERT_TO_ASCII: conv_2_ascii_v2
    port map (disp_5_reg => b_disp_5,
           disp_4_reg => b_disp_4,
           disp_3_reg => b_disp_3,
           disp_2_reg => b_disp_2,
           disp_1_reg => b_disp_1,
           disp_0_reg => b_disp_0,
           en_conf_f => en_conf_f,
           en_conf_ch => en_conf_ch,
           en_conf_n => en_conf_n,
           en_num_errors => en_num_errors,
           en_p_errors => en_p_errors,
           check_running => check_running_s,
           check_complete => check_complete_s,
           word => s_word);
        
 ASCII_TO_7SEG: ASCII_2_7seg 
    port map (
        word => s_word,
        w0 => s_w0,
        w1 => s_w1,
        w2 => s_w2,
        w3 => s_w3,
        w4 => s_w4,
        w5 => s_w5,
        w6 => s_w6,
        w7 => s_w7);
        
SEG7_TO_DISPLAYER: displayer_7seg
    port map (
        p0 => s_w0,
        p1 => s_w1,
        p2 => s_w2,
        p3 => s_w3,
        p4 => s_w4,
        p5 => s_w5,
        p6 => s_w6,
        p7 => s_w7,
        clk5MHz => clk5MHz,
        an_prov => an_s,
        sg => sg);

BLINKER: blinker_v3
    port map (
        clk5MHZ => clk5MHz,
        en_conf_f => en_conf_f,
        en_conf_ch => en_conf_ch,
        en_conf_n => en_conf_n,
        en_lock => en_lock,
        index => index_s,
        an_prov => an_s,
        an => an);

check_running <= check_running_s;
check_complete <= check_complete_s;
test_running <= test_running_s;
freq_generated <= freq_gen;
chip_enable <= check_running_s or test_running_s;

end Behavioral;
