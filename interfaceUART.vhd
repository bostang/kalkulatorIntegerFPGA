-- modul interfaceUART
	-- blok untuk menerima data input dari termite dengan menggunakan protokol UART yang akan diteruskan
	-- ke REG_ASCII_y2, REG_ASCII_y1, REG_ASCII_y0
	-- REG_ASCII_x2, REG_ASCII_x1, REG_ASCII_x0, REG_ASCII_operator


-- library
library ieee;
use ieee.std_logic_1164.all;

-- entitas
entity interfaceUART is
	port
	(
		clk 			: in std_logic;
		rst_n 			: in std_logic;
		
			-- parallel part
		button 			: in std_logic; -- tombol untuk mengirimkan data ke termite
		outToTermite 	: in std_logic_vector(7 downto 0); -- data yang ingin dikirimkan ke termite
		outToRegister	: out std_logic_vector(7 downto 0);
		
			-- serial part
		rs232_rx 		: in std_logic;
		rs232_tx 		: out std_logic;

			-- untuk perpindahan state dengan mendeteksi start bit
		trans : out std_logic
	);
end entity;

-- arsitektur
architecture RTL of interfaceUART is

	component my_uart_top is
	port
	(
		clk 		 : in std_logic;
		rst_n 		 : in std_logic;
		send 		 : in std_logic;
		send_data	 : in std_logic_vector(7 downto 0); -- dari FPGA ke PC
		receive 	 : out std_logic;
		receive_data : out std_logic_vector(7 downto 0); -- dari PC[termite] ke FPGA
		rs232_rx 	 : in std_logic;
		rs232_tx 	 : out std_logic
	);
	end component;
	
	signal send_data,receive_data	: std_logic_vector(7 downto 0);
	signal receive					: std_logic;
	signal receive_c				: std_logic;

	signal temp_trans : std_logic := '1';
begin

	UART: my_uart_top 
	port map
	(
		clk 		=> clk,
		rst_n 		=> rst_n,
		send 		=> button,
		send_data	=> send_data,
		receive 	=> receive,
		receive_data=> receive_data,
		rs232_rx 	=> rs232_rx,
		rs232_tx 	=> rs232_tx
	);

			-- sisi transmitter ( menerima hasil perhitungan dan menampilkan ke termite )

	kirimDatakeTermite : process(clk)
	begin
		--send_data <= "01010101"; -- dalam desimal : 85 --> dalam ASCII : U
		send_data <= outToTermite;
	end process kirimDatakeTermite;
	
			-- sisi receiver ( mengirim dari termite ke 7-segment )
	kirimDatake7Seg : process(clk)
		-- jika data sudah sukses diterima, akan dikirim ke register x2, x1, x0, y2, y1, y0, op
	begin

		if ((clk = '1') and clk'event) then  -- ekuivalen dengan 'if rising_edge(clk)'
			receive_c <= receive;
			if ((receive = '0') and (receive_c = '1')) then
				outToRegister <= receive_data;

					-- mekanisme reset agar temp_trans kembali ke '1' -> agar behaviornya predictable
				if (rst_n = '0') then
					temp_trans <= '1';
				else
					temp_trans <= not temp_trans;
				end if;
				trans <= temp_trans;

			end if;
		end if;
	end process kirimDatake7Seg;
end architecture;
