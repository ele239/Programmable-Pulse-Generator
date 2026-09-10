library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Programmable_Pulse_Generator is 
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

architecture pulse_generator of Programmable_Pulse_Generator is

    component DFF is
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
    end component;

    component DownCounter
        generic(
        N: positive := 8
        );
        port(
            data: in std_logic_vector (N-1 downto 0);
            diff: out std_logic_vector (N-1 downto 0)
        );
    end component;

    signal pulse_value: std_logic;

    signal out_dff_len: std_logic_vector (Nbit-1 downto 0);
    signal out_dff_delay: std_logic_vector (Nbit-1 downto 0);

    signal out_mux: std_logic_vector (Nbit-1 downto 0);

    signal iter_curr: std_logic_vector (Nbit-1 downto 0);
    signal iter_next: std_logic_vector (Nbit-1 downto 0);

    signal any_input_zero: std_logic; 
    signal both_input_zero: std_logic; 
    

    signal transition_enabled: std_logic;

begin 

    dff_len: DFF
        generic map(
            N => Nbit
        )
        port map(
            enablen => load_length,
            data => data,
            clk => clk,
            resetn => resetn,

            output => out_dff_len
        );

    dff_delay: DFF
        generic map(
            N => Nbit
        )
        port map(
            enablen => load_delay,
            data => data,
            clk => clk,
            resetn => resetn,

            output => out_dff_delay
        );

    dff_counter: DFF
        generic map(
            N => Nbit
        )
        port map(
            enablen => '0',
            data => out_mux,
            clk => clk,
            resetn => resetn,

            output => iter_curr
        );

    down_counter: DownCounter
        generic map(
            N => Nbit
        )
        port map(
            data => iter_curr,
            diff => iter_next
        );

    
    transition_enabled <= (nor iter_next) or (nor iter_curr); -- reset edge case
    any_input_zero <= ((nor out_dff_len) or (nor out_dff_delay));
    both_input_zero <= ((nor out_dff_len) and (nor out_dff_delay));
    
    out_mux <= (0 => '1', others => '0') when (any_input_zero = '1' and transition_enabled = '1')
        else out_dff_len when (transition_enabled = '1' and pulse_value = '0')
        else out_dff_delay when (transition_enabled = '1' and pulse_value = '1')
        else iter_next;

    pulse_update: process(clk, resetn)
    begin
        if(resetn = '0') then
            pulse_value <= '0';

        elsif rising_edge(clk) then

            if(transition_enabled = '1') then 
                if(both_input_zero = '1' or (pulse_value = '1' and (or out_dff_delay) = '1')) then
                    pulse_value <= '0';
                elsif (pulse_value = '0' and (or out_dff_len) = '1') then
                    pulse_value <= '1';
                end if;
            end if;
        end if;

    end process;
        
    pulse <= pulse_value;
end architecture;