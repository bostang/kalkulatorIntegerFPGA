-- modul toplevel
	-- blok yang menggabungkan semua komponen / blok ( top level entity)
	-- untuk menggambarkan datapath dari rangkaian kalkulator

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;

-- entitas
entity toplevel is
	port
	(   clocktop   : in std_logic; -- input clock
	    reset	   : in std_logic; -- FSM's reset
	    neg		   : out std_logic; -- LED yang akan menyala jika hasil perhitungan negatif
	    digOut 	   : out std_logic_vector(3 downto 0);
		segOut	   : out std_logic_vector(7 downto 0);
		switch	   : in std_logic; -- switch untuk berpindah state
		button 	   : in std_logic; -- button untuk mengirim 'U' ke termite
		rx 		   : in std_logic;
		tx 		   : out std_logic
    );
end toplevel;

-- arsitektur
architecture behavior of toplevel is
	component fsm is 
		port
		(		
			TOG_EN 	 : in std_logic; -- toggle untuk berpindah state
			clock, reset : in std_logic;
			loadx0	 : out std_logic; -- sinyal load untuk register x0_ASCII 
			loadx1	 : out std_logic; -- sinyal load untuk register x1_ASCII 
			loadx2	 : out std_logic;  -- sinyal load untuk register x2_ASCII		
			loady0	 : out std_logic; -- sinyal load untuk register y0_ASCII
			loady1	 : out std_logic;  -- sinyal load untuk register y1_ASCII
			loady2	 : out std_logic;  -- sinyal load untuk register y2_ASCII
			loadop	 : out std_logic;
			clr 	 : out std_logic;
			xload	 : out std_logic;
			opload 	 : out std_logic;
			yload 	 : out std_logic;
			mux_on 	 : out std_logic;
			out_on 	 : out std_logic
		); 
	end component;

	component interfaceUART is
		port
		(
			clk 			: in std_logic;
			rst_n 			: in std_logic;
			
				-- parallel part
			outToRegister	: out std_logic_vector(7 downto 0) ;
			button			: in std_logic;
				-- serial part
			rs232_rx 		: in std_logic;
			rs232_tx 		: out std_logic
		);
	end component;

	component mux is 
		port
		(
			mux_on: in std_logic; --penanda mux digunakan
			sel: in std_logic_vector (1 downto 0); -- selektor operasi
			mult, sub, add, div: in std_logic_vector(15 downto 0); -- hasil operasi komparasi, pengurangan, penjumlahan 
			answer: out std_logic_vector(15 downto 0) -- output selektor
		);
	end component;

	component reg12 is --register 12 bit untuk menyimpan operan
		port
		(
			clk, load, clr : in std_logic;
			D : in std_logic_vector(11 downto 0);
			Q : out std_logic_vector(11 downto 0) 
		);
	end component;

	component reg8 is
		port
		(
			REG_IN : in std_logic_vector(7 downto 0);
			LD,CLK : in std_logic;
			reset  : in std_logic;
			REG_OUT : out std_logic_vector(7 downto 0)
		);
	end component;

	component reg2 is --register 2 bit untuk menyimpan sinyal kontrol operator
		port
		(
			clk, load, clr : in std_logic;
			D : in std_logic_vector( 1 downto 0 );
			Q : out std_logic_vector( 1 downto 0 ) 
		);
	end component;

	component add is 
		port
		(
			x, y: in std_logic_vector(11 downto 0); 
			result: out std_logic_vector(15 downto 0) 
		);
	end component;

	component sub is 
		port
		(			
			x, y  : in std_logic_vector(11 downto 0);
			neg	  : out std_logic; -- penanda negatif
			result: out std_logic_vector(15 downto 0)
		); 
	end component;

	component mult is 
		port
		(
			x, y  : in std_logic_vector(11 downto 0);
			result: out std_logic_vector(15 downto 0)
		); 
	end component;

	component div is
		port
		(
			x,y    : in std_logic_vector(11 downto 0);
	        result : out std_logic_vector(15 downto 0)
		);
	end component;

	component output is
		port
		(
			clk : in std_logic;
			reset							: in std_logic;
			hasil1, hasil2, hasil3, hasil4	: in std_logic_vector(3 downto 0);
			out_on 							: in std_logic; 
			digOut 							: out std_logic_vector(3 downto 0);
			segOut							: out std_logic_vector(7 downto 0)
		); 
	end component;

	component modulo is
		port
		(
			clk		: in std_logic;
			input 	: in std_logic_vector(15 downto 0); -- input tahun switch
			hasil1	: out std_logic_vector(3 downto 0); -- input untuk operator
			hasil2	: out std_logic_vector(3 downto 0); -- input untuk operator		    
			hasil3	: out std_logic_vector(3 downto 0); -- input untuk operator
			hasil4	: out std_logic_vector(3 downto 0) -- input untuk operator
		);
	end component;

	component ASCII_to_binary is
		port
		(
			ASCII_in : in std_logic_vector(7 downto 0);
			binary_out : out std_logic_vector(3 downto 0)
		);
	end component;


	component ASCII_to_operator is
		port
		(
			op_ASCII : in std_logic_vector(7 downto 0); -- 8 bit input dalam bentuk ASCII
			optemp : out std_logic_vector(1 downto 0) -- sinyal keluaran
		);
	end component;

	component combineInput is
		port
		(
			dig2, dig1, dig0 : in std_logic_vector(3 downto 0);
			digOut     		 : out std_logic_vector(11 downto 0)
		);
	end component;

	signal x2_ASCII, x1_ASCII, x0_ASCII, y2_ASCII, y1_ASCII, y0_ASCII : std_logic_vector(7 downto 0);	
	signal op_ASCII : std_logic_vector(7 downto 0);
	signal x2, x1, x0, y2, y1, y0 : std_logic_vector(3 downto 0);
	signal x_temp, y_temp : std_logic_vector(11 downto 0);
	signal xload, yload, opload : std_logic;
	signal dig1, dig2, dig3, dig4 : std_logic_vector(3 downto 0);
	signal ans : std_logic_vector(15 downto 0);
	signal mux_on : std_logic; 
	signal out_on : std_logic;
	signal optemp : std_logic_vector(1 downto 0);
	signal op : std_logic_vector(1 downto 0);
	signal result_mult, result_sub, result_add, result_div : std_logic_vector(15 downto 0);
	signal x,y : std_logic_vector(11 downto 0);
	signal clr : std_logic;
	signal clock_FSM : std_logic;
  	signal clk_divider : unsigned(15 downto 0):=(others=>'0'); -- di-inisiasi dengan nol
	signal loady2, loady1, loady0, loadx2, loadx1, loadx0, loadop : std_logic;
	signal outTermite : std_logic_vector(7 downto 0);

		-- deskripsi sinyal:
	--  x2_ASCII, x1_ASCII, x0_ASCII, y2_ASCII, y1_ASCII, y0_ASCII : nilai ASCII yang diterima dari interfaceUART yang akan diolah menjadi angka pada ASCII_to_binary
	-- op_ASCII : nilai ASCII yang diterima dari interface UART yang akan menjadi sinyal selektor pada multiplexer
	-- dig1, dig2, dig3, dig4 : hasil perhitungan yang telah dipisahkan ke masing-masing digit 
		-- dari blok output separator dan akan diteruskan ke blok display
	-- ans : hasil perhitungan aritmatika yang diteruskan dari multiplexer ke modulo	
	-- op : sinyal untuk memilih operasi apa yang akan diteruskan pada multiplexer
	-- mux_on : sinyal untuk menentukan kapan multiplexer harus meneruskan outputnya
	-- result_mult, result_sub, result_add, result_div : hasil perhitungan aritmatika
		-- dari blok adder, subtractor, multiplier, dan divider
	-- x, y : sinyal bilangan 12 bit yang siap untuk diteruskan ke blok operasi aritmatika (add,sub,mult,div)
	-- optemp : sinyal keluaran ASCII to operator yang akan disimpan di register operator 
	-- xload, yload : sinyal load pada register untuk menyimpan nilai operand
	-- opload : sinyal load pada register untuk menyimpan operator
	-- clr : sinyal untuk reset nilai yang disimpan di register dan display
	-- x_temp, y_temp : angka 3 digit yang diterima dari combineInput dan akan disimpan pada register operand
	-- x2, x1, x0, y2, y1, y0 : sinyal keluaran ASCII_to_binary yang akan diteruskan ke combine input
	-- out_on : sinyal yang mengendalikan display
	-- outTermite : sinyal yang berasal dari interfaceUART yang akan diteruskan ke REG_ASCII_y2, REG_ASCII_y1, REG_ASCII_y0
		-- REG_ASCII_x2, REG_ASCII_x1, REG_ASCII_x0, REG_ASCII_operator
begin
			-- control path
		-- FSM
	fsm_controller : fsm
	port map
	(
		TOG_EN 	 => switch,
		clock    => clock_FSM,
		reset 	 => reset,
		loadx0	 => loadx0,
		loadx1	 => loadx1,
		loadx2	 => loadx2,
		loady0	 => loady0,
		loady1	 => loady1,
		loady2	 => loady2,
		loadop	 => loadop,
		clr 	 => clr,
		xload	 => xload,
		opload 	 => opload,
		yload 	 => yload,
		mux_on 	 => mux_on,
		out_on 	 => out_on
	);

			--Data path

	UART : interfaceUART
	port map
	(
		clk => clocktop,
		rst_n => reset,
		button => button,
		outToRegister => outTermite,
		rs232_rx => rx,
		rs232_tx => tx
	);

	REG_ASCII_y2: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loady2,
		CLK => clocktop,
		reset => clr,
		REG_OUT => y2_ASCII
	);

	REG_ASCII_y1: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loady1,
		CLK => clocktop,
		reset => clr,
		REG_OUT => y1_ASCII
	);

	REG_ASCII_y0: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loady0,
		CLK => clocktop,
		reset => clr,
		REG_OUT => y0_ASCII
	);

	REG_ASCII_x2: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loadx2,
		CLK => clocktop,
		reset => clr,
		REG_OUT => x2_ASCII
	);
	REG_ASCII_x1: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loadx1,
		CLK => clocktop,
		reset => clr,
		REG_OUT => x1_ASCII
	);

	REG_ASCII_x0: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loadx0,
		CLK => clocktop,
		reset => clr,
		REG_OUT => x0_ASCII
	);

	REG_ASCII_operator: reg8
	port map
	(
		REG_IN => outTermite,
		LD => loadop,
		CLK => clocktop,
		reset => clr,
		REG_OUT => op_ASCII
	);


	ASCII_to_binary_x2 : ASCII_to_binary
	port map
	(
		ASCII_in => x2_ASCII, 
		binary_out => x2
	);

	ASCII_to_binary_x1 : ASCII_to_binary
	port map
	(
		ASCII_in => x1_ASCII, 
		binary_out => x1
	);

	ASCII_to_binary_x0 : ASCII_to_binary
	port map
	(
		ASCII_in => x0_ASCII, 
		binary_out => x0
	);

	ASCII_to_binary_y2 : ASCII_to_binary
	port map
	(
		ASCII_in => y2_ASCII, 
		binary_out => y2
	);

	ASCII_to_binary_y1 : ASCII_to_binary
	port map
	(
		ASCII_in => y1_ASCII, 
		binary_out => y1
	);

	ASCII_to_binary_y0 : ASCII_to_binary
	port map
	(
		ASCII_in => y0_ASCII, 
		binary_out => y0
	);

	ASCII_to_operator_1 : ASCII_to_operator
	port map
	(
		op_ASCII => op_ASCII,
		optemp => optemp
	);
	x_combine : combineInput
	port map
	(
		dig2 => x2,
		dig1 => x1,
		dig0 => x0,
		digOut => x_temp
	);

	y_combine : combineInput
	port map
	(
		dig2 => y2,
		dig1 => y1,
		dig0 => y0,
		digOut => y_temp
	);

	REGA : reg12
	port map
	(		
		clk => clocktop,
		load => xload,
		clr => clr,
		D => x_temp,
		Q => x
	);

	REGB : reg12
	port map
	(		
		clk => clocktop,
		load => yload,
		clr => clr,
		D => y_temp,
		Q => y
	);

	operator_register : reg2
	port map
	(
		clk => clocktop,
		load => opload,
		clr => clr, 
		D => optemp,
		Q => op
	);

	adder	: add
	port map
	(
		x => x,
		y => y,
		result => result_add		
	);

	subtractor : sub
	port map
	(
		x => x,
		y => y,
		result => result_sub
	);

	multiplier	: mult
	port map
	(
		x => x,
		y => y,
		result => result_mult
	);

	divider	: div
	port map
	(
		x => x,
		y => y,
		result => result_div
	);

	multiplexer	: mux
	port map
	(
		mux_on => mux_on,
		sel    => op,
		mult   => result_mult,
		sub    => result_sub,
		add    => result_add,
		div    => result_div,
		answer => ans
	);

	outputseparator : modulo
	port map
	(
		clk => clocktop,	
		input => ans,
		hasil1 => dig1, -- satuan
		hasil2 => dig2,
		hasil3 => dig3,
		hasil4 => dig4 -- ribuan
	);

	display	: output
	port map
	(
		clk => clocktop,
		reset => clr,
		hasil1 => dig1, 
		hasil2 => dig2, 
		hasil3 => dig3, 
		hasil4 => dig4,
		out_on => out_on,				
		digOut => digOut,
		segOut => segOut
	);

-- menampilkan output ke 7-segment

	clockDivider : process(reset,clocktop)
		-- mendapatkan clock dengan frekuensi yang kita inginkan
		begin
		  if(reset='0') then -- reset = '0' berarti tombol reset ditekan
			clk_divider   <= (others=>'0');
		  elsif(rising_edge(clocktop)) then
			clk_divider   <= clk_divider + 1;
		  end if;
	end process clockDivider;

	--clk_out <= clk_divider(15);  -- f_out = 50 Mhz /(2^15)
	clock_FSM <= clk_divider(15); 

end behavior;
