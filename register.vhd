Library IEEE;
USE IEEE.std_logic_1164.all;

entity reg is 
generic (n:integer := 16);
port(	clk : in std_logic ; 
	reset : in std_logic ; 
	enable : in std_logic ; 
	d	: in std_logic_vector(n-1 downto 0);
	q	: out std_logic_vector(n-1 downto 0)
);
end entity;

architecture regarc of reg is
begin
process (clk,reset,enable)
begin
if (reset = '1') then q <= (OTHERS => '0');
elsif (falling_edge(clk)) and enable = '1' then q <= d;
end if;
end process;

end architecture;
