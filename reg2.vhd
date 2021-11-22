-- modul reg2
	-- Blok register 2 angka, berfungsi menyimpan hasil 
	-- penggabungan digit pertama dari reg.vhd 
	-- dengan input kedua dari pengguna. Input 
	-- pertama berlaku sebagai angka puluhan, 
	-- input kedua sebagai satuan

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity reg2 is
	port
	(
		rst,clr, clk, load2, digit2 : in std_logic;
		i_1, i_2 					: in std_logic_vector( 3 downto 0 ); -- i_1 : puluhan , i_2 : satuan
		o_2 						: out std_logic_vector( 7 downto 0 ) 
	);
end reg2;

-- arsitektur
architecture reg2_arc of reg2 is
	signal a : unsigned (7 downto 0); 
begin
	process(rst, clr, clk, load2, i_1, i_2, digit2) 
	begin
		if(clr = '1' or rst = '1' or digit2 = '0') then
			o_2 <= "00000000";
		elsif( clk'event and clk = '1') then
			if( load2 = '1' ) then
				if i_1 < 10 AND i_2 < 10 then -- jika input valid
					a <= (unsigned (i_1) * "1010"); -- digit pertama * 10 
					o_2 <= a + unsigned(i_2); -- digit pertama + digit kedua
				end if;
			end if;
		end if;
	end process;
end reg2_arc;