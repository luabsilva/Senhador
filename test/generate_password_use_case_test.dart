import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_key/application/usecases/generate_password_use_case.dart';
import 'package:cyber_key/domain/entities/password_request.dart';

void main() {
  const masterPassword = 'MinhaSenhaMestra2026';
  const parameter = 'gmail.com';

  test(
      'generate password use case executes asynchronously and returns a generated password',
      () async {
    const useCase = GeneratePasswordUseCase();
    final request = PasswordRequest(
      masterPassword: masterPassword,
      parameter: parameter,
      length: 16,
      includeUppercase: true,
      includeLowercase: true,
      includeNumbers: true,
      includeSymbols: true,
    );

    final result = await useCase.execute(request);

    expect(result.value, isNotEmpty);
    expect(result.value.length, equals(16));
    expect(result.value, matches(RegExp(r'[A-Z]')));
    expect(result.value, matches(RegExp(r'[a-z]')));
    expect(result.value, matches(RegExp(r'\d')));
    expect(result.value, matches(RegExp(r'[!@#\$%&*+\-_=?]')));
    expect(result.strengthScore, inInclusiveRange(1, 4));
  });
}
