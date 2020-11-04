LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Lab7_part1 IS
PORT (KEY	:	IN std_logic_vector (1 downto 0);
		LEDR	:	OUT std_logic_vector(9 downto 0));
		
END Lab7_part1;		

ARCHITECTURE Behavior OF Lab7_part1 IS

SIGNAL rollover	:	std_logic;
SIGNAL reset		:	std_logic;
SIGNAL clk			:	std_logic;

COMPONENT Module_k_counter 
Generic (Data_k : natural := 20; -- size of the counter is 20
			Data_n : natural := 5); -- size of the counter in binary
				
PORT (clk			:	in 	std_logic;
		reset			:	in 	std_logic;
		Q				: 	out 	std_logic_vector (Data_n-1 downto 0);
		rollover		:	out 	std_logic);
END COMPONENT;

BEGIN 
reset	<= KEY(0);
clk	<= KEY(1);


	Five_bit: Module_k_counter
	GENERIC MAP (Data_k => 20, Data_n => 5)
						
	PORT MAP (clk, reset, LEDR(4 downto 0), rollover);
	
	
LEDR(9)  <= rollover; -- shows rollover on LED 0
	
END Behavior;
	
	


--Module k counter 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Module_k_counter IS 
Generic (Data_k : natural := 20; -- size of the counter is 20
			Data_n : natural := 5 -- size of the counter in binary
			);
			
PORT (clk			:	in 	std_logic;
		reset			:	in 	std_logic;
		Q				: 	out 	std_logic_vector (Data_n-1 downto 0);
		rollover		:	out 	std_logic);
END Module_k_counter;
		
ARCHITECTURE Behavior of Module_k_counter IS 
SIGNAL count : std_logic_vector (Data_n-1 downto 0);

BEGIN

PROCESS (clk, reset)
Begin  
	If reset = '0' THEN
		count <= (others=> '0');
		rollover <= '0';
		
		ELSIF (rising_edge(clk)) THEN
		IF count = data_k THEN
			count <= (others=> '0');
			rollover <= '1';
		ELSE
		Q <= count + '1';
		rollover <= '0';
		END IF;
		
		
	END IF;
		
END PROCESS;

END Behavior;