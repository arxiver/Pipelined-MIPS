Library IEEE;
USE IEEE.std_logic_1164.all;
entity TriStateSPEnt is
generic ( n: integer:=32);
    Port(
    EN : in std_logic;
    X : IN std_logic_vector(n-1 downto 0);
    F : OUT std_logic_vector(n-1 downto 0)
);
end entity;

architecture TriStateSPArch of TriStateSPEnt is 
begin
process(X) begin 
if (EN = '1') then
    F <= X ;
end if;
end process;

end architecture;