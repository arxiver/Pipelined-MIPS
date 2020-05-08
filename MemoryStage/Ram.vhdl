library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity RamEnt is
    GENERIC (
        ArraySize : integer := 2000;
        n : integer := 32
    );
    port(
            Clk,Wr,Re : in std_logic;
            Address : in std_logic_vector(n-1 downto 0);
            DataIn: in std_logic_vector(n-1 downto 0);
            DataOut : out std_logic_vector(n-1 downto 0)
        );
end entity;


architecture RamArch of RamEnt is
type RamType is array (ArraySize downto 0) of std_logic_vector(n-1 downto 0); -- the size must be 2 * 10^9
signal Ram : RamType;
begin
    process(Clk)
    begin     
            if rising_edge(Clk) then
                if Wr = '1' and Re = '0' then 
                    Ram(to_integer(unsigned((Address)))) <= DataIn;
                end if;

                if Wr = '0' and Re = '1' then
                    DataOut<=Ram(to_integer(unsigned((Address))));
                end if;
            end if;
    end process; 
    
end architecture;
