library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_controlador_esteira is
end tb_controlador_esteira;

architecture SIM of tb_controlador_esteira is

    -- 1. Componente a ser testado (UUT - Unit Under Test)
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

    -- 2. Sinais de estímulo (entradas)
    signal s_clk             : STD_LOGIC := '0';
    signal s_reset           : STD_LOGIC := '0';
    signal s_btn_partida     : STD_LOGIC := '0';
    signal s_sensor_acumulo  : STD_LOGIC := '0';
    signal s_sensor_falha    : STD_LOGIC := '0';
    
    -- 3. Sinais de observação (saídas)
    signal s_motor_esteira   : STD_LOGIC;
    signal s_led_ligado      : STD_LOGIC;
    signal s_led_pausado     : STD_LOGIC;
    signal s_led_erro        : STD_LOGIC;

    -- 4. Constante do Clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- 5. Instanciação da UUT
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

    -- 6. Processo de Geração de Clock
    clk_gen_proc : process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD / 2;
        s_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- 7. Processo de Estímulos
    stim_proc : process
    begin
        -- Cenário 1: Reset inicial
        report "TESTE: Aplicando Reset. Estado deve ir para PAUSADO.";
        s_reset <= '1';
        wait for CLK_PERIOD * 2;
        s_reset <= '0';
        wait for CLK_PERIOD;
        -- Neste ponto, FSM deve estar em PAUSADO (motor=0, led_pausado=1)
        
        -- Cenário 2: Partida
        report "TESTE: Pressionando botao de partida. Estado deve ir para LIGADO.";
        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 5;
        -- Neste ponto, FSM deve estar em LIGADO (motor=1, led_ligado=1)

        -- Cenário 3: Acúmulo de peças
        report "TESTE: Ativando sensor de acumulo. Estado deve ir para PAUSADO.";
        s_sensor_acumulo <= '1';
        wait for CLK_PERIOD * 2;
        -- Neste ponto, FSM deve estar em PAUSADO (motor=0, led_pausado=1)
        
        -- Cenário 4: Liberação da esteira (tentativa de partida)
        report "TESTE: Tentando partir com sensor ainda ativo (deve falhar).";
        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 2;
         -- Neste ponto, FSM deve continuar em PAUSADO

        report "TESTE: Liberando sensor e pressionando partida. Estado deve ir para LIGADO.";
        s_sensor_acumulo <= '0';
        wait for CLK_PERIOD;
        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 5;
        -- Neste ponto, FSM deve estar em LIGADO (motor=1, led_ligado=1)

        -- Cenário 5: Falha crítica
        report "TESTE: Ativando sensor de FALHA. Estado deve ir para ERRO.";
        s_sensor_falha <= '1';
        wait for CLK_PERIOD * 2;
        -- Neste ponto, FSM deve estar em ERRO (motor=0, led_erro=1)

        -- Cenário 6: Verificação do travamento em ERRO
        report "TESTE: Desligando sensor de falha e tentando partir (deve falhar).";
        s_sensor_falha <= '0';
        s_btn_partida <= '1';
        wait for CLK_PERIOD;
        s_btn_partida <= '0';
        wait for CLK_PERIOD * 2;
        -- Neste ponto, FSM deve continuar em ERRO
        
        -- Cenário 7: Reset para sair do ERRO
        report "TESTE: Aplicando Reset para sair do ERRO. Estado deve ir para PAUSADO.";
        s_reset <= '1';
        wait for CLK_PERIOD * 2;
        s_reset <= '0';
        wait for CLK_PERIOD;
        -- Neste ponto, FSM deve estar em PAUSADO
        
        report "TESTE: Simulacao Concluida.";
        wait; -- Fim da simulação
    end process;

end SIM;