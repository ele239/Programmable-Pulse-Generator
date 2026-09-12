library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PPG_Wrapper is
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
end entity;

architecture structural of PPG_Wrapper is

    component ProgrammablePulseGenerator is
        generic(
            Nbit: positive
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

    -- input registers
    signal load_delay_reg : std_logic;
    signal load_length_reg : std_logic;
    signal data_reg : std_logic_vector (Nbit-1 downto 0);
    signal resetn_reg : std_logic;

    -- output register
    signal pulse_reg : std_logic;

    -- output signal
    signal pulse_aux : std_logic;

begin

    pulse <= pulse_reg;

    PPG_core: ProgrammablePulseGenerator
        generic map(
            Nbit => Nbit
        )
        port map(
            load_delay => load_delay_reg,
            load_length => load_length_reg,
            data => data_reg,
            resetn => resetn_reg,
            clk => clk,
            pulse => pulse_aux
        );

    process(clk)
    begin
        if rising_edge(clk) then
            
            load_delay_reg <= load_delay;
            load_length_reg <= load_length;
            data_reg <= data;
            resetn_reg <= resetn;

            pulse_reg <= pulse_aux;
        end if;
    end process;

end architecture;