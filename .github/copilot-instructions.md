# Senhador Copilot Instructions

## Commands

Run these from the repository root:

```bash
flutter pub get
flutter analyze
flutter test
flutter test test/password_generator_test.dart
flutter test test/password_generator_test.dart --name "mesmas entradas geram sempre o mesmo resultado"
flutter run -d chrome
flutter build web --release
flutter build apk --release
```

`analysis_options.yaml` uses `flutter_lints`. Flutter 3.x / Dart 3.x are the supported toolchain baseline.

## Architecture

The app is a Flutter web/Android client with no backend or external API. `main.dart` creates `SenhadorApp`, which applies `CyberTheme` and displays `HomePage`.

The password-generation path is deliberately layered:

```text
HomePage -> GeneratePasswordUseCase -> PasswordGenerator
           PasswordRequest             PBKDF2-SHA256 -> HMAC-SHA256
                                      -> deterministic shuffle
```

- `lib/domain/entities/` contains immutable request, policy/category, and result models. Keep this layer independent of Flutter.
- `lib/application/usecases/generate_password_use_case.dart` runs crypto through `compute` so PBKDF2 does not block the UI and calculates the 1--4 strength score.
- `lib/core/crypto/` is the compatibility-sensitive algorithm implementation. It derives a 32-byte key with PBKDF2-SHA256 (100,000 iterations; the parameter is the salt), expands HMAC-SHA256 entropy, guarantees selected character categories, then shuffles deterministically.
- `HomePage` owns form state and invokes the use case asynchronously. Its optional `generatePassword` callback is the widget-test seam; retain it when changing generation behavior.
- `HistoryService` is the sole current persistence point. It stores a trimmed, de-duplicated MRU list of up to 20 parameters in `shared_preferences`.
- `presentation/widgets/` provides reusable visual pieces; `presentation/themes/` centralizes the cyber UI palette and typography.

## Project-Specific Conventions

- Treat generated password output as a stable compatibility contract: same master password, parameter, length, and character-category flags must always yield the same password. Do not change crypto constants, charset ordering, entropy expansion, or shuffle behavior without updating regression coverage and explicitly treating it as a breaking change.
- The master password and generated password must never be logged, persisted, sent over the network, or exposed by `toString()`. `PasswordRequest.toString()` intentionally includes only the parameter and options; `GeneratedPassword.toString()` intentionally omits its value.
- Persist only recent parameters. Do not extend `shared_preferences` use to master passwords or generated passwords.
- When every character toggle is off, `PasswordGenerator` deliberately falls back to all four categories. When categories are selected, reject lengths shorter than their count.
- UI changes must preserve the processing state: clear stale output, show `LinearProgressIndicator`, and disable generation until the async operation completes.
- Tests use `flutter_test`; widget tests initialize `SharedPreferences.setMockInitialValues({})` and inject `HomePage.generatePassword` to avoid real crypto timing. Keep performance tests warmed up and enforce the existing 500 ms target.
- Use `snake_case.dart` files, PascalCase types, and camelCase members. User-facing UI and documentation are primarily Portuguese.
