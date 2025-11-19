library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controlador_esteira is
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
end controlador_esteira;

architecture FSM of controlador_esteira is

    type T_ESTADO is (LIGADO, PAUSADO, ERRO);
    signal estado_atual, proximo_estado : T_ESTADO;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual <= PAUSADO;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;

    process(estado_atual, btn_partida, sensor_acumulo, sensor_falha)
    begin
        proximo_estado <= estado_atual;

        case estado_atual is
            
            when PAUSADO =>
                if sensor_falha = '1' then
                    proximo_estado <= ERRO;
                elsif btn_partida = '1' and sensor_acumulo = '0' then
                    proximo_estado <= LIGADO;
                end if;
                
            when LIGADO =>
                if sensor_falha = '1' then
                    proximo_estado <= ERRO;
                elsif sensor_acumulo = '1' then
                    proximo_estado <= PAUSADO;
                end if;
                
            when ERRO =>
                proximo_estado <= ERRO;
                
        end case;
    end process;

    process(estado_atual)
    begin
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
