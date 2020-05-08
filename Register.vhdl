LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY RegEnt IS 
GENERIC (n:integer := 32);
PORT(	
    Clk     : IN std_logic ; 
	Reset   : IN std_logic ; 
	Enable  : IN std_logic ; 
	Input	: IN std_logic_vector(n-1 DOWNTO 0);
	Output	: OUT std_logic_vector(n-1 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE RegArch OF RegEnt IS
BEGIN
    PROCESS (Clk,Reset,Enable)
    BEGIN
        IF (Reset = '1') THEN Output <= (OTHERS => '0');
        elsif (rising_edge(Clk)) AND Enable = '1' THEN Output <= Input;
        END IF;
    END PROCESS;
END ARCHITECTURE;
