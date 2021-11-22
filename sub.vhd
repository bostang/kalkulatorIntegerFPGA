-- modul sub
	-- Blok pengurang dua input. Blok ini menerima input dari 
	-- 4 register operan dan memilih mana yang harus dioperasikan 
	-- berdasarkan input sinyal digit2, yaitu penanda apakah input sepanjang 1 
	-- digit atau 2 digit. Sebelum diakukan operasi, blok akan membandingkan 
	-- antara operan1 dengan operan2. Jika operan1 < operan2, 
	-- maka sinyal neg akan bernilai 0 sehingga led penanda output negatif menyala

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity sub is
	port
	(
		xdigit2, ydigit2 : in std_logic; -- input jumlah digit
		x1, y1 			 : in std_logic_vector(3 downto 0); -- input angka, dari register 1
		x2, y2 			 : in std_logic_vector(7 downto 0); -- input angka, dari register 2
		neg	   			 : buffer std_logic; --penanda negatif
		output 			 : out std_logic_vector(7 downto 0) -- output hasil operasi
	); 
end sub;

-- arsitektur
architecture sub_arc of sub is 
	signal result : std_logic_vector (7 downto 0);
	signal x: std_logic_vector (7 downto 0) := "00000000";
	signal y: std_logic_vector (7 downto 0) := "00000000";
begin
	process(xdigit2, ydigit2, x1, x2, y1, y2, result, x, y, neg)
	begin -- algoritma utama operasi pengurangan
		neg <= '1';
		if xdigit2 = '1' and ydigit2 = '1' then
			if x2 >= y2 then
				result <= unsigned(x2)-unsigned(y2);
			else
				result <= unsigned(y2)-unsigned(x2);
				neg <= '0';
			end if;
		elsif xdigit2 = '1' and ydigit2 = '0' then
			result <= unsigned(x2) - unsigned(y1);
		elsif xdigit2 = '0' and ydigit2 = '1' then
			result <= unsigned(y2)-unsigned(x1);
			neg <= '0';
		elsif xdigit2 = '0' and ydigit2 = '0' then
			x (3 downto 0) <= x1;
			y (3 downto 0) <= y1;			
			if x >= y then
				result <= unsigned(x)-unsigned(y);
			else
				result <= unsigned(y)-unsigned(x);
				neg <= '0';
			end if;	
		else
			result <= "00000000";
		end if;

		-- OUTPUT GENERATOR
		if result > 100 then
			output <= "00000000";
		else
			output <= result;
		end if;
	end process;
end sub_arc;
 