# Esteira Industrial - Mini Controlador Digital

> Dupla: Matheus Nogueira e Pedro Chaves

# 🎯 Objetivo do Projeto:

O objetivo deste circuito é implementar um Controlador Digital de Esteira Industrial seguro e eficiente utilizando uma Máquina de Estados Finitos (FSM).

O sistema visa automatizar o controle do motor da esteira, garantindo que:

- **Eficiência:** A esteira pare automaticamente caso haja um acúmulo de peças na saída (evitando engarrafamentos).

- **Segurança:** A esteira desligue imediatamente e trave em caso de falha crítica (sensor de falha).

- **Controle:** O operador tenha controle manual de partida e feedback visual claro do estado da máquina através de LEDs.

# 🏭 Variáveis do Controlador de Esteira (FSM)

Descrição detalhada dos sinais utilizados no projeto VHDL do controlador de esteira industrial.

## 📥 1. Entradas (Inputs)
*Sinais que chegam do mundo externo para dentro do FPGA.*

| Sinal | Símbolo | Descrição | Função |
| :--- | :---: | :--- | :--- |
| **`clk`** | ⏰ | **Clock** (O "coração" do sistema). | Sincroniza a mudança de estados. A máquina toma decisões na borda de subida (0 para 1). |
| **`reset`** | 🔄 | **Reset** (Botão de emergência). | Quando é `'1'`, força a máquina imediatamente para o estado **PAUSADO**, ignorando o resto. |
| **`btn_partida`** | ▶️ | **Botão de Partida** (Operador). | Comando para sair do modo de espera. Se a esteira estiver pausada/sem problemas, inicia o motor. |
| **`sensor_acumulo`** | 📦 | **Sensor de Acúmulo** (Ótico/Barreira). | Monitora o fluxo:<br>• `'1'`: Muitas peças (Esteira deve pausar).<br>• `'0'`: Fluxo livre (Esteira roda). |
| **`sensor_falha`** | ⚠️ | **Sensor de Falha Crítica**. | Alerta de perigo grave (ex: superaquecimento).<br>• `'1'`: Sistema vai para **ERRO** e trava até reset. |

## 📤 2. Saídas (Outputs)
*Sinais que o FPGA envia para controlar componentes externos.*

| Sinal | Símbolo | Descrição | Comportamento |
| :--- | :---: | :--- | :--- |
| **`motor_esteira`** | ⚙️ | **Controle do Motor** (Relé). | • `'1'`: Motor **LIGADO** (Esteira andando).<br>• `'0'`: Motor **DESLIGADO**. |
| **`led_ligado`** | 🟢 | **LED Verde** (Normal). | Acende quando o sistema está no estado **LIGADO** e produzindo. |
| **`led_pausado`** | 🟡 | **LED Amarelo** (Atenção). | Acende quando o sistema está **PAUSADO** (aguardando partida ou liberação de acúmulo). |
| **`led_erro`** | 🔴 | **LED Vermelho** (Crítico). | Acende no estado de **ERRO**. Indica parada por segurança e requer manutenção. |

## 🧠 3. Sinais Internos (Internal Signals)
*Variáveis usadas apenas dentro da lógica do código, invisíveis externamente.*

| Sinal | Tipo | Descrição | Função |
| :--- | :--- | :--- | :--- |
| **`estado_atual`** | Memória 💾 | Registrador da situação presente. | Define quais saídas devem estar ativas agora.<br>**Valores:** `LIGADO`, `PAUSADO`, `ERRO`. |
| **`proximo_estado`** | Lógica 🔮 | Sinal combinacional. | Analisa o `estado_atual` e as **Entradas** para decidir o destino no próximo clock. |


# 📊 Prints das Simulações:

Após apertar o botão de partida para ligar o motor da esteira:

<img width="707" height="274" alt="image" src="https://github.com/user-attachments/assets/1b7c111a-2aa9-4de8-95fa-3fb3d196cf4e" />

Sensor de acúmulo detectou acúmulo:

<img width="1304" height="333" alt="image" src="https://github.com/user-attachments/assets/690f2728-586a-47e0-a74f-64c3ac26773c" />

Tenta ligar o motor com acúmulo mas continua pausado para segurança:

<img width="733" height="269" alt="image" src="https://github.com/user-attachments/assets/0103de33-2a31-4af7-be70-96e078e6ed49" />

Após tirar o acúmulo de peças, tenta ligar novamente e consegue ligar:

<img width="851" height="256" alt="image" src="https://github.com/user-attachments/assets/1ae26c47-c3e1-49dc-a062-179c6a02b347" />

Sensor de falha ativa, ativando o led de erro, enquanto não corrigir o erro, caso tente iniciar a esteira, irá continuar ligado o led de erro e a esteira desligada:

<img width="736" height="258" alt="image" src="https://github.com/user-attachments/assets/a6a6a31c-0f0d-4fef-97af-a4d54e164cd3" />

# 📍 Diagrama de Estados (FSM)

**Estado Inicial:** O sistema sempre inicia (ou reseta) no estado PAUSADO.

- **Transição 1 (Partida):** De PAUSADO para LIGADO.

  - **Condição:** Botão de partida pressionado (btn=1) E sem acúmulo de peças (acumulo=0).

- **Transição 2 (Acúmulo):** De LIGADO para PAUSADO.

  - **Condição:** Sensor de acúmulo ativado (acumulo=1). O motor para temporariamente.

- **Transição 3 (Falha Crítica):** De Qualquer Estado para ERRO.

  - **Condição:** Sensor de falha ativado (falha=1).

- **Transição 4 (Recuperação):** De ERRO para PAUSADO.

  - **Condição:** Apenas através do acionamento do RESET.
