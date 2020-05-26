Library IEEE;
USE IEEE.std_logic_1164.all;

entity fetch_buffer is 
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
    PC_in : in std_logic_vector(31 downto 0);
    PC_out	: out std_logic_vector(31 downto 0);
    PUSH_PC_IN : in std_logic ;
    PUSH_PC_OUT : out std_logic 
);
end entity;
architecture fetch_buffer_arch of fetch_buffer is
    component reg is 
    generic (n:integer := 16);
    port(	clk : in std_logic ; 
        reset : in std_logic ; 
        enable : in std_logic ; 
        d	: in std_logic_vector(n-1 downto 0);
        q	: out std_logic_vector(n-1 downto 0)
    );
    end component;   

    component regonebit is 
    port(	clk : in std_logic ; 
	reset : in std_logic ; 
	enable : in std_logic ; 
	d	: in std_logic;
	q	: out std_logic
    );
    end component;
    signal reset_IR_full : std_logic;
    signal enable_IR_full :std_logic;
    signal reset_PC_full : std_logic;
    signal enable_PC_full :std_logic;
    begin
    reset_IR_full <= reset_global or IR_reset;
    enable_IR_full <=enable_global and IR_enable;
    reset_PC_full <= reset_global or PC_reset;
    enable_PC_full <=enable_global and PC_enable;
    IR :reg generic map(n => 32)       
        port map(clk,reset_IR_full,enable_IR_full,IR_in,IR_out);
    PC :reg generic map(n => 32)       
        port map(clk,reset_PC_full,enable_PC_full,PC_in,PC_out);
    PUSH_PC :regonebit
        port map(clk,reset_global,enable_global,PUSH_PC_IN,PUSH_PC_OUT);
end architecture;