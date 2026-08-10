import 'dart:convert';
import 'dart:typed_data';

import 'hmac_sha256.dart';
import 'pbkdf2.dart';
import 'deterministic_shuffle.dart';

/// Gera senhas determinísticas usando PBKDF2-SHA256.
///
/// A camada crypto segue a especificação e a arquitetura do projeto:
/// PBKDF2-SHA256 -> material criptográfico -> HMAC-SHA256 -> derivação de caracteres.
class PasswordGenerator {
  static const int _iterations = 100000;
  static const int _derivedKeyBytes = 32;
  static const int _defaultLength = 16;

  static const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String numbers = '0123456789';
  static const String symbols = '!@#\$%&*+-_=?';

  /// Gera a senha final a partir da senha mestra e do parâmetro.
  static String generatePassword({
    required String masterPassword,
    required String parameter,
    int length = _defaultLength,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    if (masterPassword.isEmpty) {
      throw ArgumentError.value(masterPassword, 'masterPassword',
          'A senha mestra não pode ser vazia.');
    }
    if (parameter.isEmpty) {
      throw ArgumentError.value(
          parameter, 'parameter', 'O parâmetro não pode ser vazio.');
    }
    if (length <= 0) {
      throw ArgumentError.value(
          length, 'length', 'O comprimento da senha deve ser maior que zero.');
    }

    final allowedSets = <String>[];
    if (includeUppercase) allowedSets.add(uppercase);
    if (includeLowercase) allowedSets.add(lowercase);
    if (includeNumbers) allowedSets.add(numbers);
    if (includeSymbols) allowedSets.add(symbols);

    if (allowedSets.isEmpty) {
      allowedSets
        ..add(uppercase)
        ..add(lowercase)
        ..add(numbers)
        ..add(symbols);
    }

    if (length < allowedSets.length) {
      throw ArgumentError.value(
        length,
        'length',
        'O comprimento mínimo é ${allowedSets.length} para as categorias selecionadas.',
      );
    }

    final derivedKey = Pbkdf2Sha256.deriveKey(masterPassword, parameter,
        iterations: _iterations, outputBytes: _derivedKeyBytes);
    final entropySeed = HmacSha256.compute(derivedKey, utf8.encode(parameter));
    final entropy =
        _expandEntropy(entropySeed, length + allowedSets.length + 16);

    final fullCharset = allowedSets.join();
    final passwordChars = <String>[];
    var sourceIndex = 0;

    for (final charset in allowedSets) {
      final index = _byteToIndex(entropy, sourceIndex++, charset.length);
      passwordChars.add(charset[index]);
    }

    for (var i = passwordChars.length; i < length; i++) {
      final index = _byteToIndex(entropy, sourceIndex++, fullCharset.length);
      passwordChars.add(fullCharset[index]);
    }

    final shuffled = DeterministicShuffle.shuffle(passwordChars, entropy);
    return shuffled.join();
  }

  static Uint8List _expandEntropy(Uint8List seed, int requiredBytes) {
    if (requiredBytes <= seed.length) {
      return Uint8List.fromList(seed.sublist(0, requiredBytes));
    }

    final generated = <int>[...seed];
    var counter = 0;
    while (generated.length < requiredBytes) {
      final block = HmacSha256.compute(seed, [counter]);
      generated.addAll(block);
      counter++;
    }

    return Uint8List.fromList(generated.sublist(0, requiredBytes));
  }

  static int _byteToIndex(Uint8List source, int index, int modulus) {
    if (modulus <= 0) return 0;
    final byte = source[index % source.length];
    return byte % modulus;
  }
}
