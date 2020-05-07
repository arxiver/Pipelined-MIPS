Library IEEE;
USE IEEE.std_logic_1164.all;
entity CPU_MAIN is
port (
GLOBAL_ENABLE : in std_logic;
GLOBAL_RESET : in std_logic;
CLK : in std_logic 
);
end entity;

architecture CPU_MAIN_ARCH of CPU_MAIN is
component control_unit is
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
end component;

component decode_stage is
port (
-- INPUTS
ENABLE : in std_logic ;
RESET : in std_logic ;
CLK :  in std_logic ;
IR : in std_logic_vector (31 downto 0);
EA_IMM_SEL : in std_logic ;
WR_ADDRESS_1 : in std_logic_vector (2 downto 0);
WR_ADDRESS_2 : in std_logic_vector (2 downto 0);
WR_DATA_1 : in std_logic_vector (31 downto 0);
WR_DATA_2 : in std_logic_vector (31 downto 0);
WR_EN_1 : in std_logic ;
WR_EN_2 : in std_logic ;
SWAP_EN : in std_logic ;

-- OUTPUTS
RD_DATA_1 : out std_logic_vector (31 downto 0);
RD_DATA_2 : out std_logic_vector (31 downto 0);

-- HOLDING IMMEDIATE VALUE OR EXTENDED EFFECTIVE ADDRESS
EA_IMM_DATA : out std_logic_vector (31 downto 0)

);
end component;       

component ID_EX is
port (
-- INPUTS 
ENABLE : in std_logic ;
RESET : in std_logic;
CLK : in std_logic;
-- CONTROL SIGNALS
PC : in std_logic_vector (31 downto 0);
Rdst : in std_logic_vector (31 downto 0);
Rsrc1 : in std_logic_vector (31 downto 0);
Rsrc2 : in std_logic_vector (31 downto 0);
EA_IMM_DATA : in std_logic_vector (31 downto 0);
Rdst_address : in std_logic_vector (2 downto 0);
Rsrc1_address : in std_logic_vector (2 downto 0);
Rsrc2_address : in std_logic_vector (2 downto 0);
OUT_SIG : in std_logic ;
IN_SIG  : in std_logic ;
ALU_OPR : in std_logic_vector (3 downto 0);
ALU_SRC : in std_logic ;
REG_DST : in std_logic ;
MEM_TO_REG : in std_logic ;
FETCH_EN : in std_logic ;
DATA_EN : in std_logic ;
ALU_EN :  in std_logic ;
BR_EN :  in std_logic ;
MEM_WR_EN :  in std_logic ;
MEM_RD_EN : in std_logic ;
SWAP : in std_logic ;
IN_SP  :  in std_logic ;
SP_INC_DEC : in std_logic ;
EA_IMM : in std_logic ;
JMP : in std_logic ;
JZ : in std_logic ;
FUNC : in std_logic ;
RTI : in std_logic ;
WB : in std_logic ;
FLUSH_JMP : in std_logic ;
FLUSH_FUNC : in std_logic ;
FLUSH_JZ  : in std_logic ;

-- OUTPUTS
OUT_CONTROL_SIGNALS : out std_logic_vector (26 downto 0);
PC_OUT : out std_logic_vector (31 downto 0);
Rdst_OUT : out std_logic_vector (31 downto 0);
Rsrc1_OUT : out std_logic_vector (31 downto 0);
Rsrc2_OUT : out std_logic_vector (31 downto 0);
EA_IMM_DATA_OUT : out std_logic_vector (31 downto 0);
Rdst_address_OUT : out std_logic_vector (2 downto 0);
Rsrc1_address_OUT : out std_logic_vector (2 downto 0);
Rsrc2_address_OUT : out std_logic_vector (2 downto 0)
);
end component;
--------------------   SIGNALS   ------------------------

--------------------    CU   ----------------------------
signal CU_OUT_SIG : std_logic ;
signal CU_IN_SIG : std_logic ;
signal CU_ALU_OPR : std_logic_vector (3 downto 0) ;
signal CU_ALU_SRC : std_logic ;
signal CU_REG_DST : std_logic ;
signal CU_MEM_TO_REG : std_logic ;
signal CU_FETCH_EN : std_logic ;
signal CU_DATA_EN : std_logic ;
signal CU_ALU_EN : std_logic ;
signal CU_BR_EN : std_logic ;
signal CU_MEM_WR_EN : std_logic ;
signal CU_MEM_RD_EN : std_logic ;
signal CU_SWAP : std_logic ;
signal CU_IN_SP : std_logic ;
signal CU_SP_INC_DEC : std_logic ;
signal CU_EA_IMM_SEL : std_logic ;
signal CU_JMP : std_logic ;
signal CU_JZ : std_logic ;
signal CU_FUNC : std_logic ;
signal CU_RTI : std_logic ;
signal CU_WB : std_logic ;
signal CU_FLUSH_JMP : std_logic ;
signal CU_FLUSH_FUNC : std_logic ;
signal CU_FLUSH_JZ : std_logic ;
------------------------------------------------------------

--------------------    ID/EX   ----------------------------
signal IDEX_OUT_CONTROL_SIGNALS : std_logic_vector (26 downto 0);
signal IDEX_PC_OUT :  std_logic_vector (31 downto 0);
signal IDEX_Rdst_OUT :  std_logic_vector (31 downto 0);
signal IDEX_Rsrc1_OUT :  std_logic_vector (31 downto 0);
signal IDEX_Rsrc2_OUT :  std_logic_vector (31 downto 0);
signal IDEX_EA_IMM_DATA_OUT :  std_logic_vector (31 downto 0);
signal IDEX_Rdst_address_OUT :  std_logic_vector (2 downto 0);
signal IDEX_Rsrc1_address_OUT :  std_logic_vector (2 downto 0);
signal IDEX_Rsrc2_address_OUT :  std_logic_vector (2 downto 0);
------------------------------------------------------------


--------------------    IF/ID   ----------------------------
signal IFID_IR :  std_logic_vector (31 downto 0);
------------------------------------------------------------

--------------------    MEM/WB   ----------------------------
signal WB_WR_ADDRESS_1 :  std_logic_vector (2 downto 0);
signal WB_WR_ADDRESS_2 :  std_logic_vector (2 downto 0);
signal WB_WR_DATA_1  :  std_logic_vector (31 downto 0);
signal WB_WR_DATA_2  :  std_logic_vector (31 downto 0);
signal WB_WR_EN_1  :  std_logic;
signal WB_WR_EN_2 :  std_logic;
signal WB_SWAP_EN :  std_logic;


------------------- DECODE STAGE ---------------------------
signal EAIMM_MUXOP_DS : std_logic_vector (31 downto 0);
signal DS_RD_DATA_1_OUT,DS_RD_DATA_2_OUT : std_logic_vector (31 downto 0);

---------------------  GLOBAL ------------------------------
signal GLOBAL_PC :  std_logic_vector (31 downto 0);
------------------------------------------------------------
begin
------------------------------------------------------------------
CONTROL_UNIT_INSTANCE : control_unit port map (
    -- INPUTS 
    IR                  => IFID_IR,
    -- OUTPUTS (CONTROL SIGNALS):
    OUT_SIG             => CU_OUT_SIG,
    IN_SIG              => CU_IN_SIG,
    ALU_OPR             => CU_ALU_OPR,
    ALU_SRC             => CU_ALU_SRC,
    REG_DST             => CU_REG_DST,
    MEM_TO_REG          => CU_MEM_TO_REG,
    FETCH_EN            => CU_FETCH_EN,
    DATA_EN             => CU_DATA_EN,
    ALU_EN              => CU_ALU_EN,
    BR_EN               => CU_BR_EN,
    MEM_WR_EN           => CU_MEM_WR_EN,
    MEM_RD_EN           => CU_MEM_RD_EN,
    SWAP                => CU_SWAP,
    IN_SP               => CU_IN_SP,
    SP_INC_DEC          => CU_SP_INC_DEC,
    EA_IMM_SEL          => CU_EA_IMM_SEL,
    JMP                 => CU_JMP,
    JZ                  => CU_JZ,
    FUNC                => CU_FUNC,
    RTI                 => CU_RTI,
    WB                  => CU_WB,
    FLUSH_JMP           => CU_FLUSH_JMP,
    FLUSH_FUNC          => CU_FLUSH_FUNC,
    FLUSH_JZ            => CU_FLUSH_JZ
    );
------------------------------------------------------------------
DECODE_STAGE_INSTANCE : decode_stage port map (
    -- INPUTS
    ENABLE              => GLOBAL_ENABLE,
    RESET               => GLOBAL_RESET,
    CLK                 => CLK,
    IR                  => IFID_IR,
    EA_IMM_SEL          => CU_EA_IMM_SEL,
    WR_ADDRESS_1        => WB_WR_ADDRESS_1,
    WR_ADDRESS_2        => WB_WR_ADDRESS_2,
    WR_DATA_1           => WB_WR_DATA_1,
    WR_DATA_2           => WB_WR_DATA_2,
    WR_EN_1             => WB_WR_EN_1,
    WR_EN_2             => WB_WR_EN_2,
    SWAP_EN             => CU_SWAP,

    -- OUTPUTS
    RD_DATA_1           => DS_RD_DATA_1_OUT,
    RD_DATA_2           => DS_RD_DATA_2_OUT,
    -- HOLDING IMMEDIATE VALUE OR EXTENDED EFFECTIVE ADDRESS
    EA_IMM_DATA         => EAIMM_MUXOP_DS
    );
------------------------------------------------------------------
ID_EX_INSTANCE : ID_EX port map (
    -- INPUTS 
    ENABLE              => GLOBAL_ENABLE, 
    RESET               => GLOBAL_RESET, 
    CLK                 => CLK, 
    -- CONTROL SIGNALS
    PC                  => GLOBAL_PC, 
    Rdst                => DS_RD_DATA_2_OUT,
    Rsrc1               => DS_RD_DATA_1_OUT,
    Rsrc2               => DS_RD_DATA_2_OUT,
    EA_IMM_DATA         => EAIMM_MUXOP_DS, 
    Rdst_address        => IFID_IR( 20 downto 18), 
    Rsrc1_address       => IFID_IR( 26 downto 24),
    Rsrc2_address       => IFID_IR( 23 downto 21),
    OUT_SIG             => CU_OUT_SIG, 
    IN_SIG              => CU_IN_SIG, 
    ALU_OPR             => CU_ALU_OPR,
    ALU_SRC             => CU_ALU_SRC, 
    REG_DST             => CU_REG_DST, 
    MEM_TO_REG          => CU_MEM_TO_REG,
    FETCH_EN            => CU_FETCH_EN, 
    DATA_EN             => CU_DATA_EN,
    ALU_EN              => CU_ALU_EN, 
    BR_EN               => CU_BR_EN,  
    MEM_WR_EN           => CU_MEM_WR_EN, 
    MEM_RD_EN           => CU_MEM_RD_EN, 
    SWAP                => CU_SWAP,
    IN_SP               => CU_IN_SP,  
    SP_INC_DEC          => CU_SP_INC_DEC, 
    EA_IMM              => CU_EA_IMM_SEL, 
    JMP                 => CU_JMP, 
    JZ                  => CU_JZ,
    FUNC                => CU_FUNC,
    RTI                 => CU_RTI, 
    WB                  => CU_WB, 
    FLUSH_JMP           => CU_FLUSH_JMP,
    FLUSH_FUNC          => CU_FLUSH_FUNC, 
    FLUSH_JZ            => CU_FLUSH_JZ,
    -- OUTPUTS
    OUT_CONTROL_SIGNALS => IDEX_OUT_CONTROL_SIGNALS,
    PC_OUT              => IDEX_PC_OUT,
    Rdst_OUT            => IDEX_Rdst_OUT, 
    Rsrc1_OUT           => IDEX_Rsrc1_OUT,
    Rsrc2_OUT           => IDEX_Rsrc2_OUT,
    EA_IMM_DATA_OUT     => IDEX_EA_IMM_DATA_OUT,
    Rdst_address_OUT    => IDEX_Rdst_address_OUT,
    Rsrc1_address_OUT   => IDEX_Rsrc1_address_OUT,
    Rsrc2_address_OUT   => IDEX_Rsrc2_address_OUT
    );

------------------------------------------------------------------

end architecture;