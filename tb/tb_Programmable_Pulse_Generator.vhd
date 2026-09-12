library IEEE; 
use IEEE.std_logic_1164.all;

entity tb_Programmable_Pulse_Generator is
    generic(
        N: positive := 8; 
        CLK_PERIOD: TIME := 100 ns; 
        RESET_TIME: TIME := CLK_PERIOD
    );
end entity; 

architecture testbench of tb_Programmable_Pulse_Generator is 
    
    component ProgrammablePulseGenerator
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

    -- signal to end the simulation
    signal testing: boolean := true; 

    -- enable signals
    signal load_delay: std_logic := '1';
    signal load_length: std_logic := '1';

    -- input and output signals
    signal data: std_logic_vector (N-1 downto 0);
    signal pulse: std_logic;

begin
    prog_pulse_gen: ProgrammablePulseGenerator
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

         -- inputs have an offset of half a clock period
        stimuli: process
        begin
            
            report "TEST 1: reset test";
            load_length <= '0';
            load_delay <= '0'; 
            data <= x"02";
            wait for RESET_TIME;    

            
            report "TEST 2: pulse generation";
            resetn <= '1';
            load_length <= '0'; 
            load_delay <= '1';
            data <= x"03"; 
            wait for CLK_PERIOD;

            load_length <= '1';
            load_delay <= '0';
            data <= x"04";
            wait for CLK_PERIOD; 

            load_length <= '1';
            load_delay <= '1';
            wait for CLK_PERIOD*12; 

            
            report "TEST 3: null length parameter";
            load_length <= '0'; 
            load_delay <= '1'; 
            data <= x"00";
            wait for CLK_PERIOD;
            
            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*3; 
            
            load_length <= '0';
            load_delay <= '1'; 
            data <= x"02";   
            wait for CLK_PERIOD; 

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*4;

            
            report "TEST 4: null delay parameter";
            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"00";
            wait for CLK_PERIOD;
            
            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*3; 
            
            load_length <= '1';
            load_delay <= '0'; 
            data <= x"05";   
            wait for CLK_PERIOD; 

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*8;

            
            report "TEST 5: transparency test";
            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"01";
            wait for CLK_PERIOD; 

            data <= x"02";
            wait for CLK_PERIOD; 

            data <= x"03";
            wait for CLK_PERIOD*2;
            
            load_length <= '0'; 
            load_delay <= '1'; 
            data <= x"05";
            wait for CLK_PERIOD;
 
            data <= x"03";
            wait for CLK_PERIOD;
            
            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*5;

            
            report "TEST 6: both parameters null";
            load_length <= '0'; 
            load_delay <= '0'; 
            data <= x"00";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*2;


             report "TEST 7: restart order";
            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"03";   
            wait for CLK_PERIOD;

            load_length <= '0'; 
            load_delay <= '1'; 
            data <= x"04";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*6;

    
            report "TEST 8: simultaneous load";
            load_length <= '0'; 
            load_delay <= '0'; 
            data <= x"01";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*7;


            report "TEST 9: aynchronous reset";
            resetn <= '0';
            wait for CLK_PERIOD;

            load_length <= '0'; 
            load_delay <= '0'; 
            data <= x"03";   
            wait for CLK_PERIOD*2;

            resetn <= '1'; 
            wait for CLK_PERIOD*2;

            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"02";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';  
            wait for CLK_PERIOD*5;


            report "End of the simulation ...";
            testing <= false; 
            wait until rising_edge(clk);   
    end process; 
end architecture;