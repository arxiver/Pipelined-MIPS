
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY Mux41Ent IS
generic(
            n : integer := 32
        ); 
PORT ( 
        s0,s1: IN STD_LOGIC ;
        IN0,IN1,IN2,IN3 : IN std_logic_vector(n-1 downto 0);
        F : OUT std_logic_vector(n-1 downto 0)
    );
END ENTITY;


ARCHITECTURE Mux21Arch OF Mux21Ent IS BEGIN

    F <= IN0  when s1 = '0' and s0 = '0'
    ELSE IN1  when s1 = '0' and s0 = '1'
    ELSE IN2  when s1 = '1' and s0 = '0'
    ELSE IN3  WHEN s1 = '1' and s0 = '1';

END ARCHITECTURE;
