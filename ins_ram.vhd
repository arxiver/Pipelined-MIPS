library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity ins_ram is
    port(
            Initial :in std_logic;
            Clk,Wr,Re : in std_logic;
            PC : in std_logic_vector(15 downto 0);
            DataIn: in std_logic_vector(15 downto 0);
            DataOut : out std_logic_vector(15 downto 0)
        );
end entity;


architecture Ins_Ram_Arch of ins_ram is
type RamType is array (4000 downto 0) of std_logic_vector(15 downto 0);
signal Ram : RamType;
begin
    process(Clk)
    FILE F : text;
    constant FileName : string :="IR.txt";
    VARIABLE L : line;
    variable Count : integer:=0;
    variable Instruction : std_logic_vector(15 downto 0);
    begin
        -- Read file 
        if Initial = '1' and rising_edge(Clk) then 
            File_Open (F,FileName, read_mode);	
            while ((not EndFile (F))) loop
                readline (F, L);
                read(L, Instruction);
                Ram(Count) <= Instruction;
                Count := Count + 1;
            end loop;          
            File_Close (F);
        
        else        
            if rising_edge(Clk) then
                if Wr = '1' and Re = '0' then 
                    Ram(to_integer(unsigned((PC)))) <= DataIn;
                end if ;
            end if;
        end if;
    end process; 
    DataOut<=Ram(to_integer(unsigned((PC)))) when Re = '1' and Wr = '0';
end Ins_Ram_Arch;
