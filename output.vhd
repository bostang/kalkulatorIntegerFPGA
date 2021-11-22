-- modul output
	-- Blok yang mengatur tampilan dari bcd 7 segmen
	-- berdasarkan sinyal-sinyal input dari fsm

-- libary
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity output is
	port
	(
		reset							   : in std_logic;
		hasil1,hasil2, s_input, xi, yi	   : in std_logic_vector(3 downto 0); -- input angka, dari register 2
		out_on, outx1, outx2, outy1, outy2 : in std_logic; 
		a_7s, b_7s						   : out std_logic_vector(6 downto 0) -- output hasil operasi
	); 
end output;

-- arsitektur
architecture display7S_arc of output is
begin
	process(out_on, hasil1, hasil2, s_input, xi, yi, outx1, outx2, outy1, outy2) 
	begin
		if reset = '1' then
			a_7s 	<= "1111111";
			b_7s	<= "1111111";
		elsif reset = '0' and out_on ='1' then
			case hasil2 is -- display hasil operasi 
				when "0000"=> a_7S <="0000001"; -- '0'
				when "0001"=> a_7S <="1001111"; -- '1'
				when "0010"=> a_7S <="0010010"; -- '2'
				when "0011"=> a_7S <="0000110"; -- '3' 
				when "0100"=> a_7S <="1001100"; -- '4'
				when "0101"=> a_7S <="0100100"; -- '5' 
				when "0110"=> a_7S <="0100000"; -- '6' 
				when "0111"=> a_7S <="0001111"; -- '7' 
				when "1000"=> a_7S <="0000000"; -- '8' 
				when "1001"=> a_7S <="0000100"; -- '9' 
				when others=> a_7S <="1111111";  
			end case;
			case hasil1 is -- display hasil operasi 
				when "0000"=> b_7S <="0000001"; -- '0'
				when "0001"=> b_7S <="1001111"; -- '1'
				when "0010"=> b_7S <="0010010"; -- '2'
				when "0011"=> b_7S <="0000110"; -- '3' 
				when "0100"=> b_7S <="1001100"; -- '4'
				when "0101"=> b_7S <="0100100"; -- '5' 
				when "0110"=> b_7S <="0100000"; -- '6' 
				when "0111"=> b_7S <="0001111"; -- '7' 
				when "1000"=> b_7S <="0000000"; -- '8' 
				when "1001"=> b_7S <="0000100"; -- '9' 
				when others=> b_7S <="1111111";  
			end case;
		elsif reset ='0' and out_on = '0' then
			if (outx1 = '1' and outx2 = '0' and outy1 ='0' and outy2= '0') then
				case s_input is -- display hasil operasi 
					when "0000"=> b_7S <="0000001"; -- '0'
					when "0001"=> b_7S <="1001111"; -- '1'
					when "0010"=> b_7S <="0010010"; -- '2'
					when "0011"=> b_7S <="0000110"; -- '3' 
					when "0100"=> b_7S <="1001100"; -- '4'
					when "0101"=> b_7S <="0100100"; -- '5' 
					when "0110"=> b_7S <="0100000"; -- '6' 
					when "0111"=> b_7S <="0001111"; -- '7' 
					when "1000"=> b_7S <="0000000"; -- '8' 
					when "1001"=> b_7S <="0000100"; -- '9' 
					when others=> b_7S <="1111111";  
				end case;
				a_7s	<= "1111111";
			elsif outx1 = '1' and outx2 = '1' and outy1 ='0' and outy2= '0' then
				case xi is -- display hasil operasi 
					when "0000"=> a_7S <="0000001"; -- '0'
					when "0001"=> a_7S <="1001111"; -- '1'
					when "0010"=> a_7S <="0010010"; -- '2'
					when "0011"=> a_7S <="0000110"; -- '3' 
					when "0100"=> a_7S <="1001100"; -- '4'
					when "0101"=> a_7S <="0100100"; -- '5' 
					when "0110"=> a_7S <="0100000"; -- '6' 
					when "0111"=> a_7S <="0001111"; -- '7' 
					when "1000"=> a_7S <="0000000"; -- '8' 
					when "1001"=> a_7S <="0000100"; -- '9' 
					when others=> a_7S <="1111111";  
				end case;
				case s_input is -- display hasil operasi 
					when "0000"=> b_7S <="0000001"; -- '0'
					when "0001"=> b_7S <="1001111"; -- '1'
					when "0010"=> b_7S <="0010010"; -- '2'
					when "0011"=> b_7S <="0000110"; -- '3' 
					when "0100"=> b_7S <="1001100"; -- '4'
					when "0101"=> b_7S <="0100100"; -- '5' 
					when "0110"=> b_7S <="0100000"; -- '6' 
					when "0111"=> b_7S <="0001111"; -- '7' 
					when "1000"=> b_7S <="0000000"; -- '8' 
					when "1001"=> b_7S <="0000100"; -- '9' 
					when others=> b_7S <="1111111";  
				end case;
			elsif outx1 = '0' and outx2 = '0' and outy1 ='1' and outy2= '0' then
				case s_input is -- display hasil operasi 
					when "0000"=> b_7S <="0000001"; -- '0'
					when "0001"=> b_7S <="1001111"; -- '1'
					when "0010"=> b_7S <="0010010"; -- '2'
					when "0011"=> b_7S <="0000110"; -- '3' 
					when "0100"=> b_7S <="1001100"; -- '4'
					when "0101"=> b_7S <="0100100"; -- '5' 
					when "0110"=> b_7S <="0100000"; -- '6' 
					when "0111"=> b_7S <="0001111"; -- '7' 
					when "1000"=> b_7S <="0000000"; -- '8' 
					when "1001"=> b_7S <="0000100"; -- '9' 
					when others=> b_7S <="1111111";  
				end case;
				a_7s	<= "1111111";
			elsif outx1 = '0' and outx2 = '0' and outy1 ='1' and outy2= '1' then
				case yi is -- display hasil operasi 
					when "0000"=> a_7S <="0000001"; -- '0'
					when "0001"=> a_7S <="1001111"; -- '1'
					when "0010"=> a_7S <="0010010"; -- '2'
					when "0011"=> a_7S <="0000110"; -- '3' 
					when "0100"=> a_7S <="1001100"; -- '4'
					when "0101"=> a_7S <="0100100"; -- '5' 
					when "0110"=> a_7S <="0100000"; -- '6' 
					when "0111"=> a_7S <="0001111"; -- '7' 
					when "1000"=> a_7S <="0000000"; -- '8' 
					when "1001"=> a_7S <="0000100"; -- '9' 
					when others=> a_7S <="1111111";  
				end case;
				case s_input is -- display hasil operasi 
					when "0000"=> b_7S <="0000001"; -- '0'
					when "0001"=> b_7S <="1001111"; -- '1'
					when "0010"=> b_7S <="0010010"; -- '2'
					when "0011"=> b_7S <="0000110"; -- '3' 
					when "0100"=> b_7S <="1001100"; -- '4'
					when "0101"=> b_7S <="0100100"; -- '5' 
					when "0110"=> b_7S <="0100000"; -- '6' 
					when "0111"=> b_7S <="0001111"; -- '7' 
					when "1000"=> b_7S <="0000000"; -- '8' 
					when "1001"=> b_7S <="0000100"; -- '9' 
					when others=> b_7S <="1111111";  
				end case;
			else 
				a_7s 	<= "1111111";
				b_7s	<= "1111111";
			end if;
		else
			a_7s 	<= "1111111";
			b_7s	<= "1111111";
		end if;
	end process;
end display7S_arc;