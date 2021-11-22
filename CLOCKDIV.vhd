-- modul CLOCKDIV 
	-- Blok yang digunakan untuk memperlambat periode dari clock FPGA.
	-- Digunakan pada FSM agar perpindahan antar statenya 
	-- tidak terlalu cepat sehingga input bisa sesuai

-- library
library ieee;
USE ieee.std_logic_1164.ALL;

-- entitas
entity CLOCKDIV is
	port
	(
		clk    : in std_logic;
		divOut : buffer std_logic
	);
end CLOCKDIV;

-- arsitektur
architecture behavioural of CLOCKDIV is
begin
	process(clk)
		variable count : integer:=0; -- 'mod n' counter
		constant div   : integer:=4000000; -- periode_baru = periode_FPGA / div		
	begin
		if clk'event and clk='1' then
			if(count<div) then
				count:=count+1;						
				if(divOut='0') then
					divOut<='0';
				elsif(divOut='1') then
					divOut<='1';
				end if;
			else
				if(divOut='0') then
					divOut<='1';
				elsif(divOut='1') then
					divOut<='0';
				end if;
			count:=0;
			end if;
		end if;
	end process;
end behavioural;