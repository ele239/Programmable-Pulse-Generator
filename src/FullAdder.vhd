library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
    port(
        a: in std_logic;
        b: in std_logic;
        c_in: in std_logic;
        s: out std_logic;
        c_out: out std_logic
    );
end entity;

architecture adder of FullAdder is
begin
    s <= a xor b xor c_in;
    c_out <= (a and b) or (c_in and (a xor b));
end architecture;