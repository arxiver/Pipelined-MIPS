library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity fetch_stage is
    generic (n:integer := 16);
    port(       
            initial : in std_logic;
            Clk ,reset : in std_logic;
            correct_branch_address,address2,mux8_output,read_data_1,predicted_branch_address : in std_logic_vector(15 downto 0);
            miss_prediction,int_fsm,func,branch,branch_prediction,stalling : in std_logic;    
            interrupt : in std_logic ;         
            finish_interrupt : in std_logic ;       
            hold_to_complete_out :out std_logic;
            out_IR :out  std_logic_vector(31 downto 0);    
            out_PC :out  std_logic_vector(31 downto 0);
            PUSH_PC : out std_logic 
        );
end entity;


architecture fetch_stage_arch of fetch_stage is 
component ins_ram is
    port(
            Initial :in std_logic;
            Clk,Wr,Re : in std_logic;
            PC : in std_logic_vector(31 downto 0);
            DataIn: in std_logic_vector(15 downto 0);
            DataOut : out std_logic_vector(15 downto 0)           
        );
end component;


   signal IR : std_logic_vector(31 downto 0);
   signal prev_IR_16_bit : std_logic_vector(15 downto 0);     
   signal bit_IR_16 : std_logic_vector(15 downto 0);
   signal PC :std_logic_vector(31 downto 0);
   signal IR_enable : std_logic;
   signal IR_reset : std_logic;
   signal PC_enable : std_logic;
   signal PC_reset : std_logic;
   signal full_reset : std_logic;
   signal hold_to_complete : std_logic; 
   signal hold_to_load_interrupt_address : std_logic ;
   signal done_load_address : std_logic ;
   signal PC_BEFORE_INTERRUPT : std_logic_vector (31 downto 0) := (OTHERS => '0');

begin
full_reset <= initial or reset;
ram : ins_ram port map(initial,Clk,'0','1',PC,(others => '0'),bit_IR_16);  
hold_to_complete_out <=hold_to_complete;
out_IR <= IR;
out_PC <= PC;
process(Clk)
   variable hold_to_load_reset_address : std_logic ;
begin
if(rising_edge(Clk))then
    if(initial = '1') then
        IR <= (OTHERS => '0' );
        PC <= (OTHERS => '0' );
        IR_enable <= '1';
        IR_reset <= '0';
        PC_enable <= '1';
        PC_reset <= '0';
    elsif reset = '1' then 
    hold_to_load_reset_address := '1';
    PC <=  (OTHERS => '0' );
        PC_enable <= '1';
        PC_reset <= '0';
    elsif interrupt = '1' then 
        if (hold_to_complete = '1') then
            out_PC <= PC - 1 ;
        else 
            out_PC <= PC ;
        end if;
	    PC <=  "00000000000000000000000000000001";  -- interrupt start address
        PC_enable <= '1';
        PC_reset <= '0';
        PUSH_PC <= '1';
        IR <=  "10000000000000000000000000000000";
        hold_to_load_interrupt_address <= '1';
    else
        if hold_to_complete = '0' then    
            if miss_prediction ='1' then  
                PC <=  "0000000000000000" & correct_branch_address;
            elsif int_fsm = '1' then
                PC <=  "0000000000000000" & address2;
            elsif func = '1' then
                PC <=  "0000000000000000" & mux8_output;
            elsif branch = '1' then
                PC <=  "0000000000000000" & read_data_1;
            elsif branch_prediction ='1'  then
                PC <= predicted_branch_address;
            elsif stalling = '1' then
                PC <= PC;
            else 
                PC <= PC +1;
            end if;    
        else 
        PC <= PC+1;    
        end if;
    end if;
else if (falling_edge(clk)) then
      done_load_address <= '0';
      if (hold_to_load_reset_address = '1') then
      PC <=  "0000000000000000" & bit_IR_16 ;
      hold_to_load_reset_address := '0';
      done_load_address <= '1';
      elsif (hold_to_load_interrupt_address = '1') then
        PC_BEFORE_INTERRUPT <= PC ;
        PC <=  "0000000000000000" & bit_IR_16 ;
        hold_to_load_interrupt_address <= '0';
        done_load_address <= '1';
      elsif (finish_interrupt = '1') then
        PC <= PC_BEFORE_INTERRUPT ;
      elsif(hold_to_complete = '0')then 
        IR <=  bit_IR_16 & "0000000000000000" ;    
        prev_IR_16_bit <= bit_IR_16;
         if ((bit_IR_16(15 downto 11) = "10010")  	--LDM
					OR (bit_IR_16(15 downto 11) = "10011") --LDD
					OR (bit_IR_16(15 downto 11) = "10100") --STD
					OR (bit_IR_16(15 downto 11) = "01010") --IADD
					OR (bit_IR_16(15 downto 11) = "01110")   --SHL
                    OR (bit_IR_16(15 downto 11) = "01111")) then   --SHR     
                    hold_to_complete <= '1';
                    IR <= "00000000000000000000000000000000";
        else 
        hold_to_complete <= '0';
        end if;
    else 
        hold_to_complete <= '0';
        IR(31 downto 16) <= prev_IR_16_bit ;
        IR(15 downto 0) <= bit_IR_16 ;
    end if;    
end if ;
end if;
end process;
end architecture ;

