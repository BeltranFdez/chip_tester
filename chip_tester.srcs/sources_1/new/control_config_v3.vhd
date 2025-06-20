----------------------------------------------------------------------------------
-- This block allows to change values such as frequency using the display
-- V2 -> Values: Frequency divider & percentage of changes
-- V3 -> Values: Previous + Number of chains
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.dictionary.All;

entity control_config_v3 is
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
end control_config_v3;

architecture Behavioral of control_config_v3 is

type state_type1 is (origin1, idle1, scrollable);
type state_type2 is (origin2, idle2, changeable);
signal current_state1, next_state1: state_type1;
signal current_state2, next_state2: state_type2;
signal index_reg, index_next : integer range 0 to 5;
--signal disp_5_reg, disp_4_reg, disp_3_reg, disp_2_reg, disp_1_reg, disp_0_reg, disp_5_next, disp_4_next, disp_3_next, disp_2_next, disp_1_next, disp_0_next: unsigned (3 downto 0);


    function add (reg: unsigned (3 downto 0)) return unsigned is   
        variable data: unsigned (3 downto 0);
    begin
        if (reg < 9) then
            data := reg + 1;
        else 
            data := (others => '0');
        end if;
        return data;
    end function;

    function substract (reg: unsigned (3 downto 0)) return unsigned is   
        variable data: unsigned (3 downto 0);
    begin
        if (reg = 0) then
            data := reg + 9;
        else 
            data := reg - 1;
        end if;
        return data;
    end function;

    function swap (reg: unsigned (3 downto 0)) return unsigned is 
        variable data: unsigned (3 downto 0);
    begin   
        if (reg = 1) then
            data:= reg - 1;
        else 
            data := reg + 1;
        end if;
        return data;
    end function;

begin

SEQ_PROC : process (clk5MHz, BTNC_stable, en_lock)
begin
    if (BTNC_stable = '1' and en_lock = '0') then 
        current_state1 <= origin1;
        current_state2 <= origin2;
        index_reg <= 0;
--        disp_5_reg <= (others => '0');
--        disp_4_reg <= (others => '0');
--        disp_3_reg <= (others => '0');
--        disp_2_reg <= (others => '0');
--        disp_1_reg <= (others => '0');
--        disp_0_reg <= (others => '0');
    else 
        if rising_edge(clk5MHz) then
            current_state1 <= next_state1; 
            current_state2 <= next_state2; 
            index_reg <= index_next;
--            disp_5_reg <= disp_5_next;
--            disp_4_reg <= disp_4_next;
--            disp_3_reg <= disp_3_next;
--            disp_2_reg <= disp_2_next;
--            disp_1_reg <= disp_1_next;
--            disp_0_reg <= disp_0_next;
        end if;
    end if;
end process;

STATE_MACHINE_1_PROCESS: process (current_state1, next_state1, BTNR_stable, BTNL_stable, index_reg, en_conf_f, en_conf_ch, en_conf_n, en_lock)
begin
    index_next <= index_reg;
    case (current_state1) is
    -- ORIGIN --
        when origin1 => 
            index_next <= 0;
            next_state1 <= idle1;
    -- IDLE --
        when idle1 => 
            if ((en_conf_f = '1' or en_conf_ch = '1' or en_conf_n = '1') and (en_lock = '0')) then
                next_state1 <= scrollable;
                index_next <= 0;
            else 
                next_state1 <= idle1;
            end if;
    -- SCROLLABLE --
        when scrollable => 
            if (en_lock = '0') then
                if (en_conf_f = '1' or en_conf_n = '1') then
                -- There are 6 displays available (0-5) for the frequency divider and the number of chains
                    if (BTNR_stable = '1') then
                        if (index_reg = 0) then
                            index_next <= 5;
                        else 
                            index_next <= index_reg - 1;
                        end if;
                    elsif (BTNL_stable = '1') then
                        if (index_reg = 5) then
                            index_next <= 0;
                        else 
                            index_next <= index_reg + 1;
                        end if;
                    end if;
                    next_state1 <= scrollable;                   
                elsif (en_conf_ch = '1') then
                -- There are 3 displays available (0-2) for the frequency divider
                    if (BTNR_stable = '1') then
                        if (index_reg = 0) then
                            index_next <= 2;
                        else 
                            index_next <= index_reg - 1;
                        end if;
                    elsif (BTNL_stable = '1') then
                        if (index_reg = 2) then
                            index_next <= 0;
                        else 
                            index_next <= index_reg + 1;
                        end if;
                    end if;
                    next_state1 <= scrollable;
                else 
                    next_state1 <= idle1;
                end if;
            else 
                next_state1 <= idle1;
            end if;
    end case;
end process;

STATE_MACHINE_2_PROCESS: process (current_state2, next_state2, BTNU_stable, BTND_stable, index_reg, en_conf_f, en_conf_ch, en_conf_n, en_lock, disp_0_in, disp_1_in, disp_2_in, disp_3_in, disp_4_in, disp_5_in)
begin
    disp_0_out <= disp_0_in;
    disp_1_out <= disp_1_in;
    disp_2_out <= disp_2_in;
    disp_3_out <= disp_3_in;
    disp_4_out <= disp_4_in;
    disp_5_out <= disp_5_in;
    case (current_state2) is
    -- ORIGIN --
        when origin2 => 
            next_state2 <= idle2;
            disp_0_out <= (others => '0');
            disp_1_out <= (others => '0');
            disp_2_out <= (others => '0');
            disp_3_out <= (others => '0');
            disp_4_out <= (others => '0');
            disp_5_out <= (others => '0');
    -- IDLE --
        when idle2 =>
            if ((en_conf_f = '1' or en_conf_ch = '1' or en_conf_n = '1') and (en_lock = '0')) then
                next_state2 <= changeable;
            else 
                next_state2 <= idle2;
            end if;
    -- CHANGEABLE --
        when changeable => 
            if (en_lock = '0') then
                if (en_conf_f = '1' or en_conf_n = '1') then
                -- The frequency divider and the number of chains can go from 0 to 100000
                    if (BTNU_stable = '1') then
                        if (disp_5_in = 1) then
                            disp_5_out <= swap(disp_5_in);
                        end if;
                        case (index_reg) is
                            when 0 => disp_0_out <= add(disp_0_in);
                            when 1 => disp_1_out <= add(disp_1_in);
                            when 2 => disp_2_out <= add(disp_2_in);
                            when 3 => disp_3_out <= add(disp_3_in);
                            when 4 => disp_4_out <= add(disp_4_in);
                            when 5 => 
                                disp_5_out <= swap(disp_5_in);
                                disp_4_out <= (others => '0');
                                disp_3_out <= (others => '0');
                                disp_2_out <= (others => '0');
                                disp_1_out <= (others => '0');
                                disp_0_out <= (others => '0');                            
                            when others => null; -- Does nothing
                        end case;
                    elsif (BTND_stable = '1') then
                        if (disp_5_in = 1) then
                            disp_5_out <= swap(disp_5_in);
                        end if;
                        case (index_reg) is
                            when 0 => disp_0_out <= substract(disp_0_in);
                            when 1 => disp_1_out <= substract(disp_1_in);
                            when 2 => disp_2_out <= substract(disp_2_in);
                            when 3 => disp_3_out <= substract(disp_3_in);
                            when 4 => disp_4_out <= substract(disp_4_in);
                            when 5 => 
                                disp_5_out <= swap(disp_5_in);
                                disp_4_out <= (others => '0');
                                disp_3_out <= (others => '0');
                                disp_2_out <= (others => '0');
                                disp_1_out <= (others => '0');
                                disp_0_out <= (others => '0');                            
                            when others => null; -- Does nothing
                        end case;
                    end if;
                    next_state2 <= changeable;
                elsif (en_conf_ch = '1') then
                -- The percentage of changes con go from 0 to 100
                    if (BTNU_stable = '1') then
                        if (disp_2_in = 1) then
                            disp_2_out <= swap(disp_2_in);
                        end if;
                        case (index_reg) is
                            when 0 => disp_0_out <= add(disp_0_in);
                            when 1 => disp_1_out <= add(disp_1_in);
                            when 2 => 
                                disp_2_out <= swap(disp_2_in);
                                disp_1_out <= (others => '0');
                                disp_0_out <= (others => '0');                            
                            when others => null; -- Does nothing
                        end case;
                    elsif (BTND_stable = '1') then
                        if (disp_2_in = 1) then
                            disp_2_out <= swap(disp_2_in);
                        end if;
                        case (index_reg) is
                            when 0 => disp_0_out <= substract(disp_0_in);
                            when 1 => disp_1_out <= substract(disp_1_in);
                            when 2 => 
                                disp_2_out <= swap(disp_2_in);
                                disp_1_out <= (others => '0');
                                disp_0_out <= (others => '0');                            
                            when others => null; -- Does nothing
                        end case;
                    end if;
                    next_state2 <= changeable;
                else    
                    next_state2 <= idle2;
                end if;
        else 
            next_state2 <= idle2;
        end if;
    end case;
end process;

index <= index_reg;
--disp_5_out <= disp_5_reg;
--disp_4_out <= disp_4_reg;
--disp_3_out <= disp_3_reg;
--disp_2_out <= disp_2_reg;
--disp_1_out <= disp_1_reg;
--disp_0_out <= disp_0_reg;

end Behavioral;
