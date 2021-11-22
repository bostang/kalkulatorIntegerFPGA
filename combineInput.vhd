-- modul combineInput
	-- menggabungkan digit input yang telah dikonversi dari ASCII ke binary
	-- menjadi sebuah sinyal utuh dengan panjang 12 bit supaya bisa diteruskan
	-- ke operator

-- library
library ieee;
use ieee.std_logic_1164.all;

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
begin
	digOut(3 downto 0) <= dig0;
	digOut(7 downto 4) <= dig1;
	digOut(11 downto 8) <= dig2;
end arc_combineInput;