library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_controlador_esteira is
end tb_controlador_esteira;

architecture SIM of tb_controlador_esteira is

    component controlador_esteira
        Port (
            clk             : in  STD_LOGIC;
            reset           : in  STD_LOGIC;
            btn_partida     : in  STD_LOGIC;
            sensor_acumulo  : in  STD_LOGIC;
            sensor_falha    : in  STD_LOGIC;
            motor_esteira   : out STD_LOGIC;
            led_ligado      : out STD_LOGIC;
            led_pausado     : out STD_LOGIC;
            led_erro        : out STD_LOGIC
        );
    end component;

    signal s_clk             : STD_LOGIC := '0';
    signal s_reset           : STD_LOGIC := '0';
    signal s_btn_partida     : STD_LOGIC := '0';
    signal s_sensor_acumulo  : STD_LOGIC := '0';
    signal s_sensor_falha    : STD_LOGIC := '0';

    signal s_motor_esteira   : STD_LOGIC;
    signal s_led_ligado      : STD_LOGIC;
    signal s_led_pausado     : STD_LOGIC;
    signal s_led_erro        : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    UUT : controlador_esteira
        port map (
            clk             => s_clk,
            reset           => s_reset,
            btn_partida     => s_btn_partida,
            sensor_acumulo  => s_sensor_acumulo,
            sensor_falha    => s_sensor_falha,
            motor_esteira   => s_motor_esteira,
            led_ligado      => s_led_ligado,
            led_pausado     => s_led_pausado,
            led_erro        => s_led_erro
        );

    clk_gen_proc : process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD / 2;
        s_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    stim_proc : process
    begin
        s_reset <= '1';
        wait for CLK_PERIOD * 2;
        s_reset <= '0';
        wait for CLK_PERIOD;

        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 5;

        s_sensor_acumulo <= '1';
        wait for CLK_PERIOD * 2;

        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 2;

        s_sensor_acumulo <= '0';
        wait for CLK_PERIOD;
        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 5;

        s_sensor_falha <= '1';
        wait for CLK_PERIOD * 2;

        s_sensor_falha <= '0';
        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 2;

        s_reset <= '1';
        wait for CLK_PERIOD * 2;
        s_reset <= '0';
        wait for CLK_PERIOD;

        wait;
    end process;

end SIM;
