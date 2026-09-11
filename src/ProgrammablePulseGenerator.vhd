library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgrammablePulseGenerator is 
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

architecture PPG of ProgrammablePulseGenerator is

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

    -- signal always connected to the output
    signal pulse_value: std_logic;

    -- signals at the output of the DFFs
    signal out_dff_len: std_logic_vector (Nbit-1 downto 0);
    signal out_dff_delay: std_logic_vector (Nbit-1 downto 0);

    -- signals to handle the multiplexer logic
    signal out_mux: std_logic_vector (Nbit-1 downto 0);
    signal iter_curr: std_logic_vector (Nbit-1 downto 0);
    signal iter_next: std_logic_vector (Nbit-1 downto 0);

    -- condition signals
    signal both_input_zero: std_logic; 
    signal transition_enabled: std_logic;
    signal next_value: std_logic_vector (Nbit-1 downto 0);

begin 
    -- component instances
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

    -- the transition_enabled signal identifies a transition high -> low or low -> high. In addition, it is set to 1 after the reset phase
    transition_enabled <= (nor iter_next) or (nor iter_curr);  
    
    -- both_input_zero indicates the condition in which both length and delay are set to zero: it is used to force the output to 0
    both_input_zero <= ((nor out_dff_len) and (nor out_dff_delay));
    
    -- depending on the value of the output, the next_value signal holds the parameter required for the following phase
    next_value <= out_dff_len when (pulse_value = '0') else out_dff_delay;
    
    -- when we are at a transition or after the reset phase and the parameter needed for the following transition is zero, out_mux is forced to 1 so the parameter is re-evaluated at every cycle
    -- otherwise, if we are at a transition, out_mux is initialized with the parameter of the phase that is about to begin
    -- the default behaviour is to take the output of the counter (iter_next)
    out_mux <= (0 => '1', others => '0') when ((or next_value) = '0' and transition_enabled = '1')
        else next_value when (transition_enabled = '1')
        else iter_next;

    pulse_update: process(clk, resetn)
    begin
        -- async active-low reset
        if(resetn = '0') then
            pulse_value <= '0';

        -- when we are at a transition and both inputs are set to 0, the pulse_value is forced to 0
        -- when we are at a transition high -> low and the delay parameter is different from zero, the pulse_value is forced to 0
        -- when we are at a transition low -> high and the length parameter is different from zero, the pulse_value is forced to 1
        -- in all the other cases the pulse_value keeps its value
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
        
    -- pulse_value is always directly connected with the output
    pulse <= pulse_value;
end architecture;