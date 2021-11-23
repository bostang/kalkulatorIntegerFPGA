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
		reset							   : in std_logic;
		hasil1,hasil2, hasil3, hasil4	   : in std_logic_vector(3 downto 0); -- input angka, dari register 2
		out_on							   : in std_logic; -- menyalakan output
		digitSS						       : out std_logic_vector(3 downto 0) -- digit satuan/puluhan/ratusan/ribuan pada 7-segment
		sevenSegment 					   : out std_logic_vector(7 downto 0) -- segmen yang menyala pada 7-segment
		
	); 
end output;

-- arsitektur
architecture arc_output of output is
	signal selector: std_logic_vector(3 downto 0):= "1111"; -- sinyal internal untuk ring counter
	signal dig3, dig2, dig1, dig0 : std_logic_vector(6 downto 0); -- angka yang ditampilkan pada masing-masing digit
	signal clk_divider : unsigned(15 downto 0):=(others=>'0'); -- di-inisiasi dengan nol
	signal clk_out : std_logic;

begin

		-- mengonversi dari bit ke 7-segment
	case hasil1 is
		  when "0000" =>
			 dig0 <= "0000001"; -- 0
		  when "0001" =>
			 dig0 <= "1001111"; -- 1
		  when "0010" =>
			 dig0 <= "0010010"; -- 2
		  when "0011" =>
			 dig0 <= "0000110"; -- 3 
		  when "0100" =>
			 dig0 <= "1001100"; -- 4    
		  when "0101" =>
			 dig0 <= "0100100"; -- 5
		  when "0110" =>
			 dig0 <= "0100000"; -- 6
		  when "0111" =>
			 dig0 <= "0001111"; -- 7
		  when "1000" =>
			 dig0 <= "0000000"; -- 8
		  when "1001" =>
			 dig0 <= "0000100"; -- 9

	case hasil2 is
	  when "0000" =>
		 dig1 <= "0000001"; -- 0
	  when "0001" =>
		 dig1 <= "1001111"; -- 1
	  when "0010" =>
		 dig1 <= "0010010"; -- 2
	  when "0011" =>
		 dig1 <= "0000110"; -- 3 
	  when "0100" =>
		 dig1 <= "1001100"; -- 4    
	  when "0101" =>
		 dig1 <= "0100100"; -- 5
	  when "0110" =>
		 dig1 <= "0100000"; -- 6
	  when "0111" =>
		 dig1 <= "0001111"; -- 7
	  when "1000" =>
		 dig1 <= "0000000"; -- 8
	  when "1001" =>
		 dig1 <= "0000100"; -- 9

	case hasil3 is
	  when "0000" =>
		 dig2 <= "0000001"; -- 0
	  when "0001" =>
		 dig2 <= "1001111"; -- 1
	  when "0010" =>
		 dig2 <= "0010010"; -- 2
	  when "0011" =>
		 dig2 <= "0000110"; -- 3 
	  when "0100" =>
		 dig2 <= "1001100"; -- 4    
	  when "0101" =>
		 dig2 <= "0100100"; -- 5
	  when "0110" =>
		 dig2 <= "0100000"; -- 6
	  when "0111" =>
		 dig2 <= "0001111"; -- 7
	  when "1000" =>
		 dig2 <= "0000000"; -- 8
	  when "1001" =>
		 dig2 <= "0000100"; -- 9

	case hasil4 is
		  when "0000" =>
			 dig3 <= "0000001"; -- 0
		  when "0001" =>
			 dig3 <= "1001111"; -- 1
		  when "0010" =>
			 dig3 <= "0010010"; -- 2
		  when "0011" =>
			 dig3 <= "0000110"; -- 3 
		  when "0100" =>
			 dig3 <= "1001100"; -- 4    
		  when "0101" =>
			 dig3 <= "0100100"; -- 5
		  when "0110" =>
			 dig3 <= "0100000"; -- 6
		  when "0111" =>
			 dig3 <= "0001111"; -- 7
		  when "1000" =>
			 dig3 <= "0000000"; -- 8
		  when "1001" =>
			 dig3 <= "0000100"; -- 9
			 
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

	seleksi : process(selector)
		-- melakukan proses penggiliran 7-segment dengan sekuens dari ring counter
	begin
		digOut <= selector;
		case selector is
			when "0111" => segOut <= dig3; -- 0 (most significant byte [MSB])
			when "1011" => segOut <= dig2; -- 0
			when "1101" => segOut <= dig1; -- 5
			when "1110" => segOut <= dig0; -- 5 (least significant byte [LSB])
			when others => segOut <= "1111111";
		end case;
	end process seleksi;
end arc_output;