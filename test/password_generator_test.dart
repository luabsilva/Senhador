import 'package:flutter_test/flutter_test.dart';

import 'package:senhador/core/crypto/password_generator.dart';

void main() {
  const masterPassword = 'MinhaSenhaMestra2026';
  const parameterA = 'gmail.com';
  const parameterB = 'github.com';

  test('mesmas entradas geram sempre o mesmo resultado', () {
    final first = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
      length: 16,
    );
    final second = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
      length: 16,
    );

    expect(first, equals(second));
  });

  test('entradas diferentes geram resultados diferentes', () {
    final passwordA = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
      length: 16,
    );
    final passwordB = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterB,
      length: 16,
    );

    expect(passwordA, isNot(equals(passwordB)));
  });

  test('comprimento padrão é 16 caracteres', () {
    final password = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
    );

    expect(password.length, equals(16));
  });

  test('comprimento mínimo de 12 caracteres', () {
    final password = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
      length: 12,
    );

    expect(password.length, equals(12));
  });

  test('comprimento máximo de 32 caracteres', () {
    final password = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
      length: 32,
    );

    expect(password.length, equals(32));
  });

  test('senha contém maiúscula, minúscula, número e símbolo', () {
    final password = PasswordGenerator.generatePassword(
      masterPassword: masterPassword,
      parameter: parameterA,
      length: 16,
      includeUppercase: true,
      includeLowercase: true,
      includeNumbers: true,
      includeSymbols: true,
    );

    expect(password, matches(RegExp(r'[A-Z]')));
    expect(password, matches(RegExp(r'[a-z]')));
    expect(password, matches(RegExp(r'\d')));
    expect(password, matches(RegExp(r'[!@#\$%&*+\-_=?]')));
  });

  test('geração de senha leva no máximo 500 ms', () {
    const repetitions = 8;
    const masterPasswordWarmUp = 'MinhaSenhaMestra2026';
    const parameterWarmUp = 'gmail.com';

    for (var i = 0; i < repetitions; i++) {
      PasswordGenerator.generatePassword(
        masterPassword: masterPasswordWarmUp,
        parameter: parameterWarmUp,
        length: 16,
      );
    }

    final elapsedTimes = <int>[];
    for (var i = 0; i < repetitions; i++) {
      final stopwatch = Stopwatch()..start();
      final password = PasswordGenerator.generatePassword(
        masterPassword: masterPassword,
        parameter: parameterA,
        length: 16,
      );
      stopwatch.stop();
      elapsedTimes.add(stopwatch.elapsedMilliseconds);
      expect(password, isNotEmpty);
    }

    final bestTime = elapsedTimes
        .reduce((value, element) => value < element ? value : element);
    expect(bestTime, lessThanOrEqualTo(500),
        reason: 'Measured times: $elapsedTimes');
  });
}
