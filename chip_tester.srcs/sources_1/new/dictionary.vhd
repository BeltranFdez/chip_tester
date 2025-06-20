----------------------------------------------------------------------------------
-- Library
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package dictionary is

    -- Miscelaneous
    constant freq_max : unsigned(16 downto 0) := "11000011010100000"; -- Max frequency of the fpga 100MHz
    constant seed_max : integer := 2147483647; -- Max value of the uniform's function seed
    constant reg_num_chip : integer := 5; -- Number of registers in the chip
    constant max_errors_size : integer := 24; -- 100*100000 = 10e^7 < 2e^24
    constant max_num_errors_digs_size : integer := 14; -- 9999 < 2e^14
    constant multiplier_size : integer := 3; 
    constant one_hundred_size : integer := 7; -- 100 < 2e^7
    constant one_hundred_thousand_size : integer := 17; -- 100000 < 2e^17

    -- Clocks counts
    constant one_sec : std_logic_vector (22 downto 0) := "10011000100101101000000"; --5e6 counts of 5MHz equals 1s
    constant half_sec : std_logic_vector (21 downto 0) := "1001100010010110100000"; --2,5e6 counts of 5MHz equals 0,5s
    constant Hz100 : std_logic_vector(15 downto 0) := "1100001101010000"; --5e4 counts of 5MHz equals 10ms or 100Hz
    constant Hz800 : std_logic_vector(15 downto 0) := "0001100001101010"; --6250 counts of 5MHz equals 1,25ms or 800Hz
    constant debounce_count : integer := 250000; --50 ms at 5MHz
    constant debounce_count_4_testing : integer := 3;


    -- 7 seg numbers
    constant zero_7seg : std_logic_vector(6 downto 0) := "1000000";
    constant one_7seg : std_logic_vector(6 downto 0) := "1111001";
    constant two_7seg : std_logic_vector(6 downto 0) := "0100100";
    constant three_7seg : std_logic_vector(6 downto 0) := "0110000";
    constant four_7seg : std_logic_vector(6 downto 0) := "0011001";
    constant five_7seg : std_logic_vector(6 downto 0) := "0010010";
    constant six_7seg : std_logic_vector(6 downto 0) := "0000010";
    constant seven_7seg : std_logic_vector(6 downto 0) := "1111000";
    constant eight_7seg : std_logic_vector(6 downto 0) := "0000000";
    constant nine_7seg : std_logic_vector(6 downto 0) := "0010000";
    
    -- 7 seg letters
    constant A_7seg : std_logic_vector(6 downto 0) := "0001000";
    constant B_7seg : std_logic_vector(6 downto 0) := "0000011";
    constant C_7seg : std_logic_vector(6 downto 0) := "1000110";
    constant D_7seg : std_logic_vector(6 downto 0) := "0100001";
    constant E_7seg : std_logic_vector(6 downto 0) := "0000110";
    constant F_7seg : std_logic_vector(6 downto 0) := "0001110";
    constant G_7seg : std_logic_vector(6 downto 0) := "1000010";
    constant H_7seg : std_logic_vector(6 downto 0) := "0001011";
    constant I_7seg : std_logic_vector(6 downto 0) := "1111011";
    constant J_7seg : std_logic_vector(6 downto 0) := "1100001";
    constant K_7seg : std_logic_vector(6 downto 0) := "0001010";
    constant L_7seg : std_logic_vector(6 downto 0) := "1000111";
    constant N_7seg : std_logic_vector(6 downto 0) := "0101011";
    constant O_7seg : std_logic_vector(6 downto 0) := "0100011";
    constant P_7seg : std_logic_vector(6 downto 0) := "0001100";
    constant Q_7seg : std_logic_vector(6 downto 0) := "0011000";
    constant R_7seg : std_logic_vector(6 downto 0) := "0101111";
    constant S_7seg : std_logic_vector(6 downto 0) := "0010010";
    constant T_7seg : std_logic_vector(6 downto 0) := "0000111";
    constant U_7seg : std_logic_vector(6 downto 0) := "1000001";
    constant V_7seg : std_logic_vector(6 downto 0) := "1100011";
    constant X_7seg : std_logic_vector(6 downto 0) := "0001001";
    constant Y_7seg : std_logic_vector(6 downto 0) := "0010001";
    

    
    -- 7 seg dash
    constant dash_7seg : std_logic_vector(6 downto 0) := "0111111";
    
    -- ASCII numbers
    constant zero_ASCII : std_logic_vector(7 downto 0) := "00110000";
    constant one_ASCII : std_logic_vector(7 downto 0) := "00110001";
    constant two_ASCII : std_logic_vector(7 downto 0) :=  "00110010";
    constant three_ASCII : std_logic_vector(7 downto 0) :=  "00110011";
    constant four_ASCII : std_logic_vector(7 downto 0) :=  "00110100";
    constant five_ASCII : std_logic_vector(7 downto 0) :=  "00110101";
    constant six_ASCII : std_logic_vector(7 downto 0) :=  "00110110";
    constant seven_ASCII : std_logic_vector(7 downto 0) :=  "00110111";
    constant eight_ASCII : std_logic_vector(7 downto 0) :=  "00111000";
    constant nine_ASCII : std_logic_vector(7 downto 0) :=  "00111001";
    
    -- ASCII dash
    constant dash_ASCII : std_logic_vector(7 downto 0) := "00101101";  
    
    -- ASCII letters
    constant A_ASCII : std_logic_vector(7 downto 0) := "01000001";
    constant B_ASCII : std_logic_vector(7 downto 0) := "01000010";
    constant C_ASCII : std_logic_vector(7 downto 0) := "01000011";
    constant D_ASCII : std_logic_vector(7 downto 0) := "01000100";
    constant E_ASCII : std_logic_vector(7 downto 0) := "01000101";
    constant F_ASCII : std_logic_vector(7 downto 0) := "01000110";
    constant G_ASCII : std_logic_vector(7 downto 0) := "01000111";
    constant H_ASCII : std_logic_vector(7 downto 0) := "01001000";
    constant I_ASCII : std_logic_vector(7 downto 0) := "01001001";
    constant J_ASCII : std_logic_vector(7 downto 0) := "01001010";
    constant K_ASCII : std_logic_vector(7 downto 0) := "01001011";
    constant L_ASCII : std_logic_vector(7 downto 0) := "01001100";
    constant N_ASCII : std_logic_vector(7 downto 0) := "01001110";
    constant O_ASCII : std_logic_vector(7 downto 0) := "01001111";
    constant P_ASCII : std_logic_vector(7 downto 0) := "01010000";
    constant Q_ASCII : std_logic_vector(7 downto 0) := "01010001";
    constant R_ASCII : std_logic_vector(7 downto 0) := "01010010";
    constant S_ASCII : std_logic_vector(7 downto 0) := "01010011";
    constant T_ASCII : std_logic_vector(7 downto 0) := "01010100";
    constant U_ASCII : std_logic_vector(7 downto 0) := "01010101";
    constant V_ASCII : std_logic_vector(7 downto 0) := "01010110";
    constant X_ASCII : std_logic_vector(7 downto 0) := "01011000";
    constant Y_ASCII : std_logic_vector(7 downto 0) := "01011001";
    
end package dictionary;
