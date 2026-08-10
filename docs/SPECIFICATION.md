# Senhador

## Visão Geral

O Senhador é um aplicativo multiplataforma desenvolvido em Flutter para geração determinística de senhas seguras.

Diferentemente dos gerenciadores de senhas tradicionais, o Senhador não armazena senhas em banco de dados, nuvem ou arquivos locais.

As senhas são geradas sob demanda a partir de:

- Uma Senha Mestra
- Um Identificador (Parâmetro)

A mesma combinação sempre gera a mesma senha.

Exemplo:
Parâmetro:
gmail.com

Senha Mestra:
MinhaSenhaForte2026


Resultado:
Q@9mL2#rX7!cNp4&

---

## Objetivos

### Objetivos Principais

- Gerar senhas fortes e determinísticas
- Não armazenar senhas
- Funcionar totalmente offline
- Garantir a privacidade do usuário
- Ser simples e intuitivo
- Operar em Web e Android usando uma única base de código

### Objetivos Secundários

- Publicação como PWA
- Publicação em GitHub Pages
- Compatibilidade futura com iOS
- Possibilidade de exportação/importação de configurações

---

## Conceitos

### Senha Mestra

Segredo conhecido apenas pelo usuário.

Exemplo:

MinhaSenhaForte2026

A senha mestra nunca deve ser:

- armazenada
- transmitida
- registrada em logs

---

### Parâmetro

Identificador único do serviço.

Exemplos:

gmail.com
github.com
microsoft.com
internetbanking

O parâmetro funciona como contexto para derivação da senha.

---

### Senha Gerada

Resultado determinístico da combinação:

Senha Mestra + Parâmetro

Características:

- mesma entrada = mesma saída
- forte
- compatível com requisitos modernos
- não armazenada

---

## Arquitetura de Segurança

### Princípios

1. Zero conhecimento
2. Offline First
3. Sem armazenamento de credenciais
4. Sem sincronização automática
5. Sem telemetria de dados sensíveis

---

## Algoritmo de Geração

### Fluxo

Senha Mestra
↓
PBKDF2-SHA256
↓
Material Criptográfico
↓
HMAC-SHA256
↓
Derivação de Caracteres
↓
Senha Final

---

## Derivação

Entradas:

- Senha Mestra
- Parâmetro

Processo:

1. Executar PBKDF2-SHA256
2. Utilizar 100.000 iterações
3. Utilizar o parâmetro como salt
4. Produzir 256 bits de saída
5. Gerar senha final a partir dos bytes derivados

Performance:

- A senha deve ser gerada e estar disponível em no máximo 500 ms após a solicitação, em condições normais de uso do dispositivo.

---

## Política de Senhas

Por padrão:

Comprimento:
12 caracteres

Obrigatório:

- 1 letra maiúscula
- 1 letra minúscula
- 1 número
- 1 símbolo

Conjunto de caracteres:

ABCDEFGHIJKLMNOPQRSTUVWXYZ

abcdefghijklmnopqrstuvwxyz

0123456789

!@#$%&*+-_=?[]{}\/

---

## Configurações de Senha

O usuário poderá escolher:

Comprimento:

- 5 a 32 caracteres a critério do usuário (valor padrão 12), um campo de input livre que permita ao usuário informar o tamanho da senha de saída.

Opções:
(todos ativados por padrão)
- Incluir símbolos
- Incluir números
- Incluir letras maiúsculas
- Incluir letras minúsculas

Forma de apresentaçao: 
- Os campos de configuração devem ser ocultados sendo possivel espandir para que seram alterados. 

Observação:

As opções configuradas devem continuar produzindo resultados determinísticos.

---

## Funcionalidades MVP

### F001 - Informar Senha Mestra

O usuário deve poder inserir uma senha mestre.

---

### F002 - Informar Parâmetro

O usuário deve poder informar um identificador.

---

### F003 - Gerar Senha

O sistema deve gerar uma senha determinística.

---

### F004 - Copiar Senha

O usuário deve poder copiar a senha gerada para a área de transferência.

---

### F005 - Exibir Força da Senha

O sistema deve indicar:

- Fraca
- Média
- Forte
- Muito Forte

---

### F006 - Mostrar/Ocultar Senha Mestra

A senha mestra deve possuir opção de visualização.

---

## Funcionalidades Futuras

### F007 - Favoritos

Salvar localmente parâmetros frequentes.

Exemplos:

- gmail.com
- github.com
- microsoft.com

Sem armazenar senhas.
O placeholder do campo dever conter e.g. ou ex.: 

---

### F008 - Perfis

Permitir múltiplas configurações.

Exemplo:

Perfil Corporativo
Perfil Bancário
Perfil Redes Sociais

---

### F009 - QR Code

Exportação e importação das configurações do aplicativo.

---

### F010 - Modo Compatibilidade Hashapass

Implementar geração compatível com:

HMAC-SHA1
Base64
8 caracteres

---

### F011 - Histórico Local

O sistema deverá armazenar localmente os últimos 20 parâmetros utilizados.

A Senha Mestra não deve ser armazenada.

---

## Requisitos Não Funcionais

### RNF001

O aplicativo deve funcionar sem internet.

---

### RNF002

Nenhuma senha deve ser enviada para servidores e isso dever ser verificavel.

---

### RNF003

Nenhum dado sensível deve ser registrado em logs.

---

### RNF004

O aplicativo deve funcionar em:

- Chrome
- Edge
- Android

---

### RNF005

O aplicativo deve iniciar em menos de 2 segundos em dispositivos modernos.

---

## Interface

### Tela Principal

Campos:

[ Parâmetro ]

[ Senha Mestra ]


[ Comprimento ]

[ Gerar Senha ]

Resultado:

[ Senha Gerada ]

[ Copiar ]

---

## Tecnologias

Frontend:

Flutter

Linguagem:

Dart

Criptografia:

crypto package

Plataformas:

- Android
- Web

Hospedagem Web:

GitHub Pages

---

## Política de Privacidade

O Senhador não coleta:

- senhas
- parâmetros
- dados pessoais
- localização
- telemetria sensível

Todas as operações criptográficas ocorrem localmente no dispositivo do usuário.

---

## Roadmap

### Versão 1.0

- Geração determinística
- Copiar senha
- Configuração de tamanho
- Web
- Android

### Versão 1.1

- Indicador de força
- Melhorias visuais quando no celular com teclado aberto


### Versão 1.2

- QR Code
- Perfis

### Versão 2.0

- PWA avançado
- Sincronização opcional criptografada

---

## Missão

Permitir que qualquer pessoa gere senhas fortes, únicas e previsíveis para seus serviços utilizando apenas uma senha mestre, sem depender de armazenamento em nuvem ou bancos de dados de senhas.

## Requisitos de Performance

### RP001 - Tempo de Resposta

A geração de senha deve ser concluída em menos de meio segundo em dispositivos modernos.

Meta:

< 500 ms

Objetivo Ideal:

< 200 ms

---

### RP002 - Feedback Visual

Sempre que a geração da senha estiver em processamento, o usuário deverá receber feedback visual.

A interface deve exibir:

- Indicador de carregamento
- Estado "Processando"

O indicador deve permanecer visível até a conclusão da geração da senha.

---

### RP003 - Interface Responsiva

Durante o processamento:

- A interface não deve travar
- O aplicativo deve permanecer responsivo
- O usuário deve perceber que a operação está em andamento