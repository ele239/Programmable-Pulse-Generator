library IEEE; 
use IEEE.std_logic_1164.all;

entity tb_Programmable_Pulse_Generator
end entity; 

architecture testbench of tb_Programmable_Pulse_Generator is 
    
    constant N: positive := 8; 
    constant CLK_PERIOD: TIME := 100 ns; 
    constant RESET_TIME: TIME := 200 ns;

    component Programmable_Pulse_Generator
        generic(
            Nbit: positive := 8
        );
        port(
            load_delay: in std_logic;
            load_length: in std_logic;
            
            data: in std_logic_vector (Nbit-1 downto 0);
            
            resetn: in std_logic;
            clk: in std_logic;

            pulse: out std_logic
        );
    end component; 

    signal clk: std_logic := '0'; 
    signal resetn: std_logic := '0';

    signal testing: boolean := true; 

    signal load_delay: std_logic := '1';
    signal load_length: std_logic := '1';

    signal data: std_logic_vector (N-1 downto 0);
    signal pulse: std_logic;

begin
    prog_pulse_gen: Programmable_Pulse_Generator
        generic map(
            Nbit => N
        )
        port map(
            load_delay => load_delay,
            load_length => load_length,
            
            clk => clk,
            resetn => resetn, 

            data => data,
            pulse => pulse
        );

        clk <= not clk after CLK_PERIOD/2 when testing else '0';
        resetn <= '1' after RESET_TIME;

        stimuli: process(clk, resetn)
        begin

        end process;

end architecture;