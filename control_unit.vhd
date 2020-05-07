Library IEEE;
USE IEEE.std_logic_1164.all;
entity control_unit is
port (
-- INPUTS 
IR : in std_logic_vector (31 downto 0);

-- OUTPUTS (CONTROL SIGNALS):
OUT_SIG : out std_logic ;
IN_SIG  : out std_logic ;
ALU_OPR : out std_logic_vector (3 downto 0);
ALU_SRC : out std_logic ;
REG_DST : out std_logic ;
MEM_TO_REG : out std_logic ;
FETCH_EN : out std_logic ;
DATA_EN : out std_logic ;
ALU_EN :  out std_logic ;
BR_EN :  out std_logic ;
MEM_WR_EN :  out std_logic ;
MEM_RD_EN : out std_logic ;
SWAP : out std_logic ;
IN_SP  :  out std_logic ;
SP_INC_DEC : out std_logic ;
EA_IMM_SEL : out std_logic ;
JMP : out std_logic ;
JZ : out std_logic ;
FUNC : out std_logic ;
RTI : out std_logic ;
WB : out std_logic ;
FLUSH_JMP : out std_logic ;
FLUSH_FUNC : out std_logic ;
FLUSH_JZ  : out std_logic 
);
end entity;

architecture control_unit_arch of control_unit is
begin
process(IR)
begin
    case IR(31 downto 27) is
        when "00000" =>
            -- OPERATION : NOP
            OUT_SIG         <= '0';
            IN_SIG          <= '0';
            ALU_OPR         <= "0000";
            ALU_SRC         <= '0';
            REG_DST         <= '0';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '0';
            ALU_EN          <= '0';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '0';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';        
        
        when "00001" =>
            -- OPERATION : NOT
            OUT_SIG         <= '0';
            IN_SIG          <= '0';
            ALU_OPR         <= "0000";
            ALU_SRC         <= '0';
            REG_DST         <= '1';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '1';
            ALU_EN          <= '1';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '1';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';
            
        when "00010" =>
            -- OPERATION : INC
            OUT_SIG         <= '0';
            IN_SIG          <= '0';
            ALU_OPR         <= "0001";
            ALU_SRC         <= '0';
            REG_DST         <= '1';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '1';
            ALU_EN          <= '1';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '1';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';

        when "00011" =>
            -- OPERATION : DEC
            OUT_SIG         <= '0';
            IN_SIG          <= '0';
            ALU_OPR         <= "0010";
            ALU_SRC         <= '0';
            REG_DST         <= '1';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '1';
            ALU_EN          <= '1';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '1';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';

        when "00100" =>
            -- OPERATION : OUT
            OUT_SIG         <= '1';
            IN_SIG          <= '0';
            ALU_OPR         <= "1000";
            ALU_SRC         <= '0';
            REG_DST         <= '0';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '0';
            ALU_EN          <= '1';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '0';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';

        when "00101" =>
            -- OPERATION : IN
            OUT_SIG         <= '0';
            IN_SIG          <= '1';
            ALU_OPR         <= "1001";
            ALU_SRC         <= '0';
            REG_DST         <= '1';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '1';
            ALU_EN          <= '1';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '1';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';

        when others =>
            OUT_SIG         <= '0';
            IN_SIG          <= '0';
            ALU_OPR         <= "0000";
            ALU_SRC         <= '0';
            REG_DST         <= '0';
            MEM_TO_REG      <= '0';
            FETCH_EN        <= '0';
            DATA_EN         <= '0';
            ALU_EN          <= '0';
            BR_EN           <= '0';
            MEM_WR_EN       <= '0';
            MEM_RD_EN       <= '0';
            SWAP            <= '0';
            IN_SP           <= '0';
            SP_INC_DEC      <= '0';
            EA_IMM_SEL      <= '0';
            JMP             <= '0';
            JZ              <= '0';
            FUNC            <= '0';
            RTI             <= '0';
            WB              <= '0';
            FLUSH_JMP       <= '0';
            FLUSH_FUNC      <= '0';
            FLUSH_JZ        <= '0';        
    end case;
end process;
end architecture;