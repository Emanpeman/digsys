library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Lab7_part2 is
generic (clkfreq : natural := 50000000);
port (clock_50				:	in	std_logic;
		key					:	in	std_logic_vector(0 to 0);
		hex0, hex1, hex2	:	out std_logic_vector(0 to 6)
		);
end Lab7_part2;

		
architecture behavior of Lab7_part2 is
	signal reset, clk, tick			: std_logic;
	signal toggle					: std_logic_vector (3 downto 0);
	signal ener, tier, hundrer	: std_logic_vector (3 downto 0);
	
	

	component bcd7seg 
		port (bcd		:	in	std_logic_vector (3 downto 0);
				display	:	out std_logic_vector(0 to 6)
				);
	end component;
	
	component module_k_counter
		generic (Data_k : natural := 10 -- size of the counter is 20
					);
			
		port (clk			:	in 	std_logic;
				reset			:	in 	std_logic;
				Q				: 	out 	std_logic_vector (3 downto 0);
				rollover		:	out 	std_logic);
	end component;
		


begin 
reset <= Key(0);
clk <= clock_50;
	

	process (clk)
		variable tmp: natural;
	begin 
		if (rising_edge(clk)) then
			tmp := tmp + 1;
			if tmp = clkfreq then 
				tick <= '1';
				tmp := 0;
			else
				tick <= '0';
			end if;
			
		end if;
	end process;
	
	U0 : module_k_counter port map (tick, reset, ener, toggle(0));
	U1	: module_k_counter port map (toggle(0), reset, tier, toggle(1));
	U2 : module_k_counter port map (toggle(1), reset, hundrer, toggle(2));
	
	U3	: bcd7seg port map (ener, hex0);
	U4 : bcd7seg port map (tier, hex1);
	U5 : bcd7seg port map (hundrer, hex2);
	
	end behavior;
	
		

--Module k counter 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Module_k_counter is 
	generic (Data_k : natural := 10 -- size of the counter is 10
				);
			
	port (clk			:	in 	std_logic;
			reset			:	in 	std_logic;
			Q				: 	out 	std_logic_vector (3 downto 0);
			rollover		:	out 	std_logic);
end Module_k_counter;
		
architecture Behavior of Module_k_counter is 
	signal count : std_logic_vector (3 downto 0);

begin

	process (clk, reset)
	begin  
		if reset = '0' then
			count <= (others=> '0');
			rollover <= '0';
		
			elsif (rising_edge(clk)) then
			if count = data_k then
				count <= (others=> '0');
				rollover <= '1';
			else
				Q <= count + '1';
				rollover <= '0';
			end if;
		end if;
		
end process;

end behavior;


--BCD to 7seg
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bcd7seg IS
	PORT( bcd		:	IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
			display	: OUT STD_LOGIC_VECTOR (0 TO 6));
		
END bcd7seg;

ARCHITECTURE behaviour OF bcd7seg is
BEGIN
	
--	
-- 	  0
-- 	-----
-- 	|   |
--   5|   |1
-- 	| 6 |
-- 	-----
-- 	|   |
--   4|   |2
-- 	|   |
-- 	-----
--		  3
--

	PROCESS (bcd)
	BEGIN
		CASE bcd IS
			WHEN "0000" => display <= "1000000"; -- 0
			WHEN "0001" => display <= "1111001"; -- 1
			WHEN "0010"	=> display <= "0100100"; -- 2
			WHEN "0011" => display <= "0110000"; -- 3
			WHEN "0100" => display <= "0011001"; -- 4
			WHEN "0101" => display <= "0010010"; -- 5
			WHEN "0110" => display <= "0000010"; -- 6
			WHEN "0111" => display <= "1111000"; -- 7
			WHEN "1000" => display <= "0000000"; -- 8
			WHEN "1001" => display <= "0011000"; -- 9
			WHEN OTHERS => display <= "1111111"; -- ingenting
			
		END CASE;
			
	END PROCESS;
	
END behaviour;

