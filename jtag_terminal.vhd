library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

use work.utils.all;

entity jtag_terminal is
    port
    (
        clk             : in std_ulogic;
        reset_button    : in std_ulogic;
        leds            : out std_ulogic_vector(2 downto 0)
    );
end entity jtag_terminal;

architecture rtl of jtag_terminal is
    signal reset_n                  : std_ulogic := '1';
    signal button_reset_n           : std_ulogic := '1';
    signal blink                    : std_ulogic;

    signal uart_out_start           : std_ulogic := '0';
    signal uart_out_idle            : std_ulogic := '0';
    signal uart_out_data            : character;

    signal uart_in_data_available   : std_ulogic;
    signal uart_in_data_req         : std_ulogic;
    signal uart_in_data             : character;
    signal uart_in_paused           : std_ulogic;
    signal pll_locked               : std_ulogic := '1';

begin
    i_reset_circuit : entity work.deca_reset
        generic map
        (
            WAIT_TICKS          => 10000
        )
        port map
        (
            clk                 => clk,
            lock_pll            => pll_locked,
            reset_button_n      => button_reset_n,
            reset_n             => reset_n
        );
    

    i_reset_button : entity work.reset_button
        port map
        (
            clk                 => clk,
            button              => reset_button,
            reset_out_n         => button_reset_n
        );

    i_uart : entity work.jtag_uart
        generic map
        (
            LOG2_RXFIFO_DEPTH   => 0,
            LOG2_TXFIFO_DEPTH   => 0
        )
        port map
        (
            clk                 => clk,
            reset_n             => reset_n,
            
            rx_data             => uart_in_data,
            rx_ready            => uart_in_data_available,
            rx_data_req         => uart_in_data_req,
            rx_paused           => uart_in_paused,
            
            tx_data             => uart_out_data,
            tx_start            => uart_out_start,
            tx_idle             => uart_out_idle
        );

        i_blinker : entity work.blinker
        generic map
        (
            CLK_FREQUENCY       => 50_000_000,
            BLINKS_PER_SECOND   => 2
        )
        port map
        (
            clk                         => clk,
            reset_n                     => reset_n,
            led                         => blink
        );
      
    echo : block
        signal counter          : natural range 0 to 255;
        constant counter_max    : natural := 255;
        constant delay          : natural := 100_000;
        signal delay_counter    : natural := 0;
        signal str              : string(1 to 3);
        type out_status_type is (IDLE, START, REQ, SEND);
        signal out_status       : out_status_type := IDLE;
        signal str_out_start    : std_ulogic := '0';
        signal ws_busy          : std_ulogic := '0';
        signal index            : integer := str'low;
    begin
        -- start string write if previous write string finished
        str_out_start <= '1' when not ws_busy else '0';

        ws : process(all)
        begin
            if not reset_n then
                counter <= 0;
                delay_counter <= 0;
                out_status <= IDLE;
                ws_busy <= '0';
            elsif rising_edge(clk) then
                case out_status is
                    when IDLE =>
                        if str_out_start = '1' then
                            -- count up delay counter
                            if delay_counter /= delay then
                                delay_counter <= delay_counter + 1;
                            else
                                delay_counter <= 0;
    
                                -- count up counter
                                if counter = counter_max then
                                    counter <= 0;
                                else
                                    counter <= counter + 1;
                                end if;
                            
                                -- convert counter to hex and append a newline
                                str <= to_hstring(to_unsigned(counter, integer(ceil(log2(real(counter'high)))))) & character'val(10);
                            
                                ws_busy <= '1';
                                out_status <= START;
                            end if;
                        end if;
    
                    when START =>
                        if uart_out_idle then
                            uart_out_data <= str(index);
                            uart_out_start <= '1';
                            out_status <= REQ;
                        end if;
    
                    when REQ =>
                        -- wait for uart_out_idle to become inactive
                        if not uart_out_idle then
                            out_status <= SEND;
                            uart_out_start <= '0';
                            index <= index + 1;
                        end if;
    
                    when SEND =>
                        -- wait for uart_out_idle to become active again
                        if uart_out_idle then
                            if index > str'high then
                                index <= str'low;
                                ws_busy <= '0';
                                out_status <= IDLE;
                            else
                                out_status <= START;
                            end if;
                        end if;
                end case;
            end if; -- if rising_edge(clk)
        end process ws;
    end block;
end architecture rtl;