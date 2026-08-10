import 'package:flutter_test/flutter_test.dart';
import 'package:senhador/core/crypto/password_generator.dart';

void main() {
  test(
      'password generation should complete in under 500 milliseconds after warm-up',
      () {
    const masterPassword = 'MinhaSenhaMestra2026';
    const parameter = 'gmail.com';

    // Warm up JIT and crypto initialization.
    for (var i = 0; i < 10; i++) {
      PasswordGenerator.generatePassword(
        masterPassword: masterPassword,
        parameter: parameter,
        length: 16,
      );
    }

    final elapsedTimes = <int>[];

    for (var i = 0; i < 10; i++) {
      final stopwatch = Stopwatch()..start();
      final password = PasswordGenerator.generatePassword(
        masterPassword: masterPassword,
        parameter: parameter,
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
