library IEEE; 
use IEEE.std_logic_1164.all;

entity DFF is 
    generic(
        N: positive := 8
    );
    port(
        enablen: in std_logic;
        data: in std_logic_vector (N-1 downto 0);
        clk: in std_logic;
        resetn: in std_logic;

        output: out std_logic_vector (N-1 downto 0)
    );
end entity;

architecture dff of DFF is
    
begin
    behaviour: process(clk, resetn)
    begin
        if(resetn = '0') then
            output <= (others => '0');
        elsif rising_edge(clk) then
            if(enablen = '0') then
                output <= data; 
            end if;
        end if;
    end process;
end architecture;