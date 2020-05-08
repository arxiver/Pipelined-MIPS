
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY MemBufferEnt IS
    generic(
                n : integer := 32
            ); 
    PORT ( 
            Clk,Reset,Enable : IN std_logic;
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            SP,MemOut,ALUResult : IN std_logic_vector(n-1 DOWNTO 0);
            SPOut,ControlSignalsOut,MemOutOut,ALUResultOut : OUT std_logic_vector(n-1 DOWNTO 0)
        );
END ENTITY;


ARCHITECTURE MemBufferArch OF MemBufferEnt IS 
COMPONENT RegEnt IS 
PORT(	
    Clk     : IN std_logic ; 
	Reset   : IN std_logic ; 
	Enable  : IN std_logic ; 
	Input	: IN std_logic_vector(n-1 DOWNTO 0);
	Output	: OUT std_logic_vector(n-1 DOWNTO 0)
);
END COMPONENT;

BEGIN

    SPBuffer              : RegEnt PORT MAP(Clk,Reset,Enable,SP,SPOut);
    ControlSignalsBuffer  : RegEnt PORT MAP(Clk,Reset,Enable,ControlSignals,ControlSignalsOut);
    MemOutBuffer          : RegEnt PORT MAP(Clk,Reset,Enable,MemOut,MemOutOut);
    ALUResultBuffer       : RegEnt PORT MAP(Clk,Reset,Enable,ALUResult,ALUResultOut);

END ARCHITECTURE;
