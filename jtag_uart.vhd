library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jtag_uart is
    port
    (
        clk                             : in std_ulogic;
        reset_n                         : in std_ulogic;

        rx_data                         : out character;    -- received data
        rx_data_ready                   : out std_ulogic;   -- received data valid
        rx_data_ack                     : in std_ulogic;    -- got it

        tx_data                         : in  character;    -- data to send
        tx_start                        : in  std_ulogic;   -- start sending data
        tx_busy                         : out std_ulogic    -- we are still busy sending
     );
end entity jtag_uart;

architecture rtl of jtag_uart is
    component alt_jtag_atlantic
        generic
        (
            INSTANCE_ID                 : integer := 0;
            LOG2_RXFIFO_DEPTH           : integer := 6;
            LOG2_TXFIFO_DEPTH           : integer := 6;
            SLD_AUTO_INSTANCE_INDEX     : string := "YES"
        );
        port
        (
            clk                         : in std_ulogic;
            rst_n                       : in std_ulogic;
            
            r_dat                       : in character;                         -- data to send
            r_val                       : in std_ulogic;                        -- data is valid
            r_ena                       : out std_ulogic;                       -- allow to send data
            
            t_dat                       : out character;                        -- data to receive
            t_dav                       : in std_ulogic;                        -- data fetched
            t_ena                       : out std_ulogic;                       -- receiver enabled
            t_pause                     : out std_ulogic
        );
    end component alt_jtag_atlantic;

    signal r_dat                        : character;
    signal r_val                        : std_ulogic;
    signal r_ena                        : std_ulogic;
    signal t_dat                        : character;
    signal t_dav                        : std_ulogic;
    signal t_ena                        : std_ulogic;
    signal t_pause                      : std_ulogic;

    signal is_full_reg                  : std_ulogic;
    signal data_reg                     : std_ulogic_vector(7 downto 0);

    signal cnt                          : unsigned(24 downto 0);
begin
    i_jtag_uart : component alt_jtag_atlantic
        generic map
        (
            INSTANCE_ID                 => 0,
            LOG2_RXFIFO_DEPTH           => 6,
            LOG2_TXFIFO_DEPTH           => 6,
            SLD_AUTO_INSTANCE_INDEX     => "YES"
        )
        port map
        (
            clk                         => clk,
            rst_n                       => reset_n,

            -- alt_jtag_atlantic ports have _very_ strange (backwards) names...
            
            -- this is the receiving part of alt_jtag_atlantic, the ports
            -- we actually *send* data to
            r_dat                       => r_dat,
            r_val                       => r_val,
            r_ena                       => r_ena,

            -- this is the sending part of alt_jtag_atlantic, the ports
            -- we receive data from
            t_dat                       => t_dat,
            t_dav                       => t_dav,
            t_ena                       => t_ena,
            t_pause                     => t_pause
        );


    p_send : process(all)
    begin
        if rising_edge(clk) then
            if r_ena then
                r_val <= '1';
                r_dat <= tx_data;
            else
                r_val <= '0';
            end if;
        end if;
    end process p_send;
    
    p_receive : process(all)
    begin
        if rising_edge(clk) then
            if t_dav /* and not t_pause */ then
                rx_data <= t_dat;
                t_ena <= '1';           -- signal fetched data
            else 
                t_ena <= '0';
            end if;
        end if;
    end process p_receive;
                
    tx_busy <= r_ena;
    rx_data_ready <= t_dav;
end architecture rtl;
