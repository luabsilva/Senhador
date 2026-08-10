# Contribuindo

Obrigado por contribuir com o Senhador.

## Filosofia

Antes de qualquer contribuição, considere:

1. Segurança
2. Privacidade
3. Simplicidade

Tudo o que for adicionado deve respeitar esses princípios.

---

## Desenvolvimento

### Instalar dependências

```bash
flutter pub get
```

### Executar

```bash
flutter run -d chrome
```

---

## Convenções

### Nomes de arquivos

Utilizar:

```text
snake_case
```

Exemplo:

```text
password_generator.dart
```

---

### Classes

Utilizar:

```text
PascalCase
```

Exemplo:

```dart
class PasswordGenerator
```

---

### Métodos

Utilizar:

```text
camelCase
```

Exemplo:

```dart
generatePassword()
```

---

## Pull Requests

Toda alteração deve:

- Compilar
- Possuir testes quando aplicável
- Não reduzir segurança
- Não armazenar dados sensíveis

---

## Regras de Ouro

Nunca:

- Registrar senha mestre em logs
- Registrar senha gerada em logs
- Enviar credenciais para APIs
- Persistir credenciais localmente