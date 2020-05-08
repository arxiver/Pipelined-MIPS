
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY MemBufferEnt IS
    generic(
                n : integer := 32
            ); 
    PORT ( 
            -- Inputs
            Clk,Reset,Enable : IN std_logic;
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            SP,MemOut,ALUResult : IN std_logic_vector(n-1 DOWNTO 0);

            RDes : IN std_logic_vector(2 DOWNTO 0);
            RSrc1 : IN std_logic_vector(2 DOWNTO 0);
            RSrc2 : IN std_logic_vector(2 DOWNTO 0);

            -- Outputs
            RDesOut : OUT std_logic_vector(2 DOWNTO 0);
            RSrcOut1 : OUT std_logic_vector(2 DOWNTO 0);
            RSrcOut2 : OUT std_logic_vector(2 DOWNTO 0);

            ControlSignalsOut: OUT std_logic_vector(26 DOWNTO 0);
            SPOut,MemOutOut,ALUResultOut : OUT std_logic_vector(n-1 DOWNTO 0)
        );
END ENTITY;


ARCHITECTURE MemBufferArch OF MemBufferEnt IS 
COMPONENT RegEnt IS 
GENERIC (n : integer := 32);
PORT(	
    Clk     : IN std_logic ; 
	Reset   : IN std_logic ; 
	Enable  : IN std_logic ; 
	Input	: IN std_logic_vector(n-1 DOWNTO 0);
	Output	: OUT std_logic_vector(n-1 DOWNTO 0)
);
END COMPONENT;

BEGIN

    SPBuffer              : RegEnt GENERIC MAP(32) PORT MAP(Clk,Reset,Enable,SP,SPOut);
    ControlSignalsBuffer  : RegEnt GENERIC MAP(27) PORT MAP(Clk,Reset,Enable,ControlSignals,ControlSignalsOut);
    MemOutBuffer          : RegEnt GENERIC MAP(32) PORT MAP(Clk,Reset,Enable,MemOut,MemOutOut);
    ALUResultBuffer       : RegEnt GENERIC MAP(32) PORT MAP(Clk,Reset,Enable,ALUResult,ALUResultOut);

    RDesModule        : RegEnt GENERIC MAP(3) PORT MAP(Clk,Reset,Enable,RDes,RDesOut);
    RSrc1Module       : RegEnt GENERIC MAP(3) PORT MAP(Clk,Reset,Enable,RSrc1,RSrcOut1);
    RSrc2Module       : RegEnt GENERIC MAP(3) PORT MAP(Clk,Reset,Enable,RSrc2,RSrcOut2);

END ARCHITECTURE;
