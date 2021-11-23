LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
	port(
		clk, run: in std_logic;
		x		: in std_logic_vector (7 downto 0);
		y		: in std_logic_vector (4 downto 0);
		output	: out std_logic_vector (7 downto 0);
		sisa	: out std_logic_vector (3 downto 0));
end divider;

architecture divider_arc of divider is
	SIGNAL tempx	: std_logic_vector (6 downto 0);
	SIGNAL tempy	: std_logic_vector (3 downto 0);
	SIGNAL hasil	: std_logic_vector (7 downto 0) := "00000000";

begin
	output <= (x(7) XOR y(4)) & hasil(6 downto 0);
	
	process (clk, run)
	begin
		if (run='0') then
			tempx <= x(6 downto 0);
			tempy <= y(3 downto 0);
			hasil <= "00000000";
		elsif (clk'EVENT) and (clk='1') then
			if (tempy(3 downto 0) = "0000") then
				hasil <= "00000000";
			elsif (unsigned(tempx(6 downto 0)) >= unsigned(tempy(3 downto 0))) then
				tempx <= unsigned(tempx(6 downto 0)) - unsigned(tempy(3 downto 0));
				hasil <= hasil + '1';
			end if;
		end if;
		sisa <= tempx(3 downto 0);
	end process;
end divider_arc;