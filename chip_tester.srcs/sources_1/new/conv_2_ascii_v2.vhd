----------------------------------------------------------------------------------
-- This blocks translates from the memory to ASCII and shows the letter of the
-- value displayed.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


use work.dictionary.All;

entity conv_2_ascii_v2 is
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
end conv_2_ascii_v2;

architecture Behavioral of conv_2_ascii_v2 is

    function num2ascii (data_in: unsigned (3 downto 0)) return  std_logic_vector is
        variable data: std_logic_vector (7 downto 0);
    begin
        case to_integer(data_in) is
            when 0 => data := zero_ASCII;
            when 1 => data := one_ASCII;   
            when 2 => data := two_ASCII;   
            when 3 => data := three_ASCII;   
            when 4 => data := four_ASCII;   
            when 5 => data := five_ASCII;   
            when 6 => data := six_ASCII;   
            when 7 => data := seven_ASCII;   
            when 8 => data := eight_ASCII;
            when others => data := nine_ASCII;     
        end case;        
        return data;
    end function;
    
    function multiplier2ascii (data_in: unsigned (3 downto 0)) return  std_logic_vector is
        variable data: std_logic_vector (7 downto 0);
    begin
        case data_in is
            when "0001" => data := U_ASCII;
            when "0010" => data := K_ASCII;
            when "0100" => data := N_ASCII;
            when others => data := X_ASCII;
        end case;
        return data;
    end function;

begin
    word ((8*(7+1)-1) downto (8*7) ) <= T_ASCII when (check_running = '1') else
                                        F_ASCII when (en_conf_f = '1') else
                                        C_ASCII when (en_conf_ch = '1') else
                                        N_ASCII when (en_conf_n = '1') else
                                        N_ASCII when (en_num_errors = '1' and check_complete = '1') else
                                        P_ASCII when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;
    


    word ((8*(6+1)-1) downto (8*6) ) <= E_ASCII when (check_running = '1') else
                                        dash_ASCII when (en_conf_f = '1') else
                                        H_ASCII when (en_conf_ch = '1') else
                                        C_ASCII when (en_conf_n = '1') else
                                        E_ASCII when (en_num_errors = '1' and check_complete = '1') else
                                        E_ASCII when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;

    word ((8*(5+1)-1) downto (8*5) ) <= S_ASCII when (check_running = '1') else
                                        num2ascii(disp_5_reg) when (en_conf_f = '1') else
                                        dash_ASCII when (en_conf_ch = '1') else
                                        num2ascii(disp_5_reg) when (en_conf_n = '1') else
                                        dash_ASCII when (en_num_errors = '1' and check_complete = '1') else
                                        dash_ASCII when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;

    word ((8*(4+1)-1) downto (8*4) ) <= T_ASCII when (check_running = '1') else
                                        num2ascii(disp_4_reg) when (en_conf_f = '1') else
                                        dash_ASCII when (en_conf_ch = '1') else
                                        num2ascii(disp_4_reg) when (en_conf_n = '1') else
                                        num2ascii(disp_4_reg) when (en_num_errors = '1' and check_complete = '1') else
                                        dash_ASCII when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;

    word ((8*(3+1)-1) downto (8*3) ) <= dash_ASCII when (check_running = '1') else
                                        num2ascii(disp_3_reg) when (en_conf_f = '1') else
                                        dash_ASCII when (en_conf_ch = '1') else
                                        num2ascii(disp_3_reg) when (en_conf_n = '1') else
                                        num2ascii(disp_3_reg) when (en_num_errors = '1' and check_complete = '1') else
                                        dash_ASCII when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;

    word ((8*(2+1)-1) downto (8*2) ) <= R_ASCII when (check_running = '1') else
                                        num2ascii(disp_2_reg) when (en_conf_f = '1') else
                                        num2ascii(disp_2_reg) when (en_conf_ch = '1') else
                                        num2ascii(disp_2_reg) when (en_conf_n = '1') else
                                        num2ascii(disp_2_reg) when (en_num_errors = '1' and check_complete = '1') else
                                        num2ascii(disp_2_reg) when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;

    word ((8*(1+1)-1) downto (8*1) ) <= U_ASCII when (check_running = '1') else
                                        num2ascii(disp_1_reg) when (en_conf_f = '1') else
                                        num2ascii(disp_1_reg) when (en_conf_ch = '1') else
                                        num2ascii(disp_1_reg) when (en_conf_n = '1') else
                                        num2ascii(disp_1_reg) when (en_num_errors = '1' and check_complete = '1') else
                                        num2ascii(disp_1_reg) when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;

    word ((8*(0+1)-1) downto (8*0) ) <= N_ASCII when (check_running = '1') else
                                        num2ascii(disp_0_reg) when (en_conf_f = '1') else
                                        num2ascii(disp_0_reg) when (en_conf_ch = '1') else
                                        num2ascii(disp_0_reg) when (en_conf_n = '1') else
                                        multiplier2ascii(disp_0_reg) when (en_num_errors = '1' and check_complete = '1') else
                                        num2ascii(disp_0_reg) when (en_p_errors = '1' and check_complete = '1') else
                                        dash_ASCII;


end Behavioral;
