# Esteira Industrial - Mini Controlador Digital

> Dupla: Matheus Nogueira e Pedro Chaves

# 🏭 Variáveis do Controlador de Esteira (FSM)

Este documento descreve detalhadamente os sinais utilizados no projeto VHDL do controlador de esteira industrial.

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
