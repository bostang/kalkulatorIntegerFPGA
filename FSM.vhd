-- FSM
	-- FSM versi awal untuk rangkaian kalkulator yang menerima menggunakan UART 
	-- meskipun input diterima melalui UART,
	--  pergantian state pada FSM masih menggunakan switch

-- library
library ieee;
use ieee.std_logic_1164.all;

-- entitas
entity FSM is
	port
	(
		TOG_EN 	 : in std_logic; -- toggle untuk berpindah state
		clock, reset : in std_logic;
		loadx0	 : out std_logic; -- sinyal load untuk register x0_ASCII 
		loadx1	 : out std_logic; -- sinyal load untuk register x1_ASCII 
		loadx2	 : out std_logic; -- sinyal load untuk register x2_ASCII		
		loady0	 : out std_logic; -- sinyal load untuk register y0_ASCII
		loady1	 : out std_logic; -- sinyal load untuk register y1_ASCII
		loady2	 : out std_logic; -- sinyal load untuk register y2_ASCII
		loadop	 : out std_logic;
		clr 	 : out std_logic;
		xload	 : out std_logic;
		opload 	 : out std_logic;
		yload 	 : out std_logic;
		mux_on 	 : out std_logic;
		out_on 	 : out std_logic
	);
end FSM;

-- arsitektur
architecture arc_FSM_sc1 of FSM is

		-- mendefinisikan tipe bentukan : state_type
	type state_type is (STA, STB, STC, STD, STE, STF, STG); 
	signal PS, NS : state_type; -- PS : present state, NS : next state
begin
	sync_proc : process (clock, NS, reset)
	begin
		if (reset = '0') then -- asynchronous input clear
			PS <= STA;
		elsif (rising_edge(clock)) then
			PS <= NS;
		end if;
	end process sync_proc;

	comb_proc : process(PS, TOG_EN)
	begin
			-- initial condition
		loadx0 <= '0';
		loadx1 <= '0';
		loadx2 <= '0';
		loady0 <= '0';
		loady1 <= '0';
		loady2 <= '0';
		loadop <= '0';
		case PS is 
			when STA => -- ketika present state adalah state 0
				loadx0 <= '0';
				loadx1 <= '0';
				loadx2 <= '1';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';
				if (TOG_EN = '1') then NS <= STB;
				else NS <= STA;
				end if;
			when STB =>
				loadx0 <= '0';
				loadx1 <= '1';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';			
				if (TOG_EN = '0') then NS <= STC;
				else NS <= STB;
				end if;
			when STC =>				
				loadx0 <= '1';
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';				
				if (TOG_EN = '1') then NS <= STD;
				else NS <= STC;
				end if;
			when STD =>				
				loadx0 <= '0';
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '1';
				loadop <= '0';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';			
				if (TOG_EN = '0') then NS <= STE;
				else NS <= STD;
				end if;
			when STE =>				
				loadx0 <= '0';
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '1';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';			
				if (TOG_EN = '1') then NS <= STF;
				else NS <= STE;
				end if;
			when STF =>				
				loadx0 <= '0';
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '1';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';
				if (TOG_EN = '0') then NS <= STF;
				else NS <= STG;
				end if;
			when STG =>				
				loadx0 <= '0';
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '1';
				clr 	<= '0'; -- clr = '0' -> tombol reset ditekan
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';			
				if (TOG_EN = '1') then NS <= STH;
				else NS <= STG;
				end if;

			when STH =>		-- mengonversi ke ASCII, menggabungkan input, dan menyimpan operan ke register X dan Y,	
				loadx0 <= '0'; -- serta menyimpan operator
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '1'; -- clr = '1' -> register dan display TIDAK di-reset
				xload	<= '1';
				opload 	<= '1';
				yload 	<= '1';
				mux_on 	<= '0';
				out_on 	<= '0';
				op 		<= '0';
				if (TOG_EN = '0') then NS <= STI;
				else NS <= STH;
				end if;

				when STI =>		-- mengonversi ke ASCII, menggabungkan input, dan menyimpan operan ke register X dan Y,	
				loadx0 <= '0'; -- serta menyimpan operator
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '1'; -- clr = '1' -> register dan display TIDAK di-reset
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '1';
				out_on 	<= '1';
				NS <= STI;
	
			when others =>
				loadx0 <= '0';
				loadx1 <= '0';
				loadx2 <= '0';
				loady0 <= '0';
				loady1 <= '0';
				loady2 <= '0';
				loadop <= '0';
				clr 	<= '0'; -- clr = '1' -> register dan display TIDAK di-reset
				xload	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				mux_on 	<= '0';
				out_on 	<= '0';
				NS <= STA;
		end case;
	end process comb_proc;
end arc_FSM_sc1;