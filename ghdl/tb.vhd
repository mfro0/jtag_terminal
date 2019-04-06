library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end entity tb;

architecture rtl of tb is
    signal clk              : std_ulogic := '0';
    signal clk1,
           clk2             : std_ulogic := '0';
    signal led              : std_ulogic_vector(7 downto 0);
    signal key              : std_ulogic_vector(1 downto 0) := (others => '1');
    signal audio_dout_mfp2,
           audio_miso_mfp4  : std_ulogic;
    signal audio_reset_n    : std_ulogic;

    signal ddr3_cke         : std_ulogic;
    signal ddr3_clk_50      : std_ulogic;

    signal g_sensor_int1    : std_ulogic;
    signal g_sensor_int2    : std_ulogic;

    signal hdmi_tx_int      : std_ulogic;

    signal mipi_lp_mc_n     : std_ulogic;
    signal mipi_lp_mc_p     : std_ulogic;
    signal mipi_lp_md_n     : std_ulogic_vector(3 downto 0);
    signal mipi_lp_md_p     : std_ulogic_vector(3 downto 0);
    signal mipi_mc_p        : std_ulogic;
    signal mipi_md_p        : std_ulogic_vector(3 downto 0);

    signal net_col          : std_ulogic;
    signal net_crs          : std_ulogic;
    signal net_rx_clk,
           net_tx_clk       : std_ulogic;
    signal net_rx_dv,
           net_rx_er        : std_ulogic;
    signal net_rxd          : std_ulogic_vector(3 downto 0);

    signal pmonitor_alert   : std_ulogic;

    signal rh_temp_drdy_n,
           rh_temp_i2c_sda  : std_ulogic;

    signal sd_fb_clk        : std_ulogic;

    signal sw               : std_ulogic_vector(1 downto 0);

    signal usb_clkin        : std_ulogic;
    signal usb_dir          : std_ulogic;
    signal usb_fault_n      : std_ulogic;
    signal usb_nxt          : std_ulogic;

    signal bbb_pwr_but,
           bbb_sys_reset_n  : std_ulogic;
begin
    i_jtag_terminal : entity work.jtag_terminal
        port map
        (
            -- clocks
            ADC_CLK_10          => clk,
            MAX10_CLK1_50       => clk1,
            MAX10_CLK2_50       => clk2,

            -- keys
            KEY                 => key,

            -- LEDs
            LED                 => led,

            -- CapSense button
            CAP_SENSE_I2C_SCL   => open,
            CAP_SENSE_I2C_SDA   => open,

            -- Audio
            AUDIO_BCLK          => open,
            AUDIO_DIN_MFP1      => open,
            AUDIO_DOUT_MFP2     => audio_dout_mfp2,
            AUDIO_GPIO_MFP5     => open,
            AUDIO_MCLK          => open,
            AUDIO_MISO_MFP4     => audio_miso_mfp4,
            AUDIO_RESET_n       => audio_reset_n,
            AUDIO_SCL_SS_n      => open,
            AUDIO_SCLK_MFP3     => open,
            AUDIO_SDA_MOSI      => open,
            AUDIO_SPI_SELECT    => open,
            AUDIO_WCLK          => open,

            -- SDRAM
            DDR3_A              => open,
            DDR3_BA             => open,
            DDR3_CAS_n          => open,
            DDR3_CK_n           => open,
            DDR3_CK_p           => open,
            DDR3_CKE            => ddr3_cke,
            DDR3_CLK_50         => ddr3_clk_50,
            DDR3_CS_n           => open,
            DDR3_DM             => open,
            DDR3_DQ             => open,
            DDR3_DQS_n          => open,
            DDR3_DQS_p          => open,
            DDR3_ODT            => open,
            DDR3_RAS_n          => open,
            DDR3_RESET_n        => open,
            DDR3_WE_n           => open,

            -- FLASH
            FLASH_DATA          => open,
            FLASH_DCLK          => open,
            FLASH_NCSO          => open,
            FLASH_RESET_n       => open,

            -- G-Sensor
            G_SENSOR_CS_n       => open,
            G_SENSOR_INT1       => g_sensor_int1,
            G_SENSOR_INT2       => g_sensor_int2,
            G_SENSOR_SCLK       => open,
            G_SENSOR_SDI        => open,
            G_SENSOR_SDO        => open,

            -- HDMI TX
            HDMI_I2C_SCL        => open,
            HDMI_I2C_SDA        => open,
            HDMI_I2S            => open,
            HDMI_LRCLK          => open,
            HDMI_MCLK           => open,
            HDMI_SCLK           => open,
            HDMI_TX_CLK         => open,
            HDMI_TX_D           => open,
            HDMI_TX_DE          => open,
            HDMI_TX_HS          => open,
            HDMI_TX_INT         => hdmi_tx_int,
            HDMI_TX_VS          => open,

            -- light sensor
            LIGHT_I2C_SCL       => open,
            LIGHT_I2C_SDA       => open,
            LIGHT_INT           => open,

            -- MIPI (Mobile Industry Processor Interface) camera module
            MIPI_CORE_EN        => open,
            MIPI_I2C_SCL        => open,
            MIPI_I2C_SDA        => open,
            MIPI_LP_MC_n        => mipi_lp_mc_n,
            MIPI_LP_MC_p        => mipi_lp_mc_p,
            MIPI_LP_MD_n        => mipi_lp_md_n,
            MIPI_LP_MD_p        => mipi_lp_md_p,
            MIPI_MC_p           => mipi_mc_p,
            MIPI_MCLK           => open,
            MIPI_MD_p           => mipi_md_p,
            MIPI_RESET_n        => open,
            MIPI_WP             => open,

            -- Ethernet
            NET_COL             => net_col,
            NET_CRS             => net_crs,
            NET_MDC             => open,
            NET_MDIO            => open,
            NET_PCF_EN          => open,
            NET_RESET_n         => open,
            NET_RX_CLK          => net_rx_clk,
            NET_RX_DV           => net_rx_dv,
            NET_RX_ER           => net_rx_er,
            NET_RXD             => net_rxd,
            NET_TX_CLK          => net_tx_clk,
            NET_TX_EN           => open,
            NET_TXD             => open,

            -- power monitor
            PMONITOR_ALERT      => pmonitor_alert,
            PMONITOR_I2C_SCL    => open,
            PMONITOR_I2C_SDA    => open,

            -- humidity and temperature sensor
            RH_TEMP_DRDY_n      => rh_temp_drdy_n,
            RH_TEMP_I2C_SCL     => open,
            RH_TEMP_I2C_SDA     => rh_temp_i2c_sda,

            -- Micro SD card
            SD_CLK              => open,
            SD_CMD              => open,
            SD_CMD_DIR          => open,
            SD_D0_DIR           => open,
            SD_D123_DIR         => open,
            SD_DAT              => open,
            SD_FB_CLK           => sd_fb_clk,
            SD_SEL              => open,

            -- switches
            SW                  => sw,

            -- board temperature sensor
            TEMP_CS_n           => open,
            TEMP_SC             => open,
            TEMP_SIO            => open,

            -- USB
            USB_CLKIN           => usb_clkin,
            USB_CS              => open,
            USB_DATA            => open,
            USB_DIR             => usb_dir,
            USB_FAULT_n         => usb_fault_n,
            USB_NXT             => usb_nxt,
            USB_RESET_n         => open,
            USB_STP             => open,

            -- BBB connector
            BBB_PWR_BUT         => bbb_pwr_but,
            BBB_SYS_RESET_n     => bbb_sys_reset_n
        );
    
    p_clockit : process
    begin
        wait for 20 ns;
        clk <= not clk;
    end process p_clockit;
    clk1 <= clk;
    clk2 <= clk;
end architecture rtl;