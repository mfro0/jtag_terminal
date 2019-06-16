library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

use work.utils.all;

entity jtag_terminal_deca is
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
end entity jtag_terminal_deca;

architecture rtl of jtag_terminal_deca is
    signal reset_n                  : std_ulogic := '1';
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
    
    i_jtag_terminal : entity work.jtag_terminal
        port map
        (
            clk             => MAX10_CLK1_50,
            reset_button    => KEY(0),
            leds            => LED(2 downto 0)
            
        );
    
end architecture rtl;
