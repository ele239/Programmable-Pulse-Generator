library IEEE; 
use IEEE.std_logic_1164.all;

entity DownCounter is 
    generic(
        N: positive := 8
    );
    port(
        data: in std_logic_vector (N-1 downto 0);

        diff: out std_logic_vector (N-1 downto 0)
    );
end entity;

architecture counter of DownCounter is

    component RippleCarryAdder
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
    end component;

    begin
        rca: RippleCarryAdder
            generic map(
                Nbit => N
            )
            port map(
                a => data,
                b => (others => '1'),
                c_in => '0',
                c_out => open,
                s => diff
            );

end architecture;