-- modul add
	-- Blok yang digunakan sebagai penjumlah dari dua input.
	-- Blok ini menerima input dari 4 register operan dan memilih mana 
	--	yang harus dioperasikan berdasarkan input sinyal digit2, 
	-- yaitu penanda apakah input sepanjang 1 digit atau 2 digit
	
-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity add is
	port
	(
		xdigit2, ydigit2 : in std_logic; -- input jumlah digit |  = 1 -> 2 digit, = 0 -> 1 digit
		x1, y1			 : in std_logic_vector(3 downto 0); -- input angka, dari register
		x2, y2 			 : in std_logic_vector(7 downto 0); -- input angka, dari register
		output 			 : out std_logic_vector(7 downto 0) -- output hasil operasi
	); 
end add;

-- arsitektur
architecture add_arc of add is 
	signal result : std_logic_vector (7 downto 0);
	signal x 	  : std_logic_vector (7 downto 0) := "00000000";
	signal y 	  : std_logic_vector (7 downto 0) := "00000000";
begin
	process(xdigit2, ydigit2, x1, x2, y1, y2, result, x, y)
	begin -- algoritma utama operasi penjumlahan
			-- intinya bila bilangan 1 digit, maka dibuat 2 digit dengan mengeset digit 1 = 0 
		x (3 downto 0) <= x1; -- x = 0000(x1(3))(x1(2))(x1(1))(x1(0))
		y (3 downto 0) <= y1; -- y = 0000(y1(3))(y1(2))(y1(1))(y1(0))
		if xdigit2 = '1' and ydigit2 = '1' then -- x dan y sama-sama 2 digit
			result <= unsigned(x2) + unsigned(y2);
		elsif xdigit2 = '1' and ydigit2 = '0' then -- x 2 digit, y 1 digit
			result <= unsigned(x2) + unsigned(y);
		elsif xdigit2 = '0' and ydigit2 = '1' then -- x 1 digit, y 2 digit
			result <= unsigned(x) + unsigned(y2);
		elsif xdigit2 = '0' and ydigit2 = '0' then -- x dan y sama-sama 1 digit
			result <= unsigned(x) + unsigned(y);
		else
			result <= "00000000";
		end if;
		
		-- OUTPUT GENERATOR
		if result > 100 then -- kalau hasil operasi penjumlahan lebih dari 1 digit, maka tidak ditampilkan 
			output <= "00000000";
		else
			output <= result;
		end if;
	end process;
end add_arc;