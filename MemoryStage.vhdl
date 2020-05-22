LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;


ENTITY MemoryEnt IS
    GENERIC(
            n : integer := 32
        ); 

    PORT(
            --  For entity
            Clk,Enable: IN std_logic;

            -- Signals
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            Int,Call: IN std_logic;

            -- Addresses 
            PC,SP,ALUResult: IN std_logic_vector(n-1 DOWNTO 0);


            RDesData  : IN std_logic_vector(31 DOWNTO 0);
            RSrc2Data : IN std_logic_vector(31 DOWNTO 0);

            RDes : IN std_logic_vector(2 DOWNTO 0);
            RSrc1 : IN std_logic_vector(2 DOWNTO 0);
            RSrc2 : IN std_logic_vector(2 DOWNTO 0);

            -- Data
            DataRead2: IN std_logic_vector(n-1 DOWNTO 0);

	    -- Data
  	   OPCODE:IN std_logic_vector(3 DOWNTO 0);

            -- Outputs
            RDesDataOut  : OUT std_logic_vector(31 DOWNTO 0);
            RSrc2DataOut : OUT std_logic_vector(31 DOWNTO 0);

            RDesOut : OUT std_logic_vector(2 DOWNTO 0);
            RSrcOut1 : OUT std_logic_vector(2 DOWNTO 0);
            RSrcOut2 : OUT std_logic_vector(2 DOWNTO 0);

            MemOut: OUT std_logic_vector(n-1 DOWNTO 0);
            SPOut: OUT std_logic_vector(n-1 DOWNTO 0);
            ALUResultOut: OUT std_logic_vector(n-1 DOWNTO 0);
            ControlSignalsOut :OUT std_logic_vector(26 DOWNTO 0);
            OPCODEOut:Out std_logic_vector(3 DOWNTO 0)

        );
END ENTITY;


ARCHITECTURE MemoryArch OF MemoryEnt IS 
COMPONENT Mux21Ent IS
PORT ( 
        s0: IN STD_LOGIC ;
        IN0,IN1 : IN std_logic_vector(n-1 DOWNTO 0);
        F : OUT std_logic_vector(n-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT Mux41Ent IS
PORT ( 
        s0,s1: IN STD_LOGIC ;
        IN0,IN1,IN2,IN3 : IN std_logic_vector(n-1 DOWNTO 0);
        F : OUT std_logic_vector(n-1 DOWNTO 0)
    );
END COMPONENT;

COMPONENT RamEnt is
    PORT(
            Clk,Wr,Re : IN std_logic;
            Address : IN std_logic_vector(n-1 DOWNTO 0);
            DataIn: IN std_logic_vector(n-1 DOWNTO 0);
            DataOut : OUT std_logic_vector(n-1 DOWNTO 0)
        );
END COMPONENT;


SIGNAL OutMux6,OutMux7,OutMux8 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL SMux6,SMux7 : std_logic;
SIGNAL PCIncrement,SPIncrement: std_logic_vector(n-1 DOWNTO 0);
SIGNAL MemWSignal: std_logic;

-- CONTROL SIGNALS
SIGNAL IncrementOrDecrement,SPSignal,MemW,MemR: std_logic;

BEGIN

    -- MUXES
    Mux6 : Mux21Ent port map(SMux6,SP,SPIncrement,OutMux6);
    Mux7 : Mux21Ent port map(SMux7,ALUResult,OutMux6,OutMux7);
    Mux8 : Mux41Ent port map(Call,Int,DataRead2,PC,PCIncrement,(others => '0'),OutMux8);

    -- RAM
    Ram1 : RamEnt port map(Clk,MemWSignal,MemR,OutMux7,OutMux8,MemOut);

    -- PROCESS(Clk) BEGIN 
        -- IF(rising_edge(Clk) AND Enable='1') THEN
            IncrementOrDecrement <= ControlSignals(17);
            SPSignal <= ControlSignals(16);
            MemW <= ControlSignals(13);
            MemR <= ControlSignals(14);

            -- MUXES SELECTORS
            SMux6 <= Int OR IncrementOrDecrement;
            SMux7 <= SPSignal OR Int;

            -- MUXES DATA
            SPIncrement <= SP+1;
            PCIncrement <= PC+1;

            -- MEMORY ENABLES
            MemWSignal <= MemW OR Int;

            -- Outputs
            RDesDataOut <= RDesData;
            RSrc2DataOut <= RSrc2Data;

            RDesOut <= RDes;
            RSrcOut1 <= RSrc1;
            RSrcOut2 <= RSrc2;

            -- wait for 10 ns;
            SPOut <= OutMux6;
            ALUResultOut <= ALUResult;
            ControlSignalsOut <= ControlSignals;
	    OPCODEOut <= OPCODE;
        -- END IF;
    -- END PROCESS;
    
END ARCHITECTURE;
