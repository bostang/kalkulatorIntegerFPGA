-- modul combineInput
	-- menggabungkan digit input yang telah dikonversi dari ASCII ke binary
	-- menjadi sebuah sinyal utuh dengan panjang 12 bit supaya bisa diteruskan
	-- ke operator

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity combineInput is
	port
	(
		dig2, dig1, dig0 : in std_logic_vector(3 downto 0);
		digOut     		 : out std_logic_vector(11 downto 0)
	);
end combineInput;

-- arsitektur
architecture arc_combineInput of combineInput is
	signal temp_dig2_1 : std_logic_vector(11 downto 0);
	signal temp_dig2_2 : std_logic_vector(11 downto 0);
	signal temp_dig2_3 : std_logic_vector(11 downto 0);
	signal temp_dig1_1 : std_logic_vector(11 downto 0);
	signal temp_dig1_2 : std_logic_vector(11 downto 0);
	signal temp_dig0   : std_logic_vector(11 downto 0);

begin
	temp_dig2_1 <= "00" & dig2 & "000000"; -- temp_dig2_1 : 64 * dig_2
	temp_dig2_2 <= "000" & dig2 & "00000"; -- temp_dig2_2 : 32 * dig_2
	temp_dig2_3 <= "000000" & dig2 & "00"; -- temp_dig2_3 : 4  * dig_2	
	temp_dig1_1 <= "00000" & dig1 & "000"; -- temp_dig1_1 : 8 * dig_1
	temp_dig1_2 <= "0000000" & dig1 & "0"; -- temp_dig1_2 : 2 * dig_1
	temp_dig0   <= "00000000" & dig0; 

	digOut <= unsigned(temp_dig0) + unsigned(temp_dig1_1) 
			+ unsigned(temp_dig1_2) + unsigned(temp_dig2_1) 
			+ unsigned(temp_dig2_2) + unsigned(temp_dig2_3);
end arc_combineInput;	
	
	-- catatan :
-- abc = 100 * a + 10 * b + c
-- 	   = (64 + 32 + 4) * a + (8 + 2) * b + c

-- 2^n * a = a yang ditambahkan nol di kanan sebanyak n buah
-- contoh : 64 * b'0110' = 2 ^ 6 * b'0110' = 0110[000000] 