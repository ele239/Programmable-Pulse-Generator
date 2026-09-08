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

    type state_t is (IDLE, PULSE_HIGH, PULSE_LOW);
    signal state : state_t := IDLE;

    signal out_dff_len: std_logic_vector (Nbit-1 downto 0) := (others => '0');
    signal out_dff_delay: std_logic_vector (Nbit-1 downto 0) := (others => '0');
    signal iter_left: integer range 0 to 2**Nbit - 1:= 0;

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

    behaviour: process(clk, resetn)
        
    begin
        if(resetn = '0') then
            iter_left <= 0;
            state <= IDLE;
        
        elsif (rising_edge(clk)) then 

            case state is 

                when IDLE =>
                    if(unsigned(out_dff_len) /= 0 and unsigned(out_dff_delay) /= 0) then
                        state <= PULSE_HIGH;
                        iter_left <= to_integer(unsigned(out_dff_len)) - 1;
                    end if;

                -- caso uscita 1 e variabile a 0 allora devo leggere da dff_delay
                when PULSE_HIGH => 
                    if (iter_left = 0) then 
                        if(unsigned(out_dff_delay) = 0) then  
                            state <= IDLE;
                        else
                            iter_left <= to_integer(unsigned(out_dff_delay)) - 1; 
                            state <= PULSE_LOW;
                        end if;

                    -- caso uscita 1 e variabile diversa da zero allora devo continuare ad iterare
                    else 
                        iter_left <= iter_left - 1;
                    end if;

                -- caso uscita 0 e variabile a 0 allora devo leggere da dff_len
                when PULSE_LOW =>
                    if(iter_left = 0) then 
                        if(unsigned(out_dff_len) = 0) then
                            state <= IDLE;
                        else
                            iter_left <= to_integer(unsigned(out_dff_len)) - 1; -- sicuramente manca la conversione da segnale ad intero
                            state <= PULSE_HIGH;
                        end if;

                    -- caso uscita 0 e variabile diversa da zero allora devo continuare ad iterare
                    else 
                        iter_left <= iter_left - 1;
                    end if;
            end case;
        end if;
    end process;
    
    pulse <= '1' when state = PULSE_HIGH else '0';
end architecture;