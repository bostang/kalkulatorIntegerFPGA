-- modul mux4bit
	-- Blok multiplexer 4 bit yang nanti akan digunakan
	-- untuk mengatur digit mana yang akan diteruskan
	-- ke converter binary_to_ASCII untuk menampilkan
	-- hasil operasi aritmatika pada termite

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity mux4bit is
	port
	(
		mux_on 		           : in std_logic; -- penanda mux digunakan [ akan dikendalikan FSM ]
		sel 	 	           : in std_logic_vector (1 downto 0); -- selektor operasi [ akan dikendalikan FSM]
		in11, in01, in10, in00 : in std_logic_vector(3 downto 0); -- hasil operasi komparasi, pengurangan, penjumlahan 
		outmux 		           : out std_logic_vector(3 downto 0) -- output selektor
	); 
end mux4bit;

-- arsitektur
architecture mux4bit_arc of mux4bit is
begin
	process(mux_on, sel, in11, in01, in10, in00) 
	begin
		if mux_on = '1' then
			if sel = "00" then
				outmux <= in00; -- ketika selektor = 0, memilih hasil operasi pembagian
			elsif sel = "01" then
				outmux <= in01; -- ketika selektor = 1, memilih hasil operasi pengurangan
			elsif sel = "10" then
				outmux <= in10; -- ketika selektor = 2, memilih hasil operasi penjumlahan
			elsif sel = "11" then
				outmux <= in11; -- ketika selektor = 3, memilih hasil operasi perkalian
			else
				outmux <= (others => '0');
			end if;
		else
			outmux <= (others => '0');
		end if;
	end process; 
end mux4bit_arc;
