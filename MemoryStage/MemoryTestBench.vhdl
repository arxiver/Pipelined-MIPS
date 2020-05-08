LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY MemoryTestBenchEnt IS 
generic(n : integer := 32);
-- EMPTY
END MemoryTestBenchEnt;

ARCHITECTURE MemoryTestBenchArch OF MemoryTestBenchEnt IS

COMPONENT MemoryEnt IS
PORT(
        --  For entity
        Clk,Enable: IN std_logic;

        -- Signals
        ControlSignals : IN std_logic_vector(n-1 DOWNTO 0);
        Int,IncrementOrDecrement,SPSignal,MemW,MemR,Call: IN std_logic;

        -- Addresses 
        PC,SP,ALUResult: IN std_logic_vector(n-1 DOWNTO 0);

        -- Data
        DataRead2: IN std_logic_vector(n-1 DOWNTO 0);

        -- Outputs
        MemOut: OUT std_logic_vector(n-1 DOWNTO 0);
        SPOut: OUT std_logic_vector(n-1 DOWNTO 0);
        ALUResultOut: OUT std_logic_vector(n-1 DOWNTO 0);
        ControlSignalsOut :OUT std_logic_vector(n-1 DOWNTO 0)

    );
    END COMPONENT;

    --  For entity
    SIGNAL Clk,Enable: std_logic;

    -- Signals
    SIGNAL ControlSignals : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL Int,IncrementOrDecrement,SPSignal,MemW,MemR,Call: std_logic;

    -- Addresses 
    SIGNAL PC,SP,ALUResult: std_logic_vector(n-1 DOWNTO 0);

    -- Data
    SIGNAL DataRead2: std_logic_vector(n-1 DOWNTO 0);

    -- Outputs
    SIGNAL MemOut: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL SPOut: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL ALUResultOut: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL ControlSignalsOut : std_logic_vector(n-1 DOWNTO 0);
BEGIN
    -- PORT MAPS
    Memory1 : MemoryEnt PORT MAP(
        Clk, 
        Enable, 
        ControlSignals, 
        Int, 
        IncrementOrDecrement, 
        SPSignal, 
        MemW, 
        MemR, 
        Call,
        PC,
        SP,
        ALUResult,
        DataRead2,
        MemOut,
        SPOut,
        ALUResultOut,
        ControlSignalsOut
    );

    process
        constant period: time := 20 ns;
        begin
            -- Assertion
            Clk <= '0';
            Enable <= '1';
            -- ControlSignals <= 0;
            Int <= '0';
            IncrementOrDecrement <= '0';
            SPSignal <= '0';
            MemW <= '1';
            MemR <= '0';
            Call <= '0';
            -- PC <= 0;
            -- SP <= 0;
            ALUResult <= "00000000000000000000000000000000";
            DataRead2 <= "00000000000000000000000000001010";
            MemOut <= 0;
            SPOut <= 0;
            ALUResultOut <= 0;
            ControlSignalsOu <= 0;
            wait for period;
            assert (1 > 0)  
            report "Ready" severity error;

            ------------------------------------------------------------

            WAIT;
        END PROCESS;
END ARCHITECTURE;