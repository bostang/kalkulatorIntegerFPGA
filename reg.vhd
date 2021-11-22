-- modul reg
	-- Blok register, berfungsi menyimpan input 
	-- digit pertama yang diberikan pengguna

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
		i_1: in std_logic_vector( 3 downto 0 );
		o_1: out std_logic_vector( 3 downto 0 ) 
	);
end reg;

-- arsitektur
architecture reg_arc of reg is 
begin
	process(clr, clk, load, i_1) 
	begin
		if( clr = '1' ) then
			o_1 <= "0000";
		elsif( clk'event and clk = '1') then
			if( load = '1' and i_1 < 10 ) then
				o_1 <= i_1;
			end if;
		end if;
	end process;
end reg_arc;