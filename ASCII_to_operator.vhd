-- modul ASCII_to_operator
	-- mengonversi data ASCII yang diterima dari termite sebelum masuk ke register 
	-- operator dan diteruskan ke multiplexer sebagai sinyal selektor operator  

	-- dari sini kita juga bisa lihat bahwa jumlah bit yang bisa disimpan pada register
	-- untuk menyimpan digit operan dan register untuk menyimpan operator berbeda.
	-- untuk register operator, bit yang bisa disimpan hanyalah 2 bit

-- libary
library ieee;
use ieee.std_logic_1164.all;

-- entitas
entity ASCII_to_operator is
	port
	(
		opload : in std_logic_vector(7 downto 0); -- 8 bit input dalam bentuk ASCII
		optemp : out std_logic_vector(1 downto 0) -- sinyal keluaran
	);
end ASCII_to_operator;

-- arsitektur
architecture arc_ASCII_to_operator of ASCII_to_operator is
begin
	konversi : process(opload)
	begin
		if (opload = "00101011") then -- penjumlahan
			optemp <= "10";
		elsif (opload = "00101101") then -- pengurangan
			optemp <= "01";
		elsif (opload = "00101010") then -- perkalian
			optemp <= "11";
		elsif (opload = "00101111") then -- pembagian
			optemp <= "00";
		end if;
	end process konversi;

end arc_ASCII_to_operator;

-- ASCII ke character
	-- 		+ : 0x2B = 0010 1011 
	-- 		- : 0x2D = 0010 1101
	-- 		* : 0x2A = 0010 1010
	-- 		/ : 0x2F = 0010 1111