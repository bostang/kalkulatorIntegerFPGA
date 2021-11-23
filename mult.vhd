-- modul mult
	-- Blok yang digunakan untuk mengalikan dua input.
	-- Blok ini menerima input dua buah bit logic vector panjang 12 (x dan y)
	-- dan mengembalikan hasil operasi berupa bit logic vector panjang 16( result)
	-- operasi yang dilakukan adalah result = x * y
	-- bila x * y melebihi 9999 , maka yang diteruskan sebagai
	-- output adalah "0" sebanyak 16 kali [ supaya pada 7-segment ditampilkan 0000]

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity mult is
	port
	(
		x, y   : in std_logic_vector(11 downto 0); -- operan
		result : out std_logic_vector(15 downto 0) -- output hasil operasi
	); 
end mult;

-- arsitektur
architecture mult_arc of mult is 
	signal result_temp : std_logic_vector (23 downto 0);

begin
	cek_negatif : process(x,y,result_temp) -- yang dimasukkan ke sensitiviy list adalah x_temp, bukan x
	begin
		if (x * y > "000000000010011100001111") then -- x * y > 9999
			result_temp<= (others => '0');
		else
			result_temp <= unsigned(x) * unsigned(y);
		end if;
		result <= result_temp(15 downto 0);
	end process cek_negatif;
end mult_arc;