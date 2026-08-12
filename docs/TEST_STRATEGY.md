# TEST_STRATEGY.md

# Estratégia de Testes

## Visão Geral

Este documento define a estratégia de testes do projeto Cyber_Key.

O objetivo é garantir:

- Confiabilidade
- Segurança
- Reprodutibilidade
- Qualidade de software
- Ausência de regressões

Como o Cyber_Key é um aplicativo relacionado à geração de credenciais, a validação do algoritmo é considerada crítica.

---

# Objetivos

O processo de testes deve garantir que:

- Mesmas entradas gerem sempre os mesmos resultados
- Entradas diferentes gerem resultados diferentes
- As políticas de senha sejam respeitadas
- Nenhum dado sensível seja armazenado
- Nenhum dado sensível seja transmitido
- As funcionalidades operem corretamente em Web e Android

---

# Pirâmide de Testes

                 UI Tests
                     ▲
                     │
          Integration Tests
                     ▲
                     │
             Unit Tests

Distribuição recomendada:

- 70% Unit Tests
- 20% Integration Tests
- 10% UI Tests

---

# Tipos de Teste

## Testes Unitários

Validam componentes isolados.

Ferramenta:

```bash
flutter test
```

Cobertura mínima:

80%

---

# PasswordGenerator

Arquivo:

```text
lib/core/crypto/password_generator.dart
```

## Cenário 1

Entrada:

```text
Senha Mestra:
MinhaSenhaMestra2026

Parâmetro:
gmail.com
```

Resultado:

```text
Sempre igual
```

Validação:

```text
PASS
```

---

## Cenário 2

Entradas diferentes

```text
gmail.com
github.com
```

Devem gerar:

```text
Resultados diferentes
```

---

## Cenário 3

Comprimento configurado

Solicitação:

```text
16 caracteres
```

Verificar:

```text
Senha.length == 16
```

---

## Cenário 4

Comprimento mínimo

Solicitação:

```text
12 caracteres
```

Verificar:

```text
Senha.length == 12
```

---

## Cenário 5

Comprimento máximo

Solicitação:

```text
32 caracteres
```

Verificar:

```text
Senha.length == 32
```

---

## Cenário 6

Latência de geração

Solicitação:

```text
Geração de senha padrão
```

Verificar:

```text
Senha gerada em no máximo 500 ms
```

---

# Política de Complexidade

A senha deve conter:

- Maiúscula
- Minúscula
- Número
- Símbolo

---

## Teste

Validar:

```text
Possui letra maiúscula
```

---

## Teste

Validar:

```text
Possui letra minúscula
```

---

## Teste

Validar:

```text
Possui número
```

---

## Teste

Validar:

```text
Possui símbolo
```

---

# Testes de Segurança

## Não armazenar Senha Mestra

Verificar:

```text
Nenhum armazenamento em:
- SharedPreferences
- Arquivos locais
- Banco de dados
```

Resultado esperado:

```text
Nenhum dado persistido
```

---

## Não armazenar Senha Gerada

Resultado esperado:

```text
Nenhum dado persistido
```

---

## Não registrar Logs

Verificar:

```dart
print(masterPassword);
```

Não permitido.

Verificar:

```dart
print(password);
```

Não permitido.

---

## Não transmitir dados

Verificar:

```text
Nenhuma requisição HTTP para geração da senha.
```

Resultado esperado:

```text
0 chamadas de rede
```

---

# Testes de Regressão

## Determinismo

A seguinte entrada será utilizada como referência.

Senha Mestra:

```text
MinhaSenhaMestra2026
```

Parâmetro:

```text
gmail.com
```

Comprimento:

```text
16
```

A saída deve permanecer idêntica entre versões do aplicativo.

Objetivo:

Garantir compatibilidade.

---

# Testes de Integração

## Fluxo Principal

Usuário preenche:

- Senha Mestra
- Parâmetro

↓

Pressiona "Gerar"

↓

Senha é exibida

↓

Botão Copiar habilitado

Resultado esperado:

```text
Fluxo concluído sem erros
```

---

## Copiar Senha

Fluxo:

Gerar Senha

↓

Copiar

↓

Área de transferência

Resultado esperado:

```text
Senha copiada corretamente
```

---

## Mostrar/Ocultar Senha

Fluxo:

Usuário toca no ícone

↓

Campo alterna

Resultado esperado:

```text
Senha exibida/ocultada corretamente
```

---

# Testes de Interface

## Tela Inicial

Verificar presença dos componentes:

- Campo Senha Mestra
- Campo Parâmetro
- Seleção de tamanho
- Botão Gerar
- Campo Resultado

---

## Tema Escuro

Verificar:

```text
Todos os componentes visíveis
```

---

## Tema Claro

Verificar:

```text
Todos os componentes visíveis
```

---

# Testes de Compatibilidade

## Navegadores

Suportados:

- Chrome
- Edge

Validar:

```text
Geração correta
```

---

## Android

Versão mínima:

```text
Android 8+
```

Validar:

```text
Geração correta
```

---

# Testes de Performance

## Tempo de Geração

Objetivo:

```text
< 500 ms
```

Dispositivo médio.

---

## Inicialização

Objetivo:

```text
< 2 segundos
```

---

## Consumo de Memória

Objetivo:

```text
Menor que 100 MB
```

Durante uso normal.

---

# Cobertura Mínima

Meta:

```text
90%
```

Ideal:

```text
98%
```

---

# Critérios para Aprovação de Release

Uma versão somente poderá ser publicada se:

✅ Build Android concluído

✅ Build Web concluído

✅ Todos os testes unitários aprovados

✅ Todos os testes de integração aprovados

✅ Nenhuma falha crítica de segurança

✅ Nenhuma regressão no algoritmo

✅ Cobertura mínima atingida

---

# Casos de Teste Críticos

## CT-001

Gerar senha com entradas válidas.

Resultado esperado:

```text
Senha gerada.
```

---

## CT-002

Gerar senha duas vezes com a mesma entrada.

Resultado esperado:

```text
Mesma senha.
```

---

## CT-003

Alterar parâmetro.

Resultado esperado:

```text
Senha diferente.
```

---

## CT-004

Alterar senha mestra.

Resultado esperado:

```text
Senha diferente.
```

---

## CT-005

Copiar senha.

Resultado esperado:

```text
Área de transferência atualizada.
```

---

# Definição de Pronto (Definition of Done)

Uma funcionalidade será considerada concluída quando:

- Código implementado
- Testes unitários criados
- Testes aprovados
- Revisão realizada
- Sem logs sensíveis
- Sem armazenamento indevido
- Documentação atualizada

# Testes de Performance

## TP001

Entrada:

Senha Mestra:
MinhaSenhaMestra2026

Parâmetro:
gmail.com

Resultado esperado:

Tempo < 1/2 segundo

---

## TP002

O loading deve ser exibido durante o processamento.

Resultado esperado:

✓ Loading visível

---

## TP003

A interface permanece responsiva enquanto a senha está sendo gerada.

Resultado esperado:

✓ Sem congelamento da UI