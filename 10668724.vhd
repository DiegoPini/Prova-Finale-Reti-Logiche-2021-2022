library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity project_reti_logiche is
port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_data : in std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    o_en : out std_logic;
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;


architecture Behavioral of project_reti_logiche is
        signal o_end : std_logic;
        signal rest_sel : std_logic;
        signal i_data_addr : std_logic_vector(15 downto 0);
        signal i_data_addr_next : std_logic_vector(15 downto 0);
        signal o_reg1 : std_logic_vector(7 downto 0);
        signal mux_reg1 : std_logic_vector(7 downto 0);
        signal sub : std_logic_vector(7 downto 0);
        signal rit1 : std_logic_vector(7 downto 0);
        signal rit2 : std_logic_vector(7 downto 0);
        signal ris1 : std_logic_vector(7 downto 0);
        signal ris2 : std_logic_vector(7 downto 0);
        signal temp : std_logic_vector(7 downto 0);
        signal o_addr :std_logic_vector(15 downto 0);
        signal o_addr_next :std_logic_vector(15 downto 0);
        signal rest: std_logic_vector(1 downto 0);
        signal old_rest: std_logic_vector(1 downto 0);
        type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15);
        SIGNAL curr_state, next_state : S;
       
begin
process(i_clk, i_rst)
begin
    if(i_rst = '1') then
                    o_en <= '0';
                    o_we <= '0';
                    o_end <= '0';
                    o_done <= '0';
                    o_address <= "0000000000000000";
                    i_data_addr<= "0000000000000001";
                    i_data_addr_next<= "0000000000000001";
                    o_addr <=  "0000001111101000";
                    o_addr_next <=  "0000001111101000";
                    o_data  <= "00000000";          
                    sub <= "00000000";
                    rit1 <= "00000000";
                    rit2 <= "00000000";
                    temp <= "00000000";
                    mux_reg1 <= "00000000";
                    ris1 <= "00000000";
                    ris2 <= "00000000";
                    o_reg1 <= "00000000";
        curr_state <= S0;
        next_state <= S0;
   
    elsif i_clk' event and i_clk = '1' then
        curr_state <= next_state;
       
        case curr_state is
                when S0 =>
                        o_en <= '0';
                        o_we <= '0';
                        o_end <= '0';
                        o_done <= '0';
                        o_address <= "0000000000000000";
                        i_data_addr<= "0000000000000001";
                        i_data_addr_next<= "0000000000000001";
                        o_addr <=  "0000001111101000";
                        o_addr_next <=  "0000001111101000";
                        o_data  <= "00000000";          
                        sub <= "00000000";
                        rit1 <= "00000000";
                        rit2 <= "00000000";
                        temp <= "00000000";
                        mux_reg1 <= "00000000";
                        ris1 <= "00000000";
                        ris2 <= "00000000";
                        o_reg1 <= "00000000";
                       
       
                    if i_start = '1'  then
                    next_state <= S1;
                    end if;
                   
                when S1 =>
                    o_en <= '1';
                   
                    next_state <= S2;
               
                when S2 =>
                   
                    rest_sel <= '0';
                   
                    mux_reg1 <= i_data;
                   
                    next_state <= S3;
               
               when S3 =>
                     o_en <= '1';
                     o_address <= i_data_addr;
                           
                     i_data_addr_next <= i_data_addr + "0000000000000001";
                     
                     next_state <= S4;
                     
               when S4 =>
                   
                    if(mux_reg1 = "00000000") then
                                       o_end <= '1';
                                  else
                                       o_end<= '0';
                                  end if;
                             
                   
                    next_state <= S5;
               
               when S5 =>
                   
                    i_data_addr <= i_data_addr_next;
                   
                    o_reg1 <= i_data;
                   
                    rest  <= i_data(1 downto 0);
                             
                    if(o_end = '0') then
                             next_state <= S6;
                     else
                             next_state <= S15;
                     end if;
                 
               when S6 =>  
                   
                   if(rest_sel = '0') then
                   rit1 <= "0" & o_reg1(7 downto 1);
                   rit2 <= "00" & o_reg1(7 downto 2);
                   else
                   rit1 <= old_rest(0)  & o_reg1(7 downto 1);
                   rit2 <= old_rest(1 downto 0) & o_reg1(7 downto 2);
                   end if;
                   next_state <= S7;
                   
               when S7 =>
               
                    ris1 <= o_reg1 xor rit2;
                    temp <= o_reg1 xor rit1;
                   
                    next_state <= S8;
                   
               when S8 =>
                   
                   
                    ris2 <= temp xor rit2;
             
                    next_state <= S9;
                   
               when S9 =>
       
                   
                    o_address <= o_addr;
                    o_data <=  ris1(7) & ris2(7) & ris1(6) & ris2(6) & ris1(5) & ris2(5) & ris1(4) & ris2(4);            
                    o_addr_next <= o_addr + "0000000000000001";
                    o_we <= '1';
                   
                   
                   
                    next_state <= S10;          
                     
               when S10 =>
                    o_addr <= o_addr_next;
                     
                    sub <= mux_reg1 - "00000001";
                   
                    next_state <= S11;
                   
               when S11 =>    
                    o_address <= o_addr;
                    o_data <=  ris1(3) & ris2(3) & ris1(2) & ris2(2) & ris1(1) & ris2(1) & ris1(0) & ris2(0);
                    o_addr_next <= o_addr + "0000000000000001";
                    o_we <= '1';
                   
                    next_state <= S12;
           
               when S12 =>
                   o_we <= '0';
                    o_en <= '0';
   
                    next_state <= S13;
               
               when S13 =>
                   
                    o_addr <= o_addr_next;
                         
                    mux_reg1 <= sub;
                   
                   
                    next_state <= S14;
               
               when S14 =>
                       
                       
             
                     if(mux_reg1 = "00000000") then
                            o_end <= '1';
                      else  
                            o_end<= '0';
                      end if;
               
                   next_state <= S15;
               
               when S15 =>
                    if(o_end = '1') then
                        o_done <= '1';
                        next_state <= S0;
                    else
                        old_rest  <= rest;
                        rest_sel <= '1';
                        next_state <= S3;
                    end if;
             end case;
    end if;
end process;




end architecture;