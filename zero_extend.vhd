Library IEEE;
USE IEEE.std_logic_1164.all;
entity zero_extend is
port (
EA_VALUE : in std_logic_vector (15 downto 0);
EXTENDED : out std_logic_vector (31 downto 0)
);
end entity;

architecture zero_extend_arch of zero_extend is
begin
    EXTENDED (31 downto 16) <=  (others => '0') ;
    EXTENDED (15 downto 0) <= EA_VALUE ; 
end architecture;