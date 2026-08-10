import 'package:flutter/foundation.dart';

import '../../core/crypto/password_generator.dart';
import '../../domain/entities/generated_password.dart';
import '../../domain/entities/password_request.dart';

String _generatePassword(Map<String, dynamic> args) {
  return PasswordGenerator.generatePassword(
    masterPassword: args['masterPassword'] as String,
    parameter: args['parameter'] as String,
    length: args['length'] as int,
    includeUppercase: args['includeUppercase'] as bool,
    includeLowercase: args['includeLowercase'] as bool,
    includeNumbers: args['includeNumbers'] as bool,
    includeSymbols: args['includeSymbols'] as bool,
  );
}

/// Caso de uso responsável por gerar uma senha a partir de uma solicitação.
class GeneratePasswordUseCase {
  const GeneratePasswordUseCase();

  Future<GeneratedPassword> execute(PasswordRequest request) async {
    final password = await compute(
      _generatePassword,
      <String, dynamic>{
        'masterPassword': request.masterPassword,
        'parameter': request.parameter,
        'length': request.length,
        'includeUppercase': request.includeUppercase,
        'includeLowercase': request.includeLowercase,
        'includeNumbers': request.includeNumbers,
        'includeSymbols': request.includeSymbols,
      },
    );

    final strengthScore = _calculateStrength(password);

    return GeneratedPassword(
      value: password,
      strengthScore: strengthScore,
    );
  }

  int _calculateStrength(String password) {
    var score = 0;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%&*+\-_=?]').hasMatch(password)) score++;

    return score.clamp(1, 4).toInt();
  }
}
