Library IEEE;
USE IEEE.std_logic_1164.all;
entity ID_EX is
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
end entity;

architecture ID_EX_ARCH of ID_EX is
component reg is 
generic (n:integer := 32);
port(	clk : in std_logic ; 
	reset : in std_logic ; 
	enable : in std_logic ; 
	d	: in std_logic_vector(n-1 downto 0);
	q	: out std_logic_vector(n-1 downto 0)
);
end component;
signal TMP_CONTROL_SIGNAS : std_logic_vector (26 downto 0);
begin
TMP_CONTROL_SIGNAS(0)  			<= OUT_SIG;
TMP_CONTROL_SIGNAS(1)  			<= IN_SIG;
TMP_CONTROL_SIGNAS(5 downto 2)  <= ALU_OPR;
TMP_CONTROL_SIGNAS(6)  			<= ALU_SRC;
TMP_CONTROL_SIGNAS(7)  			<= REG_DST; 
TMP_CONTROL_SIGNAS(8)  			<= MEM_TO_REG;
TMP_CONTROL_SIGNAS(9) 			<= FETCH_EN;
TMP_CONTROL_SIGNAS(10)  		<= DATA_EN;
TMP_CONTROL_SIGNAS(11)  		<= ALU_EN;
TMP_CONTROL_SIGNAS(12)  		<= BR_EN;
TMP_CONTROL_SIGNAS(13) 			<= MEM_WR_EN;
TMP_CONTROL_SIGNAS(14) 			<= MEM_RD_EN;
TMP_CONTROL_SIGNAS(15) 			<= SWAP;
TMP_CONTROL_SIGNAS(16) 			<= IN_SP;
TMP_CONTROL_SIGNAS(17) 			<= SP_INC_DEC;
TMP_CONTROL_SIGNAS(18) 			<= EA_IMM;
TMP_CONTROL_SIGNAS(19) 			<= JMP;
TMP_CONTROL_SIGNAS(20) 			<= JZ;
TMP_CONTROL_SIGNAS(21) 			<= FUNC;
TMP_CONTROL_SIGNAS(22) 			<= RTI;
TMP_CONTROL_SIGNAS(23) 			<= WB;
TMP_CONTROL_SIGNAS(24) 			<= FLUSH_JMP;
TMP_CONTROL_SIGNAS(25) 			<= FLUSH_FUNC;
TMP_CONTROL_SIGNAS(26) 			<= FLUSH_JZ;
REG_CONTROL_SIGNALS : reg generic map(27) port map(CLK, RESET, ENABLE,TMP_CONTROL_SIGNAS,OUT_CONTROL_SIGNALS);
REG_PC : reg generic map (32) port map(CLK, RESET, ENABLE, PC ,PC_OUT);
REG_Rdst : reg generic map (32) port map(CLK, RESET, ENABLE, Rdst ,Rdst_OUT);
REG_Rsrc1 : reg generic map (32) port map(CLK, RESET, ENABLE, Rsrc1 ,Rsrc1_OUT);
REG_Rsrc2 : reg generic map (32) port map(CLK, RESET, ENABLE, Rsrc2 ,Rsrc2_OUT);
REG_EA_IMM_DATA : reg generic map (32) port map(CLK, RESET, ENABLE, EA_IMM_DATA ,EA_IMM_DATA_OUT);

REG_Rdst_address : reg generic map (3) port map(CLK, RESET, ENABLE, Rdst_address ,Rdst_address_OUT);
REG_Rsrc1_address : reg generic map (3) port map(CLK, RESET, ENABLE, Rsrc1_address ,Rsrc1_address_OUT);
REG_Rsrc2_address : reg generic map (3) port map(CLK, RESET, ENABLE, Rsrc2_address ,Rsrc2_address_OUT);

end architecture;