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
            hold_to_complete_out :out std_logic;
            out_IR :out  std_logic_vector(31 downto 0);    
            out_PC :out  std_logic_vector(31 downto 0)   
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
   signal is_reset : std_logic;

begin
full_reset <= initial or reset;
ram : ins_ram port map(initial,Clk,'0','1',PC,(others => '0'),bit_IR_16);  
hold_to_complete_out <=hold_to_complete;
out_IR <= IR;


process(Clk,reset,stalling)
begin
out_PC <= PC;
if(rising_edge(reset))then 
PC<=(OTHERS => '0' );
is_reset<='1';
elsif(rising_edge(Clk)or rising_edge(stalling) or falling_edge(stalling))then
if(initial = '1') then
IR <= (OTHERS => '0' );
PC <= (OTHERS => '0' );
is_reset<='0';
IR_enable <= '1';
IR_reset <= '0';
PC_enable <= '1';
PC_reset <= '0';
else
if hold_to_complete = '0' then    
    if miss_prediction ='1' then  
        PC <= correct_branch_address;
    elsif int_fsm = '1' then
        PC <= address2;
    elsif func = '1' then
        PC <= "0000000000000000"&mux8_output;
    elsif branch = '1' then
        PC <= "0000000000000000"&read_data_1;
	IR <= "00000000000000000000000000000000";
    elsif branch_prediction ='1'  then
        PC <= predicted_branch_address;
    elsif rising_edge(stalling) then
	PC <= PC - 1;
    elsif falling_edge(stalling) then
	PC <= PC + 1;
    elsif stalling = '1' then
        PC <= PC;
    else 
        PC <= PC +1;
    end if;    
 elsif rising_edge(stalling) then
	PC <= PC - 1;
	hold_to_complete <= '0';
 elsif falling_edge(stalling) then
	--PC <= PC + 1; 
	hold_to_complete <= '1';
elsif branch = '1' then
        PC <= "0000000000000000"&read_data_1;
	IR <= "00000000000000000000000000000000";
	hold_to_complete <= '0';
elsif func = '1' then
        PC <= "0000000000000000"&mux8_output;
	hold_to_complete <= '0';
  else
    PC <= PC+1;    
end if;
end if;
else if (falling_edge(clk)) then
      if(hold_to_complete = '0')then 
        IR <=  bit_IR_16 & "0000000000000000" ;    
        if(is_reset='1')then 
            PC<= "0000000000000000"&bit_IR_16;
            is_reset<='0';
        end if;
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
