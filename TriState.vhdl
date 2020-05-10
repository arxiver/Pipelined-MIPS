Library IEEE;
USE IEEE.std_logic_1164.all;
entity TriStateEnt is
generic ( n: integer:=32);
    Port(
    EN : in std_logic;
    X : IN std_logic_vector(n-1 downto 0);
    F : OUT std_logic_vector(n-1 downto 0)
);
end entity;

architecture TriStateArch of TriStateEnt is 
begin

F <= X WHEN EN = '1'
ELSE (OTHERS => 'Z' );

end architecture;