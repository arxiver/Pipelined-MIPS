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
            ControlSignals : IN std_logic_vector(n-1 DOWNTO 0);
            Int,IncrementOrDecrement,SPSignal,MemToReg, OutSignal: IN std_logic;

            -- SP 
            SP : IN std_logic_vector(n-1 DOWNTO 0);

            -- Data
            MemOut,ALUResult: IN std_logic_vector(n-1 DOWNTO 0);

            -- Outputs
            OutSignalOut : OUT std_logic;
            Mux10Out, SPOut : OUT std_logic_vector(n-1 DOWNTO 0);

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


SIGNAL SPDecrement: std_logic_vector(n-1 DOWNTO 0);
SIGNAL SMux9,STriState : std_logic;
SIGNAL OutMux9 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL MemWSignal: std_logic;

-- CONTROL SIGNALS
-- SIGNAL Int,IncrementOrDecrement,SPSignal,MemW,MemR,Call: std_logic;

BEGIN

    -- MUXES
    Mux9    : Mux21Ent port map(SMux9,SPDecrement,SP,OutMux9);
    Mux10   : Mux21Ent port map(MemToReg,ALUResult,MemOut,Mux10Out);

    PROCESS(Clk) BEGIN 
        IF(rising_edge(Clk) AND Enable='1') THEN
            SMux9 <= (NOT Int) OR IncrementOrDecrement;
            SPDecrement <= SP-1;


            MemWSignal <= MemW OR Int;

            -- CONTROL SIGNALS 

            -- Outputs
            SPOut <= OutMux6;
            ALUResultOut <= ALUResult;
            ControlSignalsOut <= ControlSignals;
        END IF;
    END PROCESS;
    
END ARCHITECTURE;
