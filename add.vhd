-- modul add
	-- Blok yang digunakan sebagai penjumlah dari dua input.
	-- Blok ini menerima input dua buah  bit logic vector panjang 12
	-- dan mengembalikan hasil operasi berupa bit logic vector panjang 16
	
-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity add is
	port
	(
		x, y   : in std_logic_vector(11 downto 0); -- operan		
		result : out std_logic_vector(15 downto 0) -- output hasil operasi
	); 
end add;

-- arsitektur
architecture add_arc of add is 
	signal x_temp : std_logic_vector (15 downto 0);
	signal y_temp : std_logic_vector (15 downto 0);
begin
	x_temp <= "0000" & x;
	y_temp <= "0000" & y;

	result <= unsigned(x_temp) + unsigned(y_temp);
end add_arc;