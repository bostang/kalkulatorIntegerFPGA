-- modul divider
    -- Blok yang menghitung hasil pembagian dari dua input.
    -- Blok ini menerima input dua buah  bit logic vector panjang 12
    -- dan mengembalikan hasil operasi berupa bit logic vector panjang 16

-- library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- entitas
entity divider is
    port
    (
        x,y    : in std_logic_vector(11 downto 0);
        result : out std_logic_vector(15 downto 0)
    );
end divider;

-- arsitektur
architecture arc_divider of divider is
begin
    result <= std_logic_vector(to_unsigned(to_integer(unsigned(x) / unsigned(y)),16));
end arc_divider;
