----------------------------------------------------------------------------------
-- This block receives a 64 bits word in ASCII and divides it in 8 bits words 
-- in 7seg format
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.dictionary.All;


entity ASCII_2_7seg is
    Port ( word : in STD_LOGIC_VECTOR (63 downto 0);
           w0 : out STD_LOGIC_VECTOR (6 downto 0);
           w1 : out STD_LOGIC_VECTOR (6 downto 0);
           w2 : out STD_LOGIC_VECTOR (6 downto 0);
           w3 : out STD_LOGIC_VECTOR (6 downto 0);
           w4 : out STD_LOGIC_VECTOR (6 downto 0);
           w5 : out STD_LOGIC_VECTOR (6 downto 0);
           w6 : out STD_LOGIC_VECTOR (6 downto 0);
           w7 : out STD_LOGIC_VECTOR (6 downto 0));
end ASCII_2_7seg;

architecture Behavioral of ASCII_2_7seg is

    function ascii27seg (data_in : std_logic_vector (7 downto 0)) return std_logic_vector is
        variable data_out: std_logic_vector (6 downto 0);
    begin   
        case data_in is 
            when zero_ASCII => data_out := zero_7seg;
            when one_ASCII => data_out := one_7seg;
            when two_ASCII => data_out := two_7seg;
            when three_ASCII => data_out := three_7seg;
            when four_ASCII => data_out := four_7seg;
            when five_ASCII => data_out := five_7seg;
            when six_ASCII => data_out := six_7seg;
            when seven_ASCII => data_out := seven_7seg;
            when eight_ASCII => data_out := eight_7seg;
            when nine_ASCII => data_out := nine_7seg;
            when dash_ASCII => data_out := dash_7seg;
            when A_ASCII => data_out := A_7seg;
            when B_ASCII => data_out := B_7seg;
            when C_ASCII => data_out := C_7seg;
            when D_ASCII => data_out := D_7seg;
            when E_ASCII => data_out := E_7seg;    
            when F_ASCII => data_out := F_7seg;
            when G_ASCII => data_out := G_7seg;
            when H_ASCII => data_out := H_7seg;
            when I_ASCII => data_out := I_7seg;
            when J_ASCII => data_out := J_7seg;
            when K_ASCII => data_out := K_7seg;
            when L_ASCII => data_out := L_7seg;
            when N_ASCII => data_out := N_7seg;
            when O_ASCII => data_out := O_7seg;
            when P_ASCII => data_out := P_7seg;
            when Q_ASCII => data_out := Q_7seg;
            when R_ASCII => data_out := R_7seg;
            when S_ASCII => data_out := S_7seg;
            when T_ASCII => data_out := T_7seg;
            when U_ASCII => data_out := U_7seg;
            when V_ASCII => data_out := V_7seg;
            when X_ASCII => data_out := X_7seg;
            when Y_ASCII => data_out := Y_7seg;
            when others => data_out := U_7seg;
        end case;
        return data_out;
    end function;    

begin

    w7 <= ascii27seg(word( (8*(7+1)-1) downto (8*7) ));
    w6 <= ascii27seg(word( (8*(6+1)-1) downto (8*6) ));
    w5 <= ascii27seg(word( (8*(5+1)-1) downto (8*5) ));
    w4 <= ascii27seg(word( (8*(4+1)-1) downto (8*4) ));
    w3 <= ascii27seg(word( (8*(3+1)-1) downto (8*3) ));
    w2 <= ascii27seg(word( (8*(2+1)-1) downto (8*2) ));
    w1 <= ascii27seg(word( (8*(1+1)-1) downto (8*1) ));
    w0 <= ascii27seg(word( (8*(0+1)-1) downto (8*0) ));

--    with word(63 downto 56) select 
--        w7 <= cero_7seg when cero_ASCII,
--              uno_7seg when uno_ASCII,
--              dos_7seg when dos_ASCII,
--              tres_7seg when tres_ASCII,
--              cuatro_7seg when cuatro_ASCII,
--              cinco_7seg when cinco_ASCII,
--              seis_7seg when seis_ASCII,
--              siete_7seg when siete_ASCII,
--              ocho_7seg when ocho_ASCII,
--              nueve_7seg when nueve_ASCII,
--              guion_7seg when guion_ASCII,
--              U_7seg when others;

end Behavioral;
