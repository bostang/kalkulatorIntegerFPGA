-- modul reg12
	-- Blok register yang menyimpan input bit operan dengan panjang 12 bit

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity reg is
	port
	(
		clk, load, clr: in std_logic;
		D: in std_logic_vector( 11 downto 0 );
		Q: out std_logic_vector( 11 downto 0 ) 
	);
end reg;

-- arsitektur
architecture reg_arc of reg is 
begin
	process(clr, clk, load, D) 
	begin
		if( clr = '1' ) then
			Q <= "000000000000";
		elsif( clk'event and clk = '1') then
			if( load = '1' and D < 1000 ) then
				Q <= D;
			end if;
		end if;
	end process;
end reg_arc;
