library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jtag_terminal_cy3 is
    port
    (
        -- clocks
        ADC_CLK_10          : in std_ulogic;
        MAX10_CLK1_50       : in std_ulogic;
        MAX10_CLK2_50       : in std_ulogic;
        
        -- keys
        KEY                 : in std_ulogic_vector(1 downto 0);
        
        -- LEDs
        LED                 : out std_ulogic_vector(7 downto 0);
        
        -- CapSense button
        CAP_SENSE_I2C_SCL   : inout std_ulogic;
        CAP_SENSE_I2C_SDA   : inout std_ulogic;
        
        -- Audio
        AUDIO_BCLK          : inout std_ulogic;
        AUDIO_DIN_MFP1      : out std_ulogic;
        AUDIO_DOUT_MFP2     : in std_ulogic;
        AUDIO_GPIO_MFP5     : inout std_logic;
        AUDIO_MCLK          : out std_ulogic;
        AUDIO_MISO_MFP4     : in std_ulogic;
        AUDIO_RESET_n       : in std_ulogic;
        AUDIO_SCL_SS_n      : out std_ulogic;
        AUDIO_SCLK_MFP3     : out std_ulogic;
        AUDIO_SDA_MOSI      : inout std_ulogic;
        AUDIO_SPI_SELECT    : out std_ulogic;
        AUDIO_WCLK          : inout std_ulogic;
        
        -- SDRAM
        DDR3_A              : out std_logic_vector(14 downto 0);
        DDR3_BA             : out std_logic_vector(2 downto 0);
        DDR3_CAS_n          : out std_logic;
        DDR3_CK_n           : inout std_logic;
        DDR3_CK_p           : inout std_logic;
        DDR3_CKE            : out std_logic;
        DDR3_CLK_50         : in std_logic;
        DDR3_CS_n           : out std_logic;
        DDR3_DM             : out std_logic_vector(1 downto 0);
        DDR3_DQ             : inout std_logic_vector(15 downto 0);
        DDR3_DQS_n          : inout std_logic_vector(1 downto 0);
        DDR3_DQS_p          : inout std_logic_vector(1 downto 0);
        DDR3_ODT            : out std_logic;
        DDR3_RAS_n          : out std_logic;
        DDR3_RESET_n        : out std_logic;
        DDR3_WE_n           : out std_logic;
        
        -- FLASH
        FLASH_DATA          : inout std_ulogic_vector(3 downto 0);
        FLASH_DCLK          : out std_ulogic;
        FLASH_NCSO          : out std_ulogic;
        FLASH_RESET_n       : out std_ulogic;
        
        -- G-Sensor
        G_SENSOR_CS_n       : out std_ulogic;
        G_SENSOR_INT1       : in std_ulogic;
        G_SENSOR_INT2       : in std_ulogic;
        G_SENSOR_SCLK       : inout std_ulogic;
        G_SENSOR_SDI        : inout std_ulogic;
        G_SENSOR_SDO        : inout std_ulogic;
        
        -- HDMI TX
        HDMI_I2C_SCL        : inout std_ulogic;
        HDMI_I2C_SDA        : inout std_ulogic;
        HDMI_I2S            : inout std_ulogic_vector(3 downto 0);
        HDMI_LRCLK          : inout std_ulogic;
        HDMI_MCLK           : inout std_ulogic;
        HDMI_SCLK           : inout std_ulogic;
        HDMI_TX_CLK         : out std_ulogic;
        HDMI_TX_D           : out std_ulogic_vector(23 downto 0);
        HDMI_TX_DE          : out std_ulogic;
        HDMI_TX_HS          : out std_ulogic;
        HDMI_TX_INT         : in std_ulogic;
        HDMI_TX_VS          : out std_ulogic;
        
        -- light sensor
        LIGHT_I2C_SCL       : out std_ulogic;
        LIGHT_I2C_SDA       : inout std_ulogic;
        LIGHT_INT           : inout std_ulogic;
        
        -- MIPI (Mobile Industry Processor Interface) camera module
        MIPI_CORE_EN        : out std_ulogic;
        MIPI_I2C_SCL        : out std_ulogic;
        MIPI_I2C_SDA        : inout std_ulogic;
        MIPI_LP_MC_n        : in std_ulogic;
        MIPI_LP_MC_p        : in std_ulogic;
        MIPI_LP_MD_n        : in std_ulogic_vector(3 downto 0);
        MIPI_LP_MD_p        : in std_ulogic_vector(3 downto 0);
        MIPI_MC_p           : in std_ulogic;
        MIPI_MCLK           : out std_ulogic;
        MIPI_MD_p           : in std_ulogic_vector(3 downto 0);
        MIPI_RESET_n        : out std_ulogic;
        MIPI_WP             : out std_ulogic;
        
        -- Ethernet
        NET_COL             : in std_ulogic;
        NET_CRS             : in std_ulogic;
        NET_MDC             : out std_ulogic;
        NET_MDIO            : inout std_ulogic;
        NET_PCF_EN          : out std_ulogic;
        NET_RESET_n         : out std_ulogic;
        NET_RX_CLK          : in std_ulogic;
        NET_RX_DV           : in std_ulogic;
        NET_RX_ER           : in std_ulogic;
        NET_RXD             : in std_ulogic_vector(3 downto 0);
        NET_TX_CLK          : in std_ulogic;
        NET_TX_EN           : out std_ulogic;
        NET_TXD             : out std_ulogic_vector(3 downto 0);
        
        -- power monitor
        PMONITOR_ALERT      : in std_ulogic;
        PMONITOR_I2C_SCL    : out std_ulogic;
        PMONITOR_I2C_SDA    : inout std_ulogic;
        
        -- humidity and temperature sensor
        RH_TEMP_DRDY_n      : in std_ulogic;
        RH_TEMP_I2C_SCL     : out std_ulogic;
        RH_TEMP_I2C_SDA     : in std_ulogic;
        
        -- Micro SD card
        SD_CLK              : out std_ulogic;
        SD_CMD              : inout std_ulogic;
        SD_CMD_DIR          : out std_ulogic;
        SD_D0_DIR           : out std_ulogic;
        SD_D123_DIR         : out std_ulogic;
        SD_DAT              : inout std_ulogic_vector(3 downto 0);
        SD_FB_CLK           : in std_ulogic;
        SD_SEL              : out std_ulogic;
        
        -- switches
        SW                  : in std_ulogic_vector(1 downto 0);
        
        -- board temperature sensor
        TEMP_CS_n           : out std_ulogic;
        TEMP_SC             : out std_ulogic;
        TEMP_SIO            : inout std_ulogic;
        
        -- USB
        USB_CLKIN           : in std_ulogic;
        USB_CS              : out std_ulogic;
        USB_DATA            : inout std_ulogic_vector(7 downto 0);
        USB_DIR             : in std_ulogic;
        USB_FAULT_n         : in std_ulogic;
        USB_NXT             : in std_ulogic;
        USB_RESET_n         : out std_ulogic;
        USB_STP             : out std_ulogic;
        
        -- BBB connector
        BBB_PWR_BUT         : in std_ulogic;
        BBB_SYS_RESET_n     : in std_ulogic;
        GPIO0_D             : inout std_ulogic_vector(43 downto 0);
        GPIO1_D             : inout std_ulogic_vector(22 downto 0)
    );
end entity jtag_terminal_cy3;

architecture rtl of jtag_terminal_cy3 is
    signal reset_n                  : std_ulogic := '0';
    signal clk                      : std_ulogic;
    signal pll_locked               : std_ulogic := '1';
    
    signal button_reset_n           : std_ulogic := '1';
    signal blink                    : std_ulogic;

    signal uart_out_start           : std_ulogic := '0';
    signal uart_out_idle            : std_ulogic := '0';
    signal uart_out_data            : character;

    signal uart_in_data_available   : std_ulogic;
    signal uart_in_data_req         : std_ulogic;
    signal uart_in_data             : character;
    signal uart_in_paused           : std_ulogic;
    
begin 
    clk <= MAX10_CLK1_50;
    
    i_reset_circuit : entity work.deca_reset
        generic map
        (
            WAIT_TICKS          => 1000
        )
        port map
        (
            clk                 => clk,
            reset_n             => reset_n,
            reset_button_n      => button_reset_n,
            lock_pll            => pll_locked
        );
    

    i_reset_button : entity work.reset_button
        port map
        (
            clk                 => clk,
            button              => KEY(0),
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
        signal c            : character := '+';
        signal have_it      : std_ulogic := '0';
    begin
        process
        begin
            wait until rising_edge(clk);
              
            -- what comes in goes out
              
            if not uart_in_data_available and not have_it then
                uart_in_data_req <= '1';
            else
                uart_in_data_req <= '0';
                c <= uart_in_data;
                have_it <= '1';
            end if;
            
            if uart_out_idle and have_it then
                uart_out_data <= c;
                uart_out_start <= '1';
                have_it <= '0';
            else
                uart_out_start <= '0';
            end if;
        end process;
    end block;
    
    LED(0) <= button_reset_n;
    LED(1) <= reset_n;
    LED(2) <= '1';
    LED(3) <= '1';
    LED(4) <= '1';
    LED(5) <= not pll_locked;
    LED(6) <= '1';
    LED(7) <= blink;
end architecture rtl;
