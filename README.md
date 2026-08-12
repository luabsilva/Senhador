# Cyber_Key

> Gerador determinístico de senhas seguras em Flutter.

---

## Visão Geral

Cyber_Key é um aplicativo de código aberto para gerar senhas fortes e previsíveis com segurança local.

A partir de uma senha mestra e um parâmetro (site, serviço ou aplicação), o Cyber_Key produz uma senha única e reprodutível. Não há armazenamento de senhas nem transmissão de dados sensíveis para servidores.

---

## Por que usar o Cyber_Key?

- Segurança offline: todas as operações acontecem no dispositivo.
- Privacidade total: não há envio de dados para a nuvem.
- Reprodutibilidade: a mesma combinação gera sempre a mesma senha.
- Simplicidade: interface clara e foco em uso rápido.

---

## Como funciona

1. Informe a senha mestra.
2. Digite o parâmetro do serviço.
3. Ajuste tamanho e categorias de caracteres.
4. Gere e copie a senha com um toque.

### Tecnologia de geração

- PBKDF2-SHA256 para derivação segura
- HMAC-SHA256 para expansão de entropia
- Embaralhamento determinístico para distribuição uniforme

### Resultado

- Senha forte e compatível com requisitos modernos
- Força estimada exibida para validação imediata
- Histórico de parâmetros recentes para acesso rápido

---

## Recursos principais

- Geração determinística de senhas
- Histórico de parâmetros recentes
- Controle do comprimento da senha
- Inclusão seletiva de maiúsculas, minúsculas, números e símbolos
- Exibição de força estimada da senha
- Cópia automática para área de transferência
- Suporte a Flutter Web e Android

---

## Segurança e privacidade

Cyber_Key foi projetado com foco em:

- Offline First
- Privacy by Design
- Security First

O aplicativo:

- ✅ Não armazena senhas
- ✅ Não armazena a senha mestra
- ✅ Não transmite dados sensíveis
- ✅ Não utiliza backend
- ✅ Não depende de internet

---

## Tecnologias usadas

- Flutter
- Dart
- PBKDF2-SHA256
- `shared_preferences`
- Flutter Web
- Android

---

## Instalação

### Pré-requisitos

- Flutter 3.x
- Dart SDK compatível

### Passos

```bash
git clone https://github.com/luabsilva/cyber_key.git
cd cyber_key
flutter pub get
```

### Executar localmente

```bash
flutter run -d chrome
```

```bash
flutter run
```

---

## Build para produção

### Android

```bash
flutter build apk --release
```

### Web

```bash
flutter build web --release
```

---

## Documentação adicional

- `SPECIFICATION.md`
- `ARCHITECTURE.md`
- `DECISIONS.md`
- `ROADMAP.md`
- `CONTRIBUTING.md`

---

## Missão do projeto

Permitir a geração de senhas seguras, consistentes e fáceis de usar sem depender de cofres, sincronização ou serviços externos.

---

## Licença

MIT