-- modul mult
	-- Blok pengali dua input. Blok ini menerima input dari
	-- 4 register operan dan memilih mana yang harus dioperasikan 
	-- berdasarkan input sinyal digit2, yaitu penanda apakah 
	-- input sepanjang 1 digit atau 2 digit

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity mult is
	port
	(
		xdigit2, ydigit2: in std_logic; -- input jumlah digit
		x1, y1 			: in std_logic_vector(3 downto 0); -- input angka, dari register
		x2, y2 			: in std_logic_vector(7 downto 0); -- input angka, dari register
		output 			: out std_logic_vector(7 downto 0) -- output hasil operasi
	); 
end mult;

-- arsitektur
architecture mult_arc of mult is 
	signal result : std_logic_vector (15 downto 0);
begin
	process(xdigit2, ydigit2, x1, x2, y1, y2, result)
	begin -- algoritma utama operasi penjumlahan
		if xdigit2 = '1' and ydigit2 = '1' then
			result <= unsigned(x2) * unsigned(y2);
		elsif xdigit2 = '1' and ydigit2 = '0' then
			result (11 downto 0) <= unsigned(x2) * unsigned(y1);
			result (15 downto 12) <= "0000";
		elsif xdigit2 = '0' and ydigit2 = '1' then
			result (11 downto 0) <= unsigned(x1) * unsigned(y2);
			result (15 downto 12) <= "0000";
		elsif xdigit2 = '0' and ydigit2 = '0' then			
			result (7 downto 0) <= unsigned(x1) * unsigned(y1);
			result (15 downto 8) <= "00000000";
		else
			result <= "0000000000000000";
		end if;
		-- OUTPUT GENERATOR
		if result > 100 then
			output <= "00000000";
		else
			output <= result (7 downto 0);
		end if;
	end process;
end mult_arc;