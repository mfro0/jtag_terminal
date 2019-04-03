library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jtag_uart is
    port
    (
        clk                             : in std_ulogic;
        reset_n                         : in std_ulogic;

        rx_data                         : out character;    -- received data
        rx_ready                        : out std_ulogic;   -- received data valid
        rx_data_req                     : in std_ulogic;    -- got it

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
            
            t_dat                       : out character;                        -- incoming data
            t_dav                       : in std_ulogic;                        -- give us more data
            t_ena                       : out std_ulogic;                       -- received data available
            t_pause                     : out std_ulogic
        );
    end component alt_jtag_atlantic;



    signal tx_data_valid                : std_ulogic;
    signal tx_idle                      : std_ulogic;
    signal rx_paused                    : std_ulogic;
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

            -- alt_jtag_atlantic ports have _very_ strange (kind of backwards) names...
            
            -- this is the receiving part of alt_jtag_atlantic, the ports
            -- we actually *send* data to
            r_dat                       => tx_data,
            r_val                       => tx_data_valid,
            r_ena                       => tx_idle,

            -- this is the sending part of alt_jtag_atlantic, i.e. the ports
            -- we receive data from
            t_dat                       => rx_data,
            t_dav                       => rx_data_req,
            t_ena                       => rx_ready,
            t_pause                     => rx_paused
        );


    p_send : process(all)
    begin
        if rising_edge(clk) then
            if tx_idle then
                tx_data_valid <= '1';
            else
                tx_data_valid <= '0';
            end if;
        end if;
    end process p_send;
    
    b_receive : block
        type rx_state_type is (START, WAIT_RECEIVE);
		signal rx_state     : rx_state_type := START;
    begin
        p_receive : process(all)
        begin
            if rising_edge(clk) then
                case rx_state is
                    when START =>
                        rx_state <= WAIT_RECEIVE;
                
                    when WAIT_RECEIVE =>
                        if rx_ready then
                            rx_state <= START;
                        end if;
                end case;
            end if;
        end process p_receive;
    end block b_receive;
    
    tx_busy <= not tx_idle;
end architecture rtl;
