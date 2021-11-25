-- modul reg8 
	-- block komponen register 8-bit yang dilengkapi fitur reset dan load (LD)
	-- yang akan digunakan untuk menyimpan data ASCII pada register REG_ASCII_y2, REG_ASCII_y1, REG_ASCII_y0
	-- REG_ASCII_x2, REG_ASCII_x1, REG_ASCII_x0, REG_ASCII_operator

-- library
library ieee;
use ieee.std_logic_1164.all;

-- entitas
entity reg8 is
	Port
	(
		REG_IN : in std_logic_vector(7 downto 0);
		LD,CLK : in std_logic;
		reset  : in std_logic;
		REG_OUT : out std_logic_vector(7 downto 0)
	);
end reg8;

-- arsitektur
architecture reg8 of reg8 is
begin
	reg: process(CLK)
	begin
		if reset = '0' then
			REG_OUT <= "11111111";
		elsif (rising_edge(CLK)) then
			if (LD = '1') then
				REG_OUT <= REG_IN;
			end if;
		end if;
	end process;
end reg8;