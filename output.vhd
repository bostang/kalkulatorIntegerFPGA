-- modul output generator
	-- Blok yang menampilkan hasil perhitungan yang telah dipisah menggunakan modulo
	-- pada  7-segment

-- libary
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity output is
	port
	(
		clk 							   : in std_logic;
		reset							   : in std_logic;
		hasil1,hasil2, hasil3, hasil4	   : in std_logic_vector(3 downto 0); -- input angka, dari register 2
		out_on							   : in std_logic; -- menyalakan output
		digOut						   : out std_logic_vector(3 downto 0); -- digit satuan/puluhan/ratusan/ribuan pada 7-segment
		segOut	 					       : out std_logic_vector(7 downto 0) -- segmen yang menyala pada 7-segment
		
	); 
end output;

-- arsitektur
architecture arc_output of output is
	signal selector: std_logic_vector(3 downto 0):= "1111"; -- sinyal internal untuk ring counter
	signal dig3, dig2, dig1, dig0 : std_logic_vector(7 downto 0); -- angka yang ditampilkan pada masing-masing digit
	signal clk_divider : unsigned(15 downto 0):=(others=>'0'); -- di-inisiasi dengan nol
	signal clk_out : std_logic;

begin

		-- mengonversi dari bit ke 7-segment
	process(reset, hasil1, hasil2, hasil3, hasil4, out_on)
	begin
		case hasil1 is
			when "0000" =>
				dig0 <= "00000011"; -- 0
		 	when "0001" =>
				dig0 <= "10011111"; -- 1
		 	when "0010" =>
				dig0 <= "00100101"; -- 2
		 	when "0011" =>
				dig0 <= "00001101"; -- 3 
		 	when "0100" =>
				dig0 <= "10011001"; -- 4    
			when "0101" =>
				dig0 <= "01001001"; -- 5
			when "0110" =>
				dig0 <= "01000001"; -- 6
	 		when "0111" =>
				dig0 <= "00011111"; -- 7
			when "1000" =>
				dig0 <= "00000001"; -- 8
			when "1001" =>
				dig0 <= "00001001"; -- 9
			when others =>
				dig0 <= "11111111";
			end case;

		case hasil2 is
			when "0000" =>
				dig1 <= "00000011"; -- 0
		 	when "0001" =>
				dig1 <= "10011111"; -- 1
		 	when "0010" =>
				dig1 <= "00100101"; -- 2
		 	when "0011" =>
				dig1 <= "00001101"; -- 3 
		 	when "0100" =>
				dig1 <= "10011001"; -- 4    
			when "0101" =>
				dig1 <= "01001001"; -- 5
			when "0110" =>
				dig1 <= "01000001"; -- 6
	 		when "0111" =>
				dig1 <= "00011111"; -- 7
			when "1000" =>
				dig1 <= "00000001"; -- 8
			when "1001" =>
				dig1 <= "00001001"; -- 9
			when others =>
				dig1 <= "11111111";
			end case;

		case hasil3 is
			when "0000" =>
				dig2 <= "00000011"; -- 0
		 	when "0001" =>
				dig2 <= "10011111"; -- 1
		 	when "0010" =>
				dig2 <= "00100101"; -- 2
		 	when "0011" =>
				dig2 <= "00001101"; -- 3 
		 	when "0100" =>
				dig2 <= "10011001"; -- 4    
			when "0101" =>
				dig2 <= "01001001"; -- 5
			when "0110" =>
				dig2 <= "01000001"; -- 6
	 		when "0111" =>
				dig2 <= "00011111"; -- 7
			when "1000" =>
				dig2 <= "00000001"; -- 8
			when "1001" =>
				dig2 <= "00001001"; -- 9
			when others =>
				dig2 <= "11111111";
			end case;

		case hasil4 is
			when "0000" =>
				dig3 <= "00000011"; -- 0
		 	when "0001" =>
				dig3 <= "10011111"; -- 1
		 	when "0010" =>
				dig3 <= "00100101"; -- 2
		 	when "0011" =>
				dig3 <= "00001101"; -- 3 
		 	when "0100" =>
				dig3 <= "10011001"; -- 4    
			when "0101" =>
				dig3 <= "01001001"; -- 5
			when "0110" =>
				dig3 <= "01000001"; -- 6
	 		when "0111" =>
				dig3 <= "00011111"; -- 7
			when "1000" =>
				dig3 <= "00000001"; -- 8
			when "1001" =>
				dig3 <= "00001001"; -- 9
			when others =>
				dig3 <= "11111111";
			end case;			
	end process;		 
	clockDivider : process(reset,clk)
		-- mendapatkan clock dengan frekuensi yang kita inginkan
		begin
		  if(reset='0') then -- reset = '0' berarti tombol reset ditekan
			clk_divider   <= (others=>'0');
		  elsif(rising_edge(clk)) then
			clk_divider   <= clk_divider + 1;
		  end if;
	end process clockDivider;

	clk_out <= clk_divider(15);  -- f_out = 50 Mhz /(2^15)

	gilir : process(clk_out,reset)
		-- membuat sekuens 1110 -> 1101 -> 1011 -> 0111 dengan ring counter
    begin
	    if reset = '0' then
	        selector <= "1110";
	    elsif rising_edge(clk_out) then -- sama dengan (clk_out'event and clk_out = 1)
	        selector(1) <= selector(0);
	        selector(2) <= selector(1);
	        selector(3) <= selector(2);
	        selector(0) <= selector(3);
	    end if;
    end process gilir;

	seleksi : process(selector,out_on)
		-- melakukan proses penggiliran 7-segment dengan sekuens dari ring counter
	begin
		digOut <= selector;
		if (out_on = '0') then
			segOut <= "11111111";
		else
			case selector is
				when "0111" => segOut <= dig3; -- 0 (most significant byte [MSB])
				when "1011" => segOut <= dig2; -- 0
				when "1101" => segOut <= dig1; -- 5
				when "1110" => segOut <= dig0; -- 5 (least significant byte [LSB])
				when others => segOut <= "11111111";
			end case;
		end if;
	end process seleksi;
end arc_output;
