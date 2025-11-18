library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlador_esteira is
    Port (
        clk             : in  STD_LOGIC; -- Clock principal
        reset           : in  STD_LOGIC; -- Reset assíncrono (ativo em '1')
        btn_partida     : in  STD_LOGIC; -- Botão para iniciar a esteira (do estado pausado)
        sensor_acumulo  : in  STD_LOGIC; -- '1' = peças acumuladas
        sensor_falha    : in  STD_LOGIC; -- '1' = falha crítica do motor
        
        -- Saídas de controle e status
        motor_esteira   : out STD_LOGIC; -- '1' = motor ligado
        led_ligado      : out STD_LOGIC;
        led_pausado     : out STD_LOGIC;
        led_erro        : out STD_LOGIC
    );
end controlador_esteira;

architecture FSM of controlador_esteira is

    -- 1. Definição dos estados da máquina
    type T_ESTADO is (LIGADO, PAUSADO, ERRO);
    
    -- 2. Sinais internos para o estado
    signal estado_atual, proximo_estado : T_ESTADO;

begin

    -- Processo 1: Lógica Sequencial (Registro de Estado)
    -- Este processo atualiza o estado atual na borda de subida do clock
    -- e lida com o reset assíncrono.
    process(clk, reset)
    begin
        if reset = '1' then
            -- O estado de reset é PAUSADO (estado seguro)
            estado_atual <= PAUSADO;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;

    -- Processo 2: Lógica Combinacional (Próximo Estado)
    -- Este processo decide qual será o próximo estado com base no
    -- estado atual e nas entradas.
    process(estado_atual, btn_partida, sensor_acumulo, sensor_falha)
    begin
        -- Por padrão, o próximo estado é o estado atual
        proximo_estado <= estado_atual; 

        case estado_atual is
            
            when PAUSADO =>
                if sensor_falha = '1' then
                    proximo_estado <= ERRO;
                elsif btn_partida = '1' and sensor_acumulo = '0' then
                    -- Só pode partir se o botão for pressionado E o sensor estiver livre
                    proximo_estado <= LIGADO;
                end if;
                
            when LIGADO =>
                if sensor_falha = '1' then
                    proximo_estado <= ERRO;
                elsif sensor_acumulo = '1' then
                    -- Detectou acúmulo, pausa a esteira
                    proximo_estado <= PAUSADO;
                end if;
                
            when ERRO =>
                -- Uma vez no estado de ERRO, só um RESET pode tirar daqui.
                -- (O reset é tratado no Processo 1)
                proximo_estado <= ERRO;
                
        end case;
    end process;

    -- Processo 3: Lógica de Saída (Máquina de Moore)
    -- As saídas dependem APENAS do estado atual.
    process(estado_atual)
    begin
        -- Define valores padrão para as saídas
        motor_esteira <= '0';
        led_ligado    <= '0';
        led_pausado   <= '0';
        led_erro      <= '0';
        
        case estado_atual is
            when LIGADO =>
                motor_esteira <= '1';
                led_ligado    <= '1';
                
            when PAUSADO =>
                motor_esteira <= '0';
                led_pausado   <= '1';
                
            when ERRO =>
                motor_esteira <= '0';
                led_erro      <= '1';
        end case;
    end process;

end FSM;