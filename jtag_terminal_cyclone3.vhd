library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utils.all;

entity jtag_terminal_cyclone3 is
    port
    (
        -- clocks
        CLK_50              : in std_ulogic;
        -- keys
        KEY                 : in std_ulogic_vector(1 downto 0);
        
        -- LEDs
        LED                 : out std_ulogic_vector(7 downto 0)        
    );
end entity jtag_terminal_cyclone3;

architecture rtl of jtag_terminal_cyclone3 is
    signal clk                      : std_ulogic;
       
begin
    
    i_jtag_terminal : entity work.jtag_terminal
        port map
        (
            clk             => CLK_50,
            reset_button    => KEY(0),
            leds            => LED(2 downto 0)
            
        );
end architecture rtl;
