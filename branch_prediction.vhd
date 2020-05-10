Library IEEE;
USE IEEE.std_logic_1164.all;

entity branch_prediction is
    port(
    --inputs    
        --register file
            --R0
            --R1
            --R2
            --R3
            --R4
            --R5
            --R6
        --forwarding register data from memory
        --forwarding register number from memory
        --forwarding register data from ALU
        --forwarding register number from ALU     
        --IR value   
        --PC value
    --outputs
        --flush signal to flush decode and execute buffers now if detection is wrong     


    );


    architecture branch_prediction_arch of branch_prediction is
        (
            begin
                -- if IR branch zero logic 
                -- 1 --> take the pc value 
                -- 2 --> check for the the least 4 bits in it and take them 
                -- 3 --> go to the cache in that place to see it's state
                -- 4 --> if it is taken compare the value of my R and used R in execute and memory data and decode
                -- 5 --> if they are equal then take the data from the buffer into the new PC and update the PC with this value
                -- 6 --> if in deocde stage stall one cycle (raise stall signal)
                -- 7 --> if not taken just send the updated value (PC + 1)
                -- 8 --> 


                




        );