-- modul fsm
	-- Blok yang mengontrol state pada sistem. ( FSM Moore )
	-- Pada setiap statenya, terdapat sinyal-sinyal 
	-- yang mengatur kerja dari masing-masing blok pada proyek

-- library
library  ieee; 
use  ieee.std_logic_1164.all; 
use  ieee.std_logic_arith.all; 
use  ieee.std_logic_unsigned.all;

-- entitas 
entity fsm  is 
	port
	(
	    clock 			: in std_logic; -- input clock
	    reset			: in std_logic; -- FSM's reset
	    PB				: in std_logic; -- Enter button
	    PBeq			: in std_logic; -- Equal button
	    s_input 		: in std_logic_vector(3 downto 0); -- input tahun switch
	    s_op			: in std_logic_vector(3 downto 0); -- input untuk operator
	    xload, xload2,  opload, yload, yload2, ydigit2, mux_on, out_on, outx1, outy1, outx2, outy2, clear: out std_logic;
	    xdigit2 		: buffer std_logic
	); 
			-- deskripsi :
--	    bcd : out std_logic_vector(6 downto 0));
--	   			xload 	: load  OP1 first digit to register1;
--				xload2 	: load  OP1 second digit register1
--				xdigit2 : signal 2 digit input op1
--				opload 	: load  operator to op register
--				yload 	: load  OP2 first digit register2
--				yload2	: load  OP2 second digit register2
--				ydigit2 : signal 2 digit input op1
--				mux_on 	: turn on the mux 
--				outreg 	: load  ouput to register
--				output 	: generating output
--				clear 	: clear data, restarting count
end fsm; 

-- arsitektur
architecture behavioral of fsm  is 
-- State and counter signal
type state_type is (A, B, C, D, E, F, G, H, I, J);
	-- deskripsi state :
		--A: inital State
		--B: OP1 first digit
		--C: OP1 second digit
		--D: Operator
		--E: OP2 first digit
		--F: OP2 second digit
		--G: Result
signal PS, NS: state_type; -- present state dan next state
begin 

	sync_proc : process(clock, reset, PS)
	begin 
		if reset = '1' then
			PS <= A;
		elsif (clock'event and clock = '1') then
			PS <= NS;
		end if;
	end process sync_proc;

	comb_proc : process(PS, PB, s_input, s_op, PBEq)
	begin
		case PS is
			when A => --initial State
					-- output
				xload 	<= '0';
				xload2	<= '0';
				xdigit2	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '1';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '0';
				outy2	<= '0';
					-- next-state 
				if PB = '0' then --regis angka 1
					clear <= '0'; 
					NS 	<= B;
				else
					NS <= A;
				end if; 

			when B => --OP1 first digit
					-- output 
				xload 	<= '1';
				xload2	<= '0';
				xdigit2	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '1';
				outx2	<= '0';
				outy1	<= '0';
				outy2	<= '0';	
					-- next state
				if PB = '0' then
					NS <= C;
				else
					NS <= B;
				end if;

			when C => --OP1 second digit
					-- output
				xload 	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '1';
				outy1	<= '0';
				outy2	<= '0';
					-- next-state
				if PB = '0'  then 
					NS <= G;
					xload2	<= '1';
					xdigit2	<= '1';
					outx2	<= '1';
				elsif PB = '1' then
					if s_op = "0010" or s_op = "0011" or s_op = "0001" then
						NS	<= D;
						xload2	<= '0';
						xdigit2	<= '0';
						outx2	<= '0';
					else
						xload2	<= '1';
						xdigit2	<= '1';
						outx2	<= '1';
						NS	<= C;
					end if;
				else
					xload2	<= '1';
					xdigit2	<= '1';
					outx2	<= '0';
					NS <= C;
				end if;

			when D => -- memilih operator
					-- output
				xload 	<= '0';
				xload2	<= '0';
				xdigit2 <= '0';
				opload 	<= '1';
				yload 	<= '0';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '0';
				outy2	<= '0';
					-- next-state
				if PB = '0' and ( s_op = "0010" or s_op = "0011" or s_op = "0001") then 
					NS <= E;
				else 
					NS <= D;
				end if;

			when E => --  Transisi (to OP2 second digit / to output)
					-- output
				xload 	<= '0';
				xload2	<= '0';
				xdigit2 <= '0';
				opload 	<= '0';
				yload 	<= '1';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '1';
				outy2	<= '0';
					-- next-state
				if PBEq = '0' then
					mux_on <= '1';
					NS <= J;
				elsif PB = '0' then
					NS <= F;
				else
					NS <= E;
				end if;	

			when F => -- OP2 second digit
					-- output
				xload 	<= '0';
				xload2	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				yload2	<= '1';
				ydigit2	<= '1';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '1';
				outy2	<= '1';
					-- next-state
				if PBEq = '0' then
					mux_on <= '1';
					NS <= J;
				else
					NS <= F;
				end if;

			when G => --  Operator
					-- output
				xload 	<= '0';
				xload2	<= '0';
				xdigit2 <= '1';
				opload 	<= '1';
				yload 	<= '0';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '0';
				outy2	<= '0';
					-- next-state
				if PB = '0' and ( s_op = "0010" or s_op = "0011" or s_op = "0001") then 
					NS <= H;
				else 
					NS <= G;
				end if;

			when H => -- OP2 first digit
					-- output
				xload 	<= '0';
				xload2	<= '0';
				xdigit2	<= '1';
				opload 	<= '0';
				yload 	<= '1';
				yload2	<= '0';
				ydigit2	<= '0';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '1';
				outy2	<= '0';
					-- next-state
				if PBEq = '0' then
					mux_on <= '1';
					NS <= J;
				elsif PB = '0' then
					NS <= I;
				else
					NS <= H;
				end if;

			when I => -- OP2 second digit
					-- output
				xload 	<= '0';
				xload2	<= '0';
				xdigit2	<= '1';
				opload 	<= '0';
				yload 	<= '0';
				yload2	<= '1';
				ydigit2	<= '1';
				mux_on 	<= '0';
				out_on	<= '0';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '1';
				outy2	<= '1';
					-- next-state
				if PBEq = '0' then
					mux_on <= '1';
					NS <= J;
				else
					NS <= I;
				end if;		

			when J => --Result 
					-- output
				xload 	<= '0';
				xload2	<= '0';
				opload 	<= '0';
				yload 	<= '0';
				yload2	<= '0';
				mux_on 	<= '1';
				out_on	<= '1';
				clear 	<= '0';
				outx1	<= '0';
				outx2	<= '0';
				outy1	<= '0';
				outy2	<= '0';
					-- next-state
				if PB = '0' then -- clear data
					clear <= '1';
					NS <= A;
				else 
					NS <= J;
				end if;
		end case;
	end process comb_proc;
end behavioral;