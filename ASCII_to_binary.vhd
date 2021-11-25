-- modul ASCII to binary converter
	-- mengubah input dari termite berupa ASCII menjadi binary angka sehingga bisa dioperasikan

-- library
library ieee;
use ieee.std_logic_1164.all;

-- entitas
entity ASCII_to_binary is
	port
	(
		ASCII_in : in std_logic_vector(7 downto 0);
		binary_out : out std_logic_vector(3 downto 0)
	);
end entity;

-- arsitektur
architecture arc_ASCII_to_binary of ASCII_to_binary is
begin
	process(ASCII_in)
	begin
		if (ASCII_in = "00110000") then -- 0
			binary_out <= "0000";
		elsif (ASCII_in = "00110001") then
			binary_out <= "0001";
		elsif (ASCII_in = "00110010") then -- 2
			binary_out <= "0010";
		elsif (ASCII_in = "00110011") then
			binary_out <= "0011";
		elsif (ASCII_in = "00110100") then -- 4
			binary_out <= "0100";
		elsif (ASCII_in = "00110101") then
			binary_out <= "0101";
		elsif (ASCII_in = "00110110") then -- 6
			binary_out <= "0110";
		elsif (ASCII_in = "00110111") then 
			binary_out <= "0111";
		elsif (ASCII_in = "00111000") then -- 8
			binary_out <= "1000";
		elsif (ASCII_in = "00111001") then -- 9
			binary_out <= "1001";
		else
			binary_out <= "0000";
		end if;
	end process;
end arc_ASCII_to_binary;
