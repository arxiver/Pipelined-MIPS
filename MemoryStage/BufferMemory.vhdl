
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY MemBufferEnt IS
    generic(
                n : integer := 32
            ); 
    PORT ( 
            s0: IN STD_LOGIC ;
            IN0,IN1 : IN std_logic_vector(n-1 downto 0);
            F : OUT std_logic_vector(n-1 downto 0)
        );
END ENTITY;


ARCHITECTURE MemBufferArch OF MemBufferEnt IS BEGIN

    F <= IN0  when s0 = '0'
    ELSE IN1  WHEN s0 = '1';

END ARCHITECTURE;
