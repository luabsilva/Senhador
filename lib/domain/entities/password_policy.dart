import 'password_character_category.dart';

/// Define a política de senha usada pela aplicação.
///
/// Implementada como entidade de domínio imutável.
class PasswordPolicy {
  final int minLength;
  final int maxLength;
  final Set<PasswordCharacterCategory> allowedCategories;

  PasswordPolicy({
    required this.minLength,
    required this.maxLength,
    required this.allowedCategories,
  })  : assert(minLength > 0, 'minLength must be greater than zero.'),
        assert(maxLength >= minLength, 'maxLength must be >= minLength.'),
        assert(
            allowedCategories.isNotEmpty, 'allowedCategories cannot be empty.');

  bool get allowsUppercase =>
      allowedCategories.contains(PasswordCharacterCategory.uppercase);
  bool get allowsLowercase =>
      allowedCategories.contains(PasswordCharacterCategory.lowercase);
  bool get allowsNumbers =>
      allowedCategories.contains(PasswordCharacterCategory.numbers);
  bool get allowsSymbols =>
      allowedCategories.contains(PasswordCharacterCategory.symbols);
}
