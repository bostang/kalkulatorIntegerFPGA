-- modul reg
	-- Blok register, berfungsi menyimpan input bit operan dengan panjang 12

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity reg is
	port
	(
		clk, xload, clr: in std_logic;
		x_temp: in std_logic_vector( 11 downto 0 );
		x: out std_logic_vector( 11 downto 0 ) 
	);
end reg;

-- arsitektur
architecture reg_arc of reg is 
begin
	process(clr, clk, xload, x_temp) 
	begin
		if( clr = '1' ) then
			x <= "000000000000";
		elsif( clk'event and clk = '1') then
			if( xload = '1' and x_temp < 1000 ) then
				x <= x_temp;
			end if;
		end if;
	end process;
end reg_arc;