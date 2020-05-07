Library IEEE;
USE IEEE.std_logic_1164.all;
entity sign_extend is
port (
IMM_VALUE : in std_logic_vector (19 downto 0);
EXTENDED : out std_logic_vector (31 downto 0)
);
end entity;

architecture sign_extend_arch of sign_extend is
begin
    EXTENDED(31 downto 20) <=  (others => IMM_VALUE(19));
    EXTENDED(19 downto 0) <= IMM_VALUE ; 
end architecture;