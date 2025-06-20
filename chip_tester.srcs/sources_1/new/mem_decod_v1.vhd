----------------------------------------------------------------------------------
-- This block decodifies from memory to display
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;

entity mem_decod_v1 is
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
end mem_decod_v1;

architecture Behavioral of mem_decod_v1 is

    function decodify (reg: unsigned; pos: integer) return unsigned is   
        variable sig: unsigned (19 downto 0);
        variable data: unsigned (3 downto 0);
    begin
        sig := ((resize(reg,20) rem (pos * 10)) / pos);
        data := sig (3 downto 0);
        return data;
    end function;

function reduce (reg : unsigned) return unsigned is
    variable result : unsigned(((max_num_errors_digs_size + multiplier_size)-1) downto 0);
    variable tmp    : unsigned((max_errors_size-1) downto 0);
begin
    result := (others => '0');
    if reg < to_unsigned(10000, max_errors_size) then
        result := "001" & reg((max_num_errors_digs_size - 1) downto 0);
    elsif (reg < to_unsigned(10000000, max_errors_size)) then
        tmp    := (reg/to_unsigned(1000, max_errors_size));
        result := "010" & tmp((max_num_errors_digs_size - 1) downto 0);
    else
        tmp    := (reg/to_unsigned(1000000, max_errors_size));
        result := "100" & tmp((max_num_errors_digs_size - 1) downto 0);
    end if;
    return result;
end function;


signal num_errors_reduced: unsigned (((max_num_errors_digs_size + multiplier_size)-1) downto 0);
signal num_errors_digs: unsigned ((max_num_errors_digs_size - 1) downto 0); -- max_num_errors_digs_size = 14
signal multiplier: unsigned ((multiplier_size-1) downto 0); -- multiplier_size = 3

begin

num_errors_reduced <= reduce(num_errors);
num_errors_digs <= num_errors_reduced ((max_num_errors_digs_size - 1) downto 0);
multiplier <= num_errors_reduced(((max_num_errors_digs_size + multiplier_size)-1) downto (max_num_errors_digs_size));

disp_5 <= decodify(freq_div, 100000) when (en_conf_f = '1') else
          decodify(n_chains, 100000) when (en_conf_n = '1') else
          (others => '0');
disp_4 <= decodify(freq_div, 10000) when (en_conf_f = '1') else
          decodify(n_chains, 10000) when (en_conf_n = '1') else
          decodify(num_errors_digs, 1000) when (en_num_errors = '1' and check_complete = '1') else
          (others => '0');
disp_3 <= decodify(freq_div, 1000) when (en_conf_f = '1') else
          decodify(n_chains, 1000) when (en_conf_n = '1') else
          decodify(num_errors_digs, 100) when (en_num_errors = '1' and check_complete = '1') else
          (others => '0');
disp_2 <= decodify(freq_div, 100) when (en_conf_f = '1') else
          decodify(ch,100) when (en_conf_ch = '1') else
          decodify(n_chains, 100) when (en_conf_n = '1') else
          decodify(num_errors_digs, 10) when (en_num_errors = '1' and check_complete = '1') else
          decodify(p_errors, 100) when (en_p_errors = '1' and check_complete = '1') else
          (others => '0');
disp_1 <= decodify(freq_div, 10) when (en_conf_f = '1') else
          decodify(ch,10) when (en_conf_ch = '1') else
          decodify(n_chains, 10) when (en_conf_n = '1') else
          decodify(num_errors_digs, 1) when (en_num_errors = '1' and check_complete = '1') else
          decodify(p_errors, 10) when (en_p_errors = '1' and check_complete = '1') else
          (others => '0');
disp_0 <= decodify(freq_div, 1) when (en_conf_f = '1') else
          decodify(ch,1) when (en_conf_ch = '1') else
          decodify(n_chains, 1) when (en_conf_n = '1') else
          ('0' & multiplier) when (en_num_errors = '1' and check_complete = '1') else
          decodify(p_errors, 1) when (en_p_errors = '1' and check_complete = '1') else
          (others => '0');

end Behavioral;
