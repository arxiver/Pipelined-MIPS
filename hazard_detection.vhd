Library IEEE;
USE IEEE.std_logic_1164.all;

entity hazard_detection is
    port(
        --inputs
        Rds_old ,Rsrc1,Rsrc2 : in std_vector_logic(2 downto 0)
        swap_signal : in std_logic;
        operation_type : in std_logic_vector(4 downto 0)   
        hold_to_complete_out : in std_logic;     
        --outputs
        stall_signal :out std_logic
    );


architecture hazard_detection_arch of hazard_detection is    
        begin
        if(!hold_to_complete_out) then
            if(operation_type=="10001" or operation_type=="10010" or operation_type=="10011") then--
                if(Rds_old==Rsrc1) then
                    stall_signal <= '1'       
                else
                    stall_signal <= '0'
                if(swap_signal) then
                    if(Rds_old=Rsrc2) then
                        stall_signal <= '1'
                    end if
                end if
            else
                stall_signal <= '0'
            end if
    end architecture
    