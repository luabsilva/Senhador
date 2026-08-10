# DECISIONS.md

# Registro de Decisões Arquiteturais

Este documento registra as principais decisões técnicas, arquiteturais e de produto tomadas durante o desenvolvimento do Senhador.

Seu objetivo é preservar o contexto das decisões para facilitar futuras manutenções, evoluções e contribuições.

---

# ADR-001 - Nome do Projeto

Status: Aprovada

Data: 2026-08-07

## Decisão

O nome oficial do projeto será:

Senhador

## Contexto

O projeto precisava de um nome:

- simples
- memorável
- em português
- alinhado ao propósito da aplicação

Foram avaliadas alternativas:

- PassForge
- MestrePass
- Chave Mestra
- PassSeed
- Gerador de Senha Mestra

## Justificativa

"Senhador" é um nome original, fácil de lembrar e comunica imediatamente a relação com senhas.

Também oferece potencial para identidade visual própria.

## Consequências

Positivas:

- Nome simples
- Fácil divulgação
- Identidade brasileira

Negativas:

- Pode exigir descrição complementar para novos usuários

---

# ADR-002 - Flutter como Plataforma Principal

Status: Aprovada

Data: 2026-08-07

## Decisão

Utilizar Flutter como tecnologia principal.

## Contexto

O aplicativo deve funcionar em:

- Web
- Android

Com possibilidade futura de:

- iOS
- Windows
- Linux

## Alternativas Avaliadas

### React + TypeScript

Vantagens:

- Excelente para Web

Desvantagens:

- Necessidade de soluções adicionais para mobile

### Flutter

Vantagens:

- Código único
- Android nativo
- Web
- Excelente experiência multiplataforma

## Justificativa

Flutter proporciona menor custo de manutenção e maior reaproveitamento de código.

## Consequências

Positivas:

- Base única de código
- Desenvolvimento mais rápido
- Experiência consistente

Negativas:

- Tamanho inicial da aplicação maior que soluções web puras

---

# ADR-003 - Aplicação Offline First

Status: Aprovada

Data: 2026-08-07

## Decisão

O Senhador será desenvolvido seguindo o princípio Offline First.

## Contexto

O aplicativo não depende de dados externos para gerar senhas.

Toda lógica pode ser executada localmente.

## Justificativa

Permite:

- maior privacidade
- maior segurança
- disponibilidade total mesmo sem internet

## Consequências

Positivas:

- Nenhuma dependência de servidores
- Sem custos de infraestrutura

Negativas:

- Recursos de sincronização exigirão implementação específica no futuro

---

# ADR-004 - Nenhum Armazenamento de Senhas

Status: Aprovada

Data: 2026-08-07

## Decisão

O Senhador não armazenará:

- Senha Mestra
- Senhas Geradas

## Contexto

O objetivo do projeto é eliminar a necessidade de cofres de senha tradicionais.

## Justificativa

Redução da superfície de ataque.

Se o dispositivo for comprometido, não existirá banco de dados contendo credenciais armazenadas pelo aplicativo.

## Consequências

Positivas:

- Maior segurança
- Menor risco de vazamento

Negativas:

- O usuário deve lembrar sua Senha Mestra

---

# ADR-005 - Senhas Determinísticas

Status: Aprovada

Data: 2026-08-07

## Decisão

As senhas serão geradas de forma determinística.

## Contexto

Mesmas entradas devem produzir exatamente a mesma saída.

Exemplo:

Senha Mestra:
MinhaSenhaMestra2026

Parâmetro:
gmail.com

Resultado:
Sempre o mesmo

## Justificativa

Permite recriar a senha em qualquer dispositivo sem necessidade de armazenamento.

## Consequências

Positivas:

- Simplicidade
- Portabilidade
- Sem sincronização

Negativas:

- Alterar a Senha Mestra altera todas as senhas derivadas

---

# ADR-006 - PBKDF2-SHA256

Status: Aprovada

Data: 2026-08-07

## Decisão

Utilizar PBKDF2-SHA256 como mecanismo principal de derivação criptográfica.

## Configuração Inicial

Hash:

SHA-256

Iterações:

100.000

Salt:

Parâmetro informado pelo usuário

## Alternativas Avaliadas

### HMAC-SHA1

Utilizado pelo Hashapass original.

Limitação:

- algoritmo mais antigo
- menor robustez para novos projetos

### PBKDF2-SHA256

Mais adequado para aplicações modernas.

## Justificativa

Oferece maior resistência contra ataques de força bruta.

## Consequências

Positivas:

- Segurança moderna
- Compatibilidade ampla

Negativas:

- Processamento ligeiramente maior

---

# ADR-008 - GitHub Pages como Hospedagem

Status: Aprovada

Data: 2026-08-07

## Decisão

Hospedar a versão web no GitHub Pages.

## Justificativa

- Gratuito
- Confiável
- Fácil integração com GitHub Actions
- Compatível com Flutter Web

## Consequências

Positivas:

- Deploy automatizado
- Baixo custo operacional

Negativas:

- Hospedagem apenas estática

---

# ADR-009 - Política de Privacidade Máxima

Status: Aprovada

Data: 2026-08-07

## Decisão

O Senhador não coletará:

- Nome
- E-mail
- Telemetria de uso
- Senhas
- Parâmetros
- Localização

## Justificativa

Privacidade é um dos pilares centrais do projeto.

## Consequências

Positivas:

- Confiança do usuário
- Simplicidade regulatória

Negativas:

- Menor capacidade de análise de uso

---

# ADR-010 - Código Aberto

Status: Proposta

Data: 2026-08-07

## Decisão

O projeto deverá ser disponibilizado como software open source.

## Justificativa

A transparência aumenta a confiança em aplicações relacionadas à segurança.

Os usuários devem ser capazes de auditar o algoritmo utilizado para gerar suas senhas.

## Consequências

Positivas:

- Transparência
- Comunidade
- Auditoria independente

Negativas:

- Necessidade de maior disciplina na documentação

## ADR-013

Status : Aprovada

Data: 2026-08-08

## Decisão

Introdução de histórico local.

Apenas parâmetros serão armazenados.
Senhas continuarão não persistidas.

## Justificativa

Facilitar o acesso ao parâmetos usados com mais frequencia


---

# Princípios Permanentes

O Senhador deverá sempre seguir os seguintes princípios:

1. Offline First
2. Privacy by Design
3. Security First
4. Open by Default
5. Simplicidade acima da complexidade
6. Nenhuma senha armazenada
7. Nenhuma senha transmitida
8. Mesma entrada, mesma saída
9. Compatibilidade multiplataforma
10. Transparência total do algoritmo
