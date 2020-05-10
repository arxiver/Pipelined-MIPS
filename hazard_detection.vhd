Library IEEE;
USE IEEE.std_logic_1164.all;

entity hazard_detection is
    port(
        --inputs
        Rds_old ,Rsrc1,Rsrc2 : in std_logic_vector(2 downto 0);
        swap_signal : in std_logic;
        operation_type : in std_logic_vector(4 downto 0);   
        hold_to_complete_out : in std_logic;     
        --outputs
        stall_signal :out std_logic
    );
end entity;

architecture hazard_detection_arch of hazard_detection is    
        begin
stall_signal <= '1' when hold_to_complete_out='0' and (operation_type="10001" or operation_type="10010" or operation_type="10011") and (Rds_old=Rsrc1 or (swap_signal='1' and  Rds_old=Rsrc2))
else '0';
end architecture;
    