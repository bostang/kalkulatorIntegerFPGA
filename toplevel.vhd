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
	    s_opt	   : in std_logic_vector(1 downto 0); -- input untuk operator
	    neg		   : out std_logic; -- LED yang akan menyala jika hasil perhitungan negatif
	    digOut 	   : out std_logic_vector(3 downto 0);
		segOut	   : out std_logic_vector(7 downto 0)
    );
end toplevel;

-- arsitektur
architecture behavior of toplevel is
	component fsm is 
		port
		(		
			clock 			: in std_logic; -- input clock
		    reset			: in std_logic; -- FSM's reset
		    xload, opload, yload, mux_on, out_on, clear: out std_logic;
		    op 				: out std_logic_vector(1 downto 0) -- untuk memilih operator
		); 
	end component;

	component mux is 
		port
		(
			mux_on: in std_logic; --penanda mux digunakan
			sel: in std_logic_vector (1 downto 0); -- selektor operasi
			mult, sub, add, div: in std_logic_vector(15 downto 0); -- hasil operasi komparasi, pengurangan, penjumlahan 
			output: out std_logic_vector(15 downto 0) -- output selektor
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
			ASCII_in : std_logic_vector(7 downto 0);
			binary_out : std_logic_vector(3 downto 0)
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
	---signal o_clock : std_logic;

		-- deskripsi sinyal:
	--  x2_ASCII, x1_ASCII, x0_ASCII, y2_ASCII, y1_ASCII, y0_ASCII : nilai ASCII yang diterima dari interfaceUART yang akan diolah menjadi angka pada ASCII_to_binary
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
begin
			-- control path
		-- FSM
	fsm_controller : fsm
	port map
	(
		--- clock 	=>	o_clock,
		--- reset	=>	reset,
		--- clr 	=> clr,		
		--- xload	=> 	xload,
		--- opload 	=>	opload,
		--- yload 	=> 	yload,
		--- mux_on 	=> 	mux_on,
		--- out_on 	=>	out_on
	);

			--Data path

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
		output => ans
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
end behavior;
