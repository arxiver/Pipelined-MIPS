LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity register_file is
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
end entity register_file;

ARCHITECTURE register_file_arch OF register_file IS

	TYPE reg_type IS ARRAY(0 TO 7) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL reg_file : reg_type := (
	  OTHERS => "00000000000000000000000000000000"
	);
	BEGIN
		PROCESS(CLK) IS
			BEGIN
				IF rising_edge(CLK) THEN  
					IF WRen_port1 = '1' THEN
						reg_file(to_integer(unsigned(WRaddress_port1))) <= WRdatain_port1;
					END IF;
					IF WRen_port2 = '1' THEN
						reg_file(to_integer(unsigned(WRaddress_port2))) <= WRdatain_port2;
					END IF;
				END IF;
		END PROCESS;
		RDdataout_port1 <= reg_file(to_integer(unsigned(RDaddress_port1))) ;
		RDdataout_port2 <= reg_file(to_integer(unsigned(RDaddress_port2))) ;
END register_file_arch;
