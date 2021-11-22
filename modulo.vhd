-- modul modulo
	-- Blok yang  memisahkan 2 digit  hasil pengoperasian 
	-- guna menampilkan hasil pada bcd 7 segmen

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
	    input 	: in std_logic_vector(7 downto 0); -- input tahun switch
	    output1	: out std_logic_vector(3 downto 0); -- input untuk operator
	    output2	: out std_logic_vector(3 downto 0) -- input untuk operator
    );
end modulo; 

-- arsitektur
architecture modulo of modulo is 
	signal hasil	: integer;
begin
	process(input, clk, hasil)
	begin
		if rising_edge(clk) then
			hasil <= conv_integer(input) mod 10;
			output1	<= conv_std_logic_vector(hasil,4);
		end if;
		
		if 10 + hasil = conv_integer(input) then
			output2 <= "0001";
		elsif 20 + hasil = conv_integer(input) then
			output2 <= "0010";
		elsif 30 + hasil = conv_integer(input) then
			output2 <= "0011";
		elsif 40 + hasil = conv_integer(input) then
			output2 <= "0100";
		elsif 50 + hasil = conv_integer(input) then
			output2 <= "0101";
		elsif 60 + hasil = conv_integer(input) then
			output2 <= "0110";
		elsif 70 + hasil = conv_integer(input) then
			output2 <= "0111";
		elsif 80 + hasil = conv_integer(input) then
			output2 <= "1000";
		elsif 90 + hasil = conv_integer(input) then
			output2 <= "1001";
		else
			output2 <= "0000";
		end if;
	end process;
end modulo;