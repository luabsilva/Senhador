# Senhador

> Gerador determinístico de senhas seguras.

https://img.shields.io/badge/Flutter-3.x-blue.svg]()
https://img.shields.io/badge/License-MIT-green.svg]()
https://img.shields.io/badge/Platform-Web%20%7C%20Android-orange.svg]()

## Visão Geral

O Senhador é um aplicativo open source para geração determinística de senhas seguras.

Ao invés de armazenar senhas em cofres ou serviços na nuvem, o Senhador gera senhas sob demanda a partir de:

- Senha Mestra
- Parâmetro (site, serviço ou aplicação)

A mesma combinação sempre produz exatamente a mesma senha.

Exemplo:

Senha Mestra:

MinhaSenhaMestra2026

Parâmetro:

gmail.com

Resultado:

Q@9mL2#rX7!cNp4&

Nenhuma senha é armazenada.

Nenhuma senha é enviada para servidores.

Todas as operações ocorrem localmente no dispositivo.

---

## Objetivos

O projeto foi criado para oferecer:

- Privacidade máxima
- Simplicidade de uso
- Segurança moderna
- Funcionamento offline
- Reprodutibilidade das senhas
- Independência de serviços na nuvem

---

## Como Funciona

Entrada:

Senha Mestra
+
Parâmetro

↓

PBKDF2-SHA256

↓

Derivação determinística

↓

Senha Forte

Mesmas entradas:

✅ Mesmo resultado

Entradas diferentes:

✅ Resultado diferente

---

## Funcionalidades

### Versão 1.0

- Gerar senhas determinísticas
- Copiar senha
- Configurar tamanho da senha
- Mostrar/Ocultar senha mestre
- Tema Claro/Escuro
- Flutter Web
- Android

### Planejado

- Favoritos
- Perfis
- Indicador de força
- QR Code
- Compatibilidade Hashapass

---

## Tecnologias

- Flutter
- Dart
- Flutter Web
- Android
- PBKDF2-SHA256

---

## Segurança

O Senhador segue os princípios:

- Offline First
- Privacy by Design
- Security First

O aplicativo:

✅ Não armazena senhas

✅ Não armazena a senha mestre

✅ Não transmite dados sensíveis

✅ Não utiliza backend

✅ Não depende de internet

---

## Documentação

- SPECIFICATION.md
- ARCHITECTURE.md
- DECISIONS.md
- ROADMAP.md
- CONTRIBUTING.md

---

## Instalação

### Ambiente

```bash
flutter doctor
```

### Clonar projeto

```bash
git clone https://github.com/SEU_USUARIO/senhador.git
```

```bash
cd senhador
```

### Dependências

```bash
flutter pub get
```

### Executar Web

```bash
flutter run -d chrome
```

### Executar Android

```bash
flutter run
```

---

## Build

### Android

```bash
flutter build apk --release
```

### Web

```bash
flutter build web --release
```

---

## Licença

MIT

---

## Missão

Permitir que qualquer pessoa gere senhas fortes, seguras e reproduzíveis utilizando apenas uma senha mestre, sem bancos de dados, sincronização ou dependência de terceiros.