-- modul modulo
	-- Blok yang  memisahkan hasil perhitungan aritmatika (16 bit) menjadi 4 digit * 4 bit
	-- yang kemudian akan diteruskan ke output generator untuk ditampilkan pada 7 segmen

-- library
library  ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas 
entity modulo is 
	port
	(
		clk		: in std_logic;
	    input 	: in  std_logic_vector(15 downto 0); -- angka yang diterima dari hasil operasi aritmatika 
	    hasil1	: out std_logic_vector(3 downto 0); -- output digit satuan	
	    hasil2	: out std_logic_vector(3 downto 0); -- output digit puluhan
	    hasil3	: out std_logic_vector(3 downto 0); -- output digit ratusan
	    hasil4	: out std_logic_vector(3 downto 0) -- output digit ribuan
    );
end modulo; 

-- arsitektur
architecture modulo of modulo is 
	signal inmod10	 : integer; -- input yang telah dikonversi ke integer dan dimodulo-kan dengan 10
	signal inmod100  : integer;
	signal inmod1000 : integer;
begin
	process(input, clk, inmod10, inmod100, inmod1000)
	begin
		if rising_edge(clk) then
			inmod10   <= conv_integer(input) mod 10;
			inmod100  <= conv_integer(input) mod 100;
			inmod1000 <= conv_integer(input) mod 1000;
			hasil1	  <= conv_std_logic_vector(inmod10,4);
		end if;

			-- menentukan digit puluhan	
		if 10 + inmod10 = inmod100 then
			hasil2 <= "0001";
		elsif 20 + inmod10 = inmod100 then
			hasil2 <= "0010";
		elsif 30 + inmod10 = inmod100 then
			hasil2 <= "0011";
		elsif 40 + inmod10 = inmod100 then
			hasil2 <= "0100";
		elsif 50 + inmod10 = inmod100 then
			hasil2 <= "0101";
		elsif 60 + inmod10 = inmod100 then
			hasil2 <= "0110";
		elsif 70 + inmod10 = inmod100 then
			hasil2 <= "0111";
		elsif 80 + inmod10 = inmod100 then
			hasil2 <= "1000";
		elsif 90 + inmod10 = inmod100 then
			hasil2 <= "1001";
		else
			hasil2 <= "0000";
		end if;

			-- menentukan digit ratusan
		if 100 + inmod100 = inmod1000 then
			hasil3 <= "0001";
		elsif 200 + inmod100 = inmod1000 then
			hasil3 <= "0010";
		elsif 300 + inmod100 = inmod1000 then
			hasil3 <= "0011";
		elsif 400 + inmod100 = inmod1000 then
			hasil3 <= "0100";
		elsif 500 + inmod100 = inmod1000 then
			hasil3 <= "0101";
		elsif 600 + inmod100 = inmod1000 then
			hasil3 <= "0110";
		elsif 700 + inmod100 = inmod1000 then
			hasil3 <= "0111";
		elsif 800 + inmod100 = inmod1000 then
			hasil3 <= "1000";
		elsif 900 + inmod100 = inmod1000 then
			hasil3 <= "1001";
		else
			hasil3 <= "0000";
		end if;		
			-- menentukan digit ribuan
		if 1000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0001";
		elsif 2000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0010";
		elsif 3000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0011";
		elsif 4000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0100";
		elsif 5000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0101";
		elsif 6000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0110";
		elsif 7000 + inmod1000 = conv_integer(input) then
			hasil4 <= "0111";
		elsif 8000 + inmod1000 = conv_integer(input) then
			hasil4 <= "1000";
		elsif 9000 + inmod1000 = conv_integer(input) then
			hasil4 <= "1001";
		else
			hasil4 <= "0000";
		end if;

	end process;
end modulo;