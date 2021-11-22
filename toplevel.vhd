-- modul toplevel
	-- blok yang menggabungkan semua komponen / blok ( top level entity)

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
	    PB		   : in std_logic; -- Enter button
	    PBeq	   : in std_logic; -- Equal button
	    s_input    : in std_logic_vector(3 downto 0); -- input tahun switch
	    s_opt	   : in std_logic_vector(1 downto 0); -- input untuk operator
	    a_7s, b_7s : out std_logic_vector(6 downto 0);	
	    neg		   : out std_logic;
	    dot		   : out std_logic
    );
end toplevel;

-- arsitektur
architecture behavior of toplevel is
	component fsm is 
		port
		(		
			clock 			: in std_logic; -- input clock
		    reset			: in std_logic; -- FSM's reset
		    PB				: in std_logic; -- Enter button
		    PBeq			: in std_logic; -- Equal button
		    s_input 		: in std_logic_vector(3 downto 0); -- input tahun switch
		    s_op			: in std_logic_vector(3 downto 0); -- input untuk operator
		    xload, xload2, xdigit2, opload, yload, yload2, ydigit2, mux_on, out_on, outx1, outy1, outx2, outy2, clear: OUT std_logic
		); 
	end component;

	component clockdiv is 
		port
		(
			CLK: in std_logic;
			DIVOUT: buffer std_logic
		);
	end component;

	component mux is 
		port
		(
			mux_on: in std_logic; --penanda mux digunakan
			sel: in std_logic_vector (3 downto 0); -- selektor operasi
			mult, sub, add: in std_logic_vector(7 downto 0); -- hasil operasi komparasi, pengurangan, penjumlahan 
			output: out std_logic_vector(7 downto 0) -- output selektor
		);
	end component;

	component reg is --register 1 digit
		port
		(
			clk, load, clr: in std_logic;
			i_1: in std_logic_vector( 3 downto 0 );
			o_1: out std_logic_vector( 3 downto 0 ) 
		);
	end component;

	component reg2 is --register 2 digit
		port
		(
			rst,clr, clk, load2, digit2: in std_logic;
			i_1, i_2: in std_logic_vector( 3 downto 0 );
			o_2: out std_logic_vector( 7 downto 0 ) 
		);
	end component;

	component add is 
		port
		(
			xdigit2, ydigit2: in std_logic; -- input jumlah digit
			x1, y1: in std_logic_vector(3 downto 0); -- input angka, dari register
			x2, y2: in std_logic_vector(7 downto 0); -- input angka, dari register
			output: out std_logic_vector(7 downto 0) -- output hasil operasi
		);
	end component;

	component sub is 
		port
		(
			xdigit2, ydigit2: in std_logic; -- input jumlah digit
			x1, y1: in std_logic_vector(3 downto 0); -- input angka, dari register 1
			x2, y2: in std_logic_vector(7 downto 0); -- input angka, dari register 2
			neg	  : buffer std_logic; --penanda negatif
			output: out std_logic_vector(7 downto 0) -- output hasil operasi
		); 
	end component;

	component mult is 
		port
		(
			xdigit2, ydigit2: in std_logic; -- input jumlah digit
			x1, y1: in std_logic_vector(3 downto 0); -- input angka, dari register
			x2, y2: in std_logic_vector(7 downto 0); -- input angka, dari register
			output: out std_logic_vector(7 downto 0) -- output hasil operasi
		); 
	end component;

	component output is
		port
		(
			reset									: in std_logic;
			hasil1,hasil2, s_input, xi, yi			: in std_logic_vector(3 downto 0); -- input angka, dari register 2
			out_on, outx1, outx2, outy1, outy2	 	: in std_logic; 
			a_7s, b_7s								: out std_logic_vector(6 downto 0) -- output hasil operasi
		); 
	end component;

	component modulo is
	port(
			clk		: in std_logic;
		    input 	: in std_logic_vector(7 downto 0); -- input tahun switch
		    output1	: out std_logic_vector(3 downto 0); -- input untuk operator
		    output2	: out std_logic_vector(3 downto 0) -- input untuk operator
	    );
	end component;

	signal xload, xload2, xdigit2, opload, yload, yload2, ydigit2, mux_on, out_on, clear, o_clock, outx1, outx2, outy1, outy2: std_logic;
	signal resultadd, resultsub, resultmult: std_logic_vector (7 downto 0);
	signal xo_2, yo_2, ans: std_logic_vector(7 downto 0);
	signal xo_1, yo_1, op, digit2, digit1 : std_logic_vector (3 downto 0);
begin
		-- clock divider
	CLOCK1 : clockdiv
		port map
		(
			CLK 	=> clocktop,
			DIVOUT 	=> o_clock
		);
 
		-- FSM
	fsm_controller : fsm
	port map
	(
		clock 	=>	o_clock,
		reset	=>	reset,		
		PB		=>	PB,		
		PBeq	=>	PBeq,
		s_input =>	s_input,
		s_op (1 downto 0)	=> 	s_opt,
		s_op (3 downto 2) 	=> "00",
		xload	=> 	xload,
		xload2  =>	xload2,
		xdigit2 => xdigit2,
		opload 	=>	opload,
		yload 	=> 	yload,
		yload2 	=>	yload2,
		ydigit2 =>	ydigit2,
		mux_on 	=> 	mux_on,
		out_on 	=>	out_on,
		outx1	=>	outx1,
		outx2	=>	outx2,
		outy1	=>	outy1,
		outy2	=>	outy2,
		clear		=> 	clear
	);

		--Datapath
	op11_register : reg
	port map
	(
		clk  =>	clocktop,
		clr	 =>	clear,
		load =>	xload,
		i_1	 => s_input,
		o_1	 =>	xo_1			
	);	

	op12_register : reg2
	port map
	(
		rst		=> reset,
		clr		=> clear,
		clk 	=> clocktop,
		load2	=> xload2,
		i_1		=> xo_1,
		i_2		=> s_input,
		digit2	=> xdigit2,
		o_2		=> xo_2			
	);	

	op21_register : reg
	port map
	(
		clk 	=>	clocktop,
		clr		=> 	clear,
		load	=>	yload,
		i_1		=> 	s_input,
		o_1		=>	yo_1			
	);

	op22_register : reg2
	port map
	(
		rst		=>	reset,
		clr		=> 	clear,
		clk 	=>	clocktop,
		load2	=>	yload2,
		i_1		=> 	yo_1,
		i_2		=> 	s_input,
		digit2	=>	ydigit2,
		o_2		=>	yo_2			
	);

	operator_register : reg
	port map
	(
		clk 	=>	clocktop,
		clr		=> 	clear,
		load	=>	opload,
		i_1	(1 downto 0) => s_opt,
		i_1 (3 downto 2) => "00",
		o_1		=>	op			
	);

	adder	: add
	port map
	(
		xdigit2	=>	xdigit2,
		ydigit2	=>	ydigit2,
		x1		=>	xo_1,
		y1		=> 	yo_1,
		x2 		=>	xo_2,
		y2		=>	yo_2,
		output	=> 	resultadd			
	);

	subtractor : sub
	port map
	(
		xdigit2	=>	xdigit2,
		ydigit2	=>	ydigit2,
		x1		=>	xo_1,
		y1		=> 	yo_1,
		x2 		=>	xo_2,
		y2		=>	yo_2,
		output	=> 	resultsub,
		neg		=>	neg			
	);

	multiplier	: mult
	port map
	(
		xdigit2	=>	xdigit2,
		ydigit2	=>	ydigit2,
		x1		=>	xo_1,
		y1		=> 	yo_1,
		x2 		=>	xo_2,
		y2		=>	yo_2,
		output	=> 	resultmult			
	);

	multiplexer	: mux
	port map
	(
		mux_on	=>	mux_on,
		sel		=>	op,
		mult	=>	resultmult,
		sub		=> 	resultsub,
		add 	=>	resultadd,
		output	=>	ans			
	);

	outputgenerator : modulo
	port map
	(
		clk		=>	clocktop,
		input	=> 	ans,
		output1	=> 	digit1,
		output2	=>	digit2
	);

	display	: output
	port map
	(
		reset	=>  reset,
		hasil1	=>	digit1,
		hasil2	=>  digit2,
		s_input	=>  s_input,
		xi		=>	xo_1,
		yi		=>	yo_1,
		out_on	=>	out_on,
		outx1	=>	outx1,
		outx2	=>	outx2,
		outy1	=>	outy1,
		outy2	=>	outy2,
		a_7s	=>	a_7s,
		b_7s	=>	b_7s			
	);
	
	dot <= '1';
end behavior;