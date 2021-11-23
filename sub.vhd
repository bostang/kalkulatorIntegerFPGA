-- modul sub
	-- Blok yang digunakan sebagai pengurangan dari dua input.
	-- Blok ini menerima input dua buah bit logic vector panjang 12 (x dan y)
	-- dan mengembalikan hasil operasi berupa bit logic vector panjang 16( result)
	-- operasi yang dilakukan adalah result = x - y
	-- bila x < y, maka sinyal neg yang menyatakan bahwa hasil operasi negatif akan menyala

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity sub is
	port
	(
		x, y   : in std_logic_vector(11 downto 0); -- operan
		neg    : out std_logic; -- menyatakan bahwa hasil negatif
		result : out std_logic_vector(15 downto 0) -- output hasil operasi
	); 
end sub;

-- arsitektur
architecture sub_arc of sub is 
	signal x_temp : std_logic_vector (15 downto 0);
	signal y_temp : std_logic_vector (15 downto 0);
begin
	x_temp <= "0000" & x;
	y_temp <= "0000" & y;

	cek_negatif : process(x_temp,y_temp) -- yang dimasukkan ke sensitiviy list adalah x_temp, bukan x
	begin
		if (x < y) then
			result <= unsigned(y_temp) - unsigned(x_temp);
			neg <= '0'; -- 0 berarti hasil negatif dan led penanda negatif akan menyala 
		else
			result <= unsigned(x_temp) - unsigned(y_temp);
			neg <= '1';
		end if;
	end process cek_negatif;
end sub_arc;