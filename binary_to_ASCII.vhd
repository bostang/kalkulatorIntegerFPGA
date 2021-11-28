-- modul binary to ASCII converter
	-- mengubah output operasi aritmatika berupa binary menjadi ASCII
	-- agar bisa dikirim ke termite

-- library
library ieee;
use ieee.std_logic_1164.all;

-- entitas
entity binary_to_ASCII is
	port
	(
		ASCII_out : out std_logic_vector(7 downto 0);
		binary_in : in std_logic_vector(3 downto 0)
	);
end entity;

-- arsitektur
architecture arc_binary_to_ASCII of binary_to_ASCII is
begin
	process(binary_in)
	begin
		if (binary_in = "0000") then
			ASCII_out <= "00110000"; -- 0x30 ASCII -> angka 0
		elsif (binary_in = "0001") then
			ASCII_out <= "00110001";
		elsif (binary_in = "0010") then
			ASCII_out <= "00110010"; -- 0x32 ASCII -> angka 2
		elsif (binary_in = "0011") then
			ASCII_out <= "00110011";
		elsif (binary_in = "0100") then
			ASCII_out <= "00110100"; -- 0x34 ASCII -> angka 4
		elsif (binary_in = "0101") then
			ASCII_out <= "00110101";
		elsif (binary_in = "0110") then
			ASCII_out <= "00110110"; -- 0x36 ASCII -> angka 6
		elsif (binary_in = "0111") then
			ASCII_out <= "00110111";
		elsif (binary_in = "1000") then
			ASCII_out <= "00111000"; -- 0x38 ASCII -> angka 8
		elsif (binary_in = "1001") then
			ASCII_out <= "00111001";
		end if;
	end process;
end arc_binary_to_ASCII;