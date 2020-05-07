Library IEEE;
USE IEEE.std_logic_1164.all;
entity decode_stage is
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
end entity;

architecture decode_stage_arch of decode_stage is
component reg is 
generic (n:integer := 32);
port(	clk : in std_logic ; 
	reset : in std_logic ; 
	enable : in std_logic ; 
	d	: in std_logic_vector(n-1 downto 0);
	q	: out std_logic_vector(n-1 downto 0)
);
end component;
component sign_extend is
    port (
    IMM_VALUE : in std_logic_vector (19 downto 0);
    EXTENDED : out std_logic_vector (31 downto 0)
    );
end component;

component zero_extend is
    port (
    EA_VALUE : in std_logic_vector (15 downto 0);
    EXTENDED : out std_logic_vector (31 downto 0)
    );
end component;

component register_file is
        port(
            CLK : IN std_logic;
            WRen_port1  : IN std_logic;
            WRen_port2  : IN std_logic;
    
            WRaddress_port1 : IN  std_logic_vector(2 DOWNTO 0);
            WRaddress_port2 : IN  std_logic_vector(2 DOWNTO 0);
            
            RDaddress_port1 : IN  std_logic_vector(2 DOWNTO 0);
            RDaddress_port2 : IN  std_logic_vector(2 DOWNTO 0);
    
            WRdatain_port1  : IN  std_logic_vector(31 DOWNTO 0);
            WRdatain_port2  : IN  std_logic_vector(31 DOWNTO 0);
    
            RDdataout_port1 : OUT std_logic_vector(31 DOWNTO 0);
            RDdataout_port2 : OUT std_logic_vector(31 DOWNTO 0) );
end component ;
signal RD_ADDRESS_1,RD_ADDRESS_2 : std_logic_vector (2 downto 0); 
signal zero_extended_value,sign_extended_value : std_logic_vector (31 downto 0);
begin
ZE : zero_extend port map(IR(17 downto 2), zero_extended_value) ;
SE : sign_extend port map(IR(20 downto 1), sign_extended_value) ;
REG_FILE : register_file port map(
        CLK             => CLK,
        WRen_port1      => WR_EN_1,
        WRen_port2      => WR_EN_2,
        WRaddress_port1 => WR_ADDRESS_1,
        WRaddress_port2 => WR_ADDRESS_2, 
        RDaddress_port1 => RD_ADDRESS_1,
        RDaddress_port2 => RD_ADDRESS_2,
        WRdatain_port1  => WR_DATA_1,
        WRdatain_port2  => WR_DATA_2,
        RDdataout_port1 => RD_DATA_1,
        RDdataout_port2 => RD_DATA_2 );
RD_ADDRESS_1 <= IR(26 downto 24) ;
RD_ADDRESS_2 <= IR(23 downto 21) when SWAP_EN = '0' else IR(20 downto 18) ;
EA_IMM_DATA <= zero_extended_value when EA_IMM_SEL = '0' else sign_extended_value ;
end architecture;