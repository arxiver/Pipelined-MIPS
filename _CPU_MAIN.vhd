Library IEEE;
USE IEEE.std_logic_1164.all;
entity CPU_MAIN is
port (
GLOBAL_ENABLE : in std_logic;
GLOBAL_RESET : in std_logic;
GLOBAL_INITAIL : in std_logic;
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

component fetch_buffer is 
port(    
    clk : in std_logic ; 
	reset_global : in std_logic ; 
    enable_global : in std_logic ; 
    IR_enable :in std_logic;
    IR_reset : in std_logic;
    IR_in : in std_logic_vector(31 downto 0);
    IR_out	: out std_logic_vector(31 downto 0);
    PC_enable :in std_logic;
    PC_reset : in std_logic;
    PC_in : in std_logic_vector(15 downto 0);
    PC_out	: out std_logic_vector(15 downto 0)    
);
end component;

component fetch_stage is
    generic (n:integer := 16);
    port(       
            initial : in std_logic;
            Clk ,reset,buffer_enable : in std_logic;
            correct_branch_address,address2,mux8_output,read_data_1,predicted_branch_address : in std_logic_vector(15 downto 0);
            miss_prediction,int_fsm,func,branch,branch_prediction,stalling : in std_logic;                    
            hold_to_complete_out :out std_logic;
            out_IR :out  std_logic_vector(31 downto 0);    
            out_PC :out  std_logic_vector(15 downto 0)    
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


-------------------------- Execute Stage component -----------------------------
component Execute_Stage_Entity is 
port(
--ID/EX INPUTS
IDEX_CONTROL_SIGNALS :in std_logic_vector (26 downto 0);
IDEX_PC :in  std_logic_vector (31 downto 0);
IDEX_Rdst :in  std_logic_vector (31 downto 0);
IDEX_Rsrc1 :in  std_logic_vector (31 downto 0);
IDEX_Rsrc2 :in  std_logic_vector (31 downto 0);
IDEX_EA_IMM_DATA :in  std_logic_vector (31 downto 0);
IDEX_Rdst_address :in  std_logic_vector (2 downto 0);
IDEX_Rsrc1_address :in  std_logic_vector (2 downto 0);
IDEX_Rsrc2_address :in  std_logic_vector (2 downto 0); 

--EX/MEM Outputs
EXMEM_ALU_RESULT:out  std_logic_vector (31 downto 0);
EXMEM_CONTROL_SIGNALS :out std_logic_vector (26 downto 0);
EXMEM_PC :out  std_logic_vector (31 downto 0);
EXMEM_Rdst :out  std_logic_vector (31 downto 0);
EXMEM_Rsrc2 :out  std_logic_vector (31 downto 0);
EXMEM_Rdst_address :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc1_address :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc2_address :out  std_logic_vector (2 downto 0); 

--Forwarding data
Mem_Forwarding , WB_Forwarding: in std_logic_vector (31 downto 0) ;

--Forwarding unit selectors
Forwarding_Selectors1,
Forwarding_Selectors2 : in std_logic_vector (1 downto 0) ;

--In Port Data
In_Port: in std_logic_vector (31 downto 0) ;

--flags
flags : inout std_logic_vector (3 downto 0) ; 

--clk , enable , reset
clk,
Enable,
Reset: in std_logic);

end component Execute_Stage_Entity;


-------------------------- EXMEM BUFFER component -----------------------------

component EX_Buffer_Entity is 
port(
EXMEM_ALU_RESULT_IN:in  std_logic_vector (31 downto 0);
EXMEM_CONTROL_SIGNALS_IN :in std_logic_vector (26 downto 0);
EXMEM_PC_IN :in  std_logic_vector (31 downto 0);
EXMEM_Rdst_IN :in  std_logic_vector (31 downto 0);
EXMEM_Rsrc2_IN :in  std_logic_vector (31 downto 0);
EXMEM_Rdst_address_IN :in  std_logic_vector (2 downto 0);
EXMEM_Rsrc1_address_IN :in  std_logic_vector (2 downto 0);
EXMEM_Rsrc2_address_IN :in  std_logic_vector (2 downto 0); 

EXMEM_ALU_RESULT_OUT:out  std_logic_vector (31 downto 0);
EXMEM_CONTROL_SIGNALS_OUT :out std_logic_vector (26 downto 0);
EXMEM_PC_OUT :out  std_logic_vector (31 downto 0);
EXMEM_Rdst_OUT :out  std_logic_vector (31 downto 0);
EXMEM_Rsrc2_OUT :out  std_logic_vector (31 downto 0);
EXMEM_Rdst_address_OUT :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc1_address_OUT :out  std_logic_vector (2 downto 0);
EXMEM_Rsrc2_address_OUT :out  std_logic_vector (2 downto 0); 

Wr,clk,reset : in std_logic);
end component EX_Buffer_Entity;

-------------------------- Memory Stage component -----------------------------
COMPONENT MemoryEnt IS
    PORT(
            --  For entity
            Clk,Enable: IN std_logic;

            -- Signals
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            Int,Call: IN std_logic;

            -- Addresses 
            PC,SP,ALUResult: IN std_logic_vector(31 DOWNTO 0);

            -- Data
            DataRead2: IN std_logic_vector(31 DOWNTO 0);

            -- Outputs
            MemOut: OUT std_logic_vector(31 DOWNTO 0);
            SPOut: OUT std_logic_vector(31 DOWNTO 0);
            ALUResultOut: OUT std_logic_vector(31 DOWNTO 0);
            ControlSignalsOut :OUT std_logic_vector(26 DOWNTO 0)

        );
END COMPONENT;

-------------------------- Memory Buffer ----------------------------

COMPONENT MemBufferEnt IS
    PORT ( 
            -- Inputs
            Clk,Reset,Enable : IN std_logic;
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            SP,MemOut,ALUResult : IN std_logic_vector(31 DOWNTO 0);

            -- Outputs
            ControlSignalsOut: OUT std_logic_vector(26 DOWNTO 0);
            SPOut,MemOutOut,ALUResultOut : OUT std_logic_vector(31 DOWNTO 0)
        );
END COMPONENT;

--------------------------- WB Stage --------------------------

COMPONENT WBEnt IS
    PORT(
            --  For entity
            Clk,Enable: IN std_logic;

            -- Signals
            ControlSignals : IN std_logic_vector(26 DOWNTO 0);
            Int: IN std_logic;

            -- SP 
            SP : IN std_logic_vector(31 DOWNTO 0);

            -- Data
            MemOut,ALUResult: IN std_logic_vector(31 DOWNTO 0);

            -- Outputs
            ControlSignalsOut : OUT std_logic_vector(26 DOWNTO 0);
            IntOut : OUT std_logic;
            Mux10Out, SPOut : OUT std_logic_vector(31 DOWNTO 0)

        );
END COMPONENT;

-----------------------------------------------------------------------

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
signal ZERO_LOGIC_16 : std_logic_vector(15 downto 0):="0000000000000000";
------------------------------------------------------------

--------------------    IF/ID   ----------------------------
signal IFID_IR :  std_logic_vector (31 downto 0);
signal IFID_PC :  std_logic_vector (15 downto 0);
signal FS_IR :  std_logic_vector (31 downto 0);
signal FS_PC :  std_logic_vector (15 downto 0);
signal IFID_BUFFER_ENABLE :std_logic;
------------------------------------------------------------

---------------------Execute Stage----------------------------
--Execute Stage output
SIGNAL EXMEM_ALU_RESULT : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_CONTROL_SIGNALS : std_logic_vector(26 DOWNTO 0);
SIGNAL EXMEM_PC  : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_Rdst  : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_Rsrc2  : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_Rdst_address  : std_logic_vector(2 DOWNTO 0);
SIGNAL EXMEM_Rsrc1_address  : std_logic_vector(2 DOWNTO 0);
SIGNAL EXMEM_Rsrc2_address  : std_logic_vector(2 DOWNTO 0);

--Forwarding data input
SIGNAL Mem_Forwarding : std_logic_vector(31 DOWNTO 0);
SIGNAL WB_Forwarding : std_logic_vector(31 DOWNTO 0);

--Forwarding unit selectors inputs
SIGNAL Forwarding_Selectors1 : std_logic_vector(1 DOWNTO 0);
SIGNAL Forwarding_Selectors2  : std_logic_vector(1 DOWNTO 0);

--In Port Data
SIGNAL In_Port: std_logic_vector (31 downto 0) ;

--flags
SIGNAL flags : std_logic_vector (3 downto 0) ; 

--Enable
SIGNAL Execute_EN : std_logic ; 

---------------------------------------------------------------

-----------------------EX MEM Buffer------------------------------
SIGNAL EXMEM_ALU_RESULT_OUT: std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_CONTROL_SIGNALS_OUT : std_logic_vector(26 DOWNTO 0);
SIGNAL EXMEM_PC_OUT : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_Rdst_OUT : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_Rsrc2_OUT : std_logic_vector(31 DOWNTO 0);
SIGNAL EXMEM_Rdst_address_OUT : std_logic_vector(2 DOWNTO 0);
SIGNAL EXMEM_Rsrc1_address_OUT : std_logic_vector(2 DOWNTO 0);
SIGNAL EXMEM_Rsrc2_address_OUT : std_logic_vector(2 DOWNTO 0);

SIGNAL EX_MEM_BUFFER_WRITE : std_logic;

---------------------------------------------------------------

---------------------- Memory Stage -------------------------
SIGNAL MemOutMemory: std_logic_vector(31 DOWNTO 0);
SIGNAL SPOutMemory: std_logic_vector(31 DOWNTO 0);
SIGNAL ALUResultOutMemory: std_logic_vector(31 DOWNTO 0);
SIGNAL ControlSignalsOutMemory: std_logic_vector(26 DOWNTO 0);

----------------------- Memory Buffer ------------------------
SIGNAL ControlSignalsOutBuffer : std_logic_vector(26 DOWNTO 0);
SIGNAL SPOutBuffer : std_logic_vector(31 DOWNTO 0);
SIGNAL MemOutBuffer: std_logic_vector(31 DOWNTO 0);
SIGNAL ALUResultOutBuffer : std_logic_vector(31 DOWNTO 0);

------------------------ WB Stage -----------------------
SIGNAL ControlSignalsOutWB : std_logic_vector(26 DOWNTO 0);
SIGNAL Mux10OutWB : std_logic_vector(31 DOWNTO 0);
SIGNAL SPOutWB : std_logic_vector(31 DOWNTO 0);
SIGNAL IntOutWB : std_logic;

begin

-- first stage : FETCH STAGE
FETCH_STAGE_INSTANCE : fetch_stage port map(
    initial => GLOBAL_INITAIL,
    Clk  => CLK ,
    reset => GLOBAL_RESET,
    buffer_enable => IFID_BUFFER_ENABLE ,
    correct_branch_address => ZERO_LOGIC_16,
    address2 => ZERO_LOGIC_16,
    mux8_output => ZERO_LOGIC_16,
    read_data_1 =>ZERO_LOGIC_16,
    predicted_branch_address => ZERO_LOGIC_16,
    miss_prediction => '0',
    int_fsm => '0',
    func =>'0',
    branch => '0',
    branch_prediction => '0',
    stalling            => '0',
    hold_to_complete_out => open, ---should be handled to wait for another fetch  
    out_IR =>FS_IR ,
    out_PC => FS_PC
);
--FIRST BUFFER: IF/ID BUFFER 
FETCH_BUFFER_INSTANCE : fetch_buffer port map (
    clk  => CLK ,
	reset_global  => GLOBAL_RESET ,
    enable_global  => IFID_BUFFER_ENABLE,
    IR_enable  => GLOBAL_ENABLE,
    IR_reset  => GLOBAL_RESET,
    IR_in => FS_IR,
    IR_out	 => IFID_IR,
    PC_enable =>GLOBAL_ENABLE,
    PC_reset =>GLOBAL_RESET,
    PC_in => FS_PC,
    PC_out	 => IFID_PC
);
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



----------------------- Execute Stage ------------------------------
ExecuteStage : Execute_Stage_Entity PORT MAP (
                                    --inputs
                                    IDEX_OUT_CONTROL_SIGNALS,
                                    IDEX_PC_OUT ,
                                    IDEX_Rdst_OUT ,
                                    IDEX_Rsrc1_OUT ,
                                    IDEX_Rsrc2_OUT ,
                                    IDEX_EA_IMM_DATA_OUT ,
                                    IDEX_Rdst_address_OUT ,
                                    IDEX_Rsrc1_address_OUT ,
                                    IDEX_Rsrc2_address_OUT ,

                                    --EX/MEM Outputs
                                    EXMEM_ALU_RESULT ,
                                    EXMEM_CONTROL_SIGNALS  ,
                                    EXMEM_PC  ,
                                    EXMEM_Rdst  ,
                                    EXMEM_Rsrc2  ,
                                    EXMEM_Rdst_address  ,
                                    EXMEM_Rsrc1_address  ,
                                    EXMEM_Rsrc2_address  ,

                                    --forwarded data
                                    Mem_Forwarding ,
                                    WB_Forwarding ,

                                    --forwarding unit selectors
                                    Forwarding_Selectors1 ,
                                    Forwarding_Selectors2 ,

                                    --in port data
                                    In_Port ,
                                    
                                    --flags
                                    flags,

                                    --CLK
                                    CLK,

                                    --Enable
                                    Execute_EN,

                                    --Reset
                                    GLOBAL_RESET

);
-----------------------------------------------------------------------

----------------------- Execute Stage ------------------------------
EXMEM_LABEL : EX_Buffer_Entity PORT MAP (
                                    --Execute stage outputs
                                    EXMEM_ALU_RESULT ,
                                    EXMEM_CONTROL_SIGNALS ,
                                    EXMEM_PC  ,
                                    EXMEM_Rdst  ,
                                    EXMEM_Rsrc2  ,
                                    EXMEM_Rdst_address  ,
                                    EXMEM_Rsrc1_address ,
                                    EXMEM_Rsrc2_address ,

                                    --Buffer outputs
                                    EXMEM_ALU_RESULT_OUT,
                                    EXMEM_CONTROL_SIGNALS_OUT ,
                                    EXMEM_PC_OUT ,
                                    EXMEM_Rdst_OUT ,
                                    EXMEM_Rsrc2_OUT ,
                                    EXMEM_Rdst_address_OUT ,
                                    EXMEM_Rsrc1_address_OUT ,
                                    EXMEM_Rsrc2_address_OUT ,

                                    --Write enable
                                    EX_MEM_BUFFER_WRITE,

                                    --CLK
                                    CLK,
                                    GLOBAL_RESET



);
-----------------------------------------------------------------------

----------------------- Memory Stage ------------------------------
MemoryStage : MemoryEnt PORT MAP(
                                    -- Inputs
                                    CLK, 
                                    '1', -- ENABLE 

                                    -- Data to test my work
                                    -- "000000000000000000000000000", -- CONTROL SIGNAL 
                                    -- '0',    -- Int
                                    -- '0',    -- call
                                    -- "00000000000000000000000000000000", -- PC
                                    -- "00000000000000000000000000000000", -- SP
                                    -- "00000000000000000000000000000000", -- ALU RESULT
                                    -- "00000000000000000000000000000000", -- DATA READ 2

                                    -- Data from nassar
                                    EXMEM_CONTROL_SIGNALS_OUT,
                                    '0',
                                    '0',
                                    EXMEM_PC_OUT,
                                    "00000000000000000000000000000000",
                                    EXMEM_ALU_RESULT_OUT,
                                    EXMEM_Rsrc2_OUT,

                                    -- Outputs
                                    MemOutMemory,
                                    SPOutMemory,
                                    ALUResultOutMemory,
                                    ControlSignalsOutMemory
                                ); 

----------------------- Memory Buffer ------------------------------
MemoryBuffer : MemBufferEnt PORT MAP(   
                                        -- Inputs
                                        CLK,
                                        GLOBAL_RESET,
                                        '1',
                                        ControlSignalsOutMemory,
                                        SPOutMemory,
                                        MemOutMemory,
                                        ALUResultOutMemory,

                                        -- Outputs
                                        ControlSignalsOutBuffer,
                                        SPOutBuffer,
                                        MemOutBuffer,
                                        ALUResultOutBuffer
);
--------------------------- WB Stage --------------------------------
WBStage : WBEnt PORT MAP(
                            CLK,
                            '1',    -- ENABLE
                            ControlSignalsOutBuffer,    -- CONTROL SIGNAL
                            '0',    -- INT
                            SPOutBuffer,
                            MemOutBuffer,
                            ALUResultOutBuffer,
                            ControlSignalsOutWB,
                            IntOutWB,
                            Mux10OutWB,
                            SPOutWB
);

end architecture;