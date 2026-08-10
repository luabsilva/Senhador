# Projeto

Senhador

# Objetivo

Gerador determinístico de senhas seguras.

# Arquitetura

Consultar:

docs/ARCHITECTURE.md

# Regras

- Flutter
- Dart
- Offline First
- Não armazenar senha mestre
- Não armazenar senha gerada
- Não utilizar APIs externas
- Não utilizar backend
- Seguir Clean Architecture simplificada

# Segurança

Nunca:

- registrar senha em logs
- salvar senha em disco
- transmitir dados sensíveis

# Algoritmo

PBKDF2-SHA256

100.000 iterações

Salt = parâmetro

# Prioridade

Segurança > Simplicidade > Performance