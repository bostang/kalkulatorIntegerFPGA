-- modul reg2
	-- Blok register untuk menyimpan input bit operator dengan panjang 2 bit
	-- dari hasil keluaran ASCII_to_operator

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity reg2 is
	port
	(
		clk, load, clr: in std_logic;
		D: in std_logic_vector(1 downto 0);
		Q: out std_logic_vector(1 downto 0) 
	);
end reg2;

-- arsitektur
architecture reg_arc of reg2 is 
begin
	process(clr, clk, load, D) 
	begin
		if( clr = '1' ) then
			Q <= "00";
		elsif( clk'event and clk = '1') then
			if(load = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end reg_arc;