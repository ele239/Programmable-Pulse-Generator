library IEEE; 
use IEEE.std_logic_1164.all;

entity tb_Programmable_Pulse_Generator is
    generic(
        N: positive := 8; 
        CLK_PERIOD: TIME := 100 ns; 
        RESET_TIME: TIME := CLK_PERIOD;
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

         -- inputs have an offset of half a clock
        stimuli: process
        begin
            
            -- TEST 1: reset
            report "TEST 1: reset";
            load_length <= '0';
            load_delay <= '0'; 
            data <= x"02";
            wait for RESET_TIME;    

            -- inseriamo il valore di length e parte la generazione dell'onda - comportamento canonico
            report "CASO 2: programmazione length e avvio";
            resetn <= '1';
            load_length <= '0'; 
            load_delay <= '1';
            data <= x"03"; 
            wait for CLK_PERIOD;

            -- specifico anche delay
            load_length <= '1';
            load_delay <= '0';
            data <= x"04";
            wait for CLK_PERIOD; 

            load_length <= '1';
            load_delay <= '1';
            wait for CLK_PERIOD*12; 

            -- metto length a 0, vedo che l'uscita mi viene mantenuta a 0 e l'impulso ccontinua un clock dopo che specifico il nuovo valore di len 
            report "CASO 3: programmazione limite durata impulso";
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

            -- metto delay a 0, vedo che l'uscita mi viene mantenuta a 1 e l'impulso ccontinua un clock dopo che specifico il nuovo valore di delay 
            report "CASO 3: programmazione limite durata impulso";
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

            -- cambiamo più volte il valore e vediamo che viene campionato solo alla transizione
            report "CASO ";
            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"01";
            wait for CLK_PERIOD; 

            data <= x"02";
            wait for CLK_PERIOD; 

            data <= x"03";
            wait for CLK_PERIOD;
            
            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*7; 

            -- entrambi settati a 0 (quando il fronte è alto così devo vedere che va a 0)
            report "CASO ";
            load_length <= '0'; 
            load_delay <= '0'; 
            data <= x"00";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*2;

            -- adesso porto delay a 3
            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"03";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD;

            load_length <= '0'; 
            load_delay <= '1'; 
            data <= x"03";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*5;

            -- generazione onda quadra
            report "CASO ";
            load_length <= '0'; 
            load_delay <= '0'; 
            data <= x"04";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';
            wait for CLK_PERIOD*10;

            -- inseriamo reset
            report "CASO";
            resetn <= '0';
            wait for CLK_PERIOD;

            load_length <= '0'; 
            load_delay <= '0'; 
            data <= x"03";   
            wait for CLK_PERIOD*2;

            -- ripartenza dopo il reset
            resetn <= '1'; 
            wait for CLK_PERIOD*2;

            load_length <= '1'; 
            load_delay <= '0'; 
            data <= x"02";   
            wait for CLK_PERIOD;

            load_length <= '1'; 
            load_delay <= '1';  
            wait for CLK_PERIOD*5;

            report "Simulation end ...";
            testing <= false; 
            wait until rising_edge(clk);   
    end process; 
end architecture;