library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY my_nadder IS

GENERIC (n : integer := 32);

PORT(a,b : IN std_logic_vector(n-1
DOWNTO 0);

cin : IN std_logic;

s : OUT std_logic_vector(n-1
DOWNTO 0);
cout : OUT std_logic);

END my_nadder;



ARCHITECTURE a_my_nadder OF my_nadder IS

COMPONENT my_adder IS

PORT( a,b,cin : IN std_logic;
s,cout : OUT std_logic);

END COMPONENT;

SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);

BEGIN

loop1: FOR i IN 0 TO n-1 GENERATE

g0: IF i = 0 GENERATE

f0: my_adder PORT MAP (a(i) ,b(i) ,cin, s(i), temp(i));

END GENERATE g0;

gx: IF i > 0 GENERATE

fx: my_adder PORT MAP (a(i),b(i),temp(i-1),s(i),temp(i));

END GENERATE gx;

END GENERATE;

cout <= temp(n-1);

END a_my_nadder;