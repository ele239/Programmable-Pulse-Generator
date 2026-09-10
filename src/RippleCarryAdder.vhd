library IEEE; 
    use IEEE.std_logic_1164.all;

entity RippleCarryAdder is
    generic(
        Nbit: positive := 8
    );
    port(
        a: in std_logic_vector (Nbit-1 downto 0);
        b: in std_logic_vector (Nbit-1 downto 0);
        c_in : in std_logic;
        s: out std_logic_vector (Nbit-1 downto 0);
        c_out: out std_logic
    );
end entity;

architecture rippleAdd of RippleCarryAdder is
component FullAdder
    port(
        a: in std_logic;
        b: in std_logic;
        c_in: in std_logic;
        s: out std_logic;
        c_out: out std_logic
        );
end component;

signal c_in_sig: std_logic_vector (6 downto 0);

begin
f_add: for i in 0 to Nbit-1 generate

    first_add: if (i = 0) generate
        i_add: FullAdder
        port map(
            a => a(i), 
            b => b(i),
            c_in => c_in,
            s => s(i),
            c_out => c_in_sig(i)
        );
    end generate;

   internal_add: if (i > 0 and i < Nbit-1) generate
        i_add: FullAdder
        port map(
            a => a(i), 
            b => b(i),
            c_in => c_in_sig(i-1),
            s => s(i),
            c_out => c_in_sig(i)
        );
    end generate;

    external_add: if (i = Nbit-1) generate
        i_add: FullAdder
        port map(
            a => a(i), 
            b => b(i),
            c_in => c_in_sig(i-1),
            s => s(i),
            c_out => c_out
        );
    end generate;
end generate;

end architecture;