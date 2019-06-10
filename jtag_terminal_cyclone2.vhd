library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

use work.utils.all;

entity jtag_terminal_cyclone2 is
    port
    (
        -- clocks
        CLK_50              : in std_ulogic;                            -- input clock
        
        -- keys
        KEY                 : in std_ulogic_vector(1 downto 0);
        
        -- LEDs
        LED                 : out std_ulogic_vector(2 downto 0)         -- LED on board (PIN_3, 7, 9)
    );
end entity jtag_terminal_cyclone2;

architecture rtl of jtag_terminal_cyclone2 is
    signal clk                      : std_ulogic;
begin 
    clk <= CLK_50;
    i_jtag_terminal : entity work.jtag_terminal
        port map
        (
            clk             => CLK_50,
            reset_button    => KEY(0),
            leds            => LED(2 downto 0)
            
        );
end architecture rtl;
