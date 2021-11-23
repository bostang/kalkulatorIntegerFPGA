-- modul mux
	-- Blok yang mengatur output dari blok operasi mana
	-- yang dijadikan output berdasarkan input operator

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity mux is
	port
	(
		mux_on 		        : in std_logic; -- penanda mux digunakan [ akan dikendalikan FSM ]
		sel 	 	        : in std_logic_vector (1 downto 0); -- selektor operasi [ akan dikendalikan FSM]
		mult, sub, add, div : in std_logic_vector(15 downto 0); -- hasil operasi komparasi, pengurangan, penjumlahan 
		answer 		        : out std_logic_vector(15 downto 0) -- output selektor
	); 
end mux;

-- arsitektur
architecture mux_arc of mux is
begin
	process(mux_on, sel, mult, sub, add, div) 
	begin
		if mux_on = '1' then
			if sel = "00" then
				answer <= div; -- ketika selektor = 0, memilih hasil operasi pembagian
			elsif sel = "01" then
				answer <= sub; -- ketika selektor = 1, memilih hasil operasi pengurangan
			elsif sel = "10" then
				answer <= add; -- ketika selektor = 2, memilih hasil operasi penjumlahan
			elsif sel = "11" then
				answer <= mult; -- ketika selektor = 3, memilih hasil operasi perkalian
			else
				answer <= (others => '0');
			end if;
		else
			answer <= (others => '0');
		end if;
	end process; 
end mux_arc;