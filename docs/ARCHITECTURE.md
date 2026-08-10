# Arquitetura do Projeto Senhador

## Objetivo

Definir a arquitetura de software do aplicativo Senhador, garantindo:

- Simplicidade
- Facilidade de manutenção
- Baixo acoplamento
- Testabilidade
- Escalabilidade futura

---

# Visão Geral

O Senhador será desenvolvido utilizando Flutter e seguirá uma arquitetura em camadas.

Fluxo principal:

UI
↓
Application
↓
Domain
↓
Crypto
↓
Resultado

---

# Estrutura de Pastas

lib/
│
├── main.dart
│
├── core/
│   ├── crypto/
│   ├── constants/
│   ├── utils/
│   └── exceptions/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── application/
│   └── services/
│
├── infrastructure/
│   ├── storage/
│   └── clipboard/
│
├── presentation/
│   ├── pages/
│   ├── widgets/
│   ├── viewmodels/
│   └── themes/
│
└── shared/
    └── models/

---

# Camadas

## Presentation

Responsável pela interface do usuário.

Contém:

- Páginas
- Widgets
- Temas
- Navegação
- Estados da tela

Exemplos:

pages/
├── home_page.dart
├── settings_page.dart
└── about_page.dart

---

## Application

Coordena os casos de uso da aplicação.

Não contém lógica de interface nem detalhes criptográficos.

Exemplo:

GeneratePasswordService

Responsabilidade:

Receber:

- Senha Mestra
- Parâmetro
- Configurações

e solicitar a geração da senha.

---

## Domain

Contém as regras de negócio.

É a camada mais importante da aplicação.

Não deve depender de Flutter.

Exemplos:

entities/
├── PasswordPolicy.dart
├── PasswordRequest.dart
└── GeneratedPassword.dart

---

## Core

Contém funcionalidades compartilhadas.

Exemplos:

crypto/
├── password_generator.dart
├── pbkdf2.dart
└── deterministic_shuffle.dart

constants/
├── charsets.dart
└── app_constants.dart

---

## Infrastructure

Implementações concretas.

Exemplos:

storage/
├── local_storage.dart

clipboard/
├── clipboard_service.dart

A camada Domain nunca deve conhecer estas implementações.

---

# Fluxo de Geração

Usuário informa:

- Senha Mestra
- Parâmetro

↓

GeneratePasswordService

↓

PasswordGenerator

↓

PBKDF2

↓

Derivação de caracteres

↓

Embaralhamento determinístico

↓

Senha Final

↓

UI

---

# Modelo de Domínio

## PasswordRequest

Representa uma solicitação de geração.

Campos:

- masterPassword
- parameter
- length
- includeUppercase
- includeLowercase
- includeNumbers
- includeSymbols

---

## PasswordPolicy

Define a política da senha.

Campos:

- tamanho mínimo
- tamanho máximo
- categorias permitidas

---

## GeneratedPassword

Representa a senha produzida.

Campos:

- value
- strengthScore

---

# Criptografia

## Algoritmo Principal

PBKDF2-SHA256

Iterações:

100.000

Salt:

Parâmetro

Saída:

256 bits

---

## Geração da Senha

Regras:

- Determinística
- Repetível
- Sem aleatoriedade externa

Mesmas entradas geram exatamente a mesma saída.

---

## Categorias de Caracteres

Maiúsculas:

ABCDEFGHIJKLMNOPQRSTUVWXYZ

Minúsculas:

abcdefghijklmnopqrstuvwxyz

Números:

0123456789

Símbolos:

!@#$%&*+-_=?[]{}\/

---

# Estado da Aplicação

Inicial:

- Sem senha gerada

Após geração:

- Senha disponível
- Botão copiar habilitado

Após limpeza:

- Campos vazios

---

# Persistência Local

Versão 1.0

Nenhum dado sensível persistido.

Permitido armazenar apenas:

- Tema
- Comprimento padrão
- Preferências visuais

Proibido armazenar:

- Senha mestre
- Senha gerada

---

# Testes

## Testes Unitários

Cobrir:

PasswordGenerator

PBKDF2

Shuffle determinístico

Políticas de senha

---

## Testes de Integração

Validar:

Interface → Serviço → Resultado

---

## Testes de Regressão

Garantir:

Mesma entrada

↓

Mesmo resultado

Sempre

---

# Estratégia de Evolução

Versão 1.0

- Web
- Android
- Senha determinística
- Copiar senha

---

Versão 1.1

- Favoritos
- Indicador de força
- melhorias visuais

---

Versão 1.2

- Perfis
- QR Code

---

Versão 2.0

- PWA Avançado


---

# Princípios Arquiteturais

## Offline First

O aplicativo deve funcionar sem conexão com a internet.

---

## Privacy by Design

Nenhum dado sensível deve sair do dispositivo.

---

## Security First

Toda decisão de arquitetura deve priorizar segurança.

---

## Simplicidade

O código deve ser compreensível para qualquer desenvolvedor Flutter.

---

# Diagrama Simplificado

┌───────────────────────┐
│       Interface       │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│   Application Layer   │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│    Domain Layer       │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│     Crypto Layer      │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│   Generated Password  │
└───────────────────────┘

# Requisitos de Performance

## Geração de Senha

A geração deve ocorrer de forma assíncrona.

A interface não deve bloquear a thread principal.

Fluxo:

Usuário Clica em Gerar

↓

Loading

↓

PBKDF2

↓

Geração da Senha

↓

Resultado

## Isolates

Caso o PBKDF2 com 100.000 iterações produza tempo superior a 1 segundo em dispositivos mais lentos, a execução deverá ser movida para um Isolate.

Objetivos:

- evitar travamento da UI
- garantir fluidez
- melhorar experiência do usuário

## Novo Serviço

HistoryService

Responsável por armazenar os parâmetros recentes.