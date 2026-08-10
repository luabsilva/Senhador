/// Representa uma solicitação de geração de senha.
///
/// Esta entidade é imutável e modela exatamente os campos definidos na arquitetura.
class PasswordRequest {
  final String masterPassword;
  final String parameter;
  final int length;
  final bool includeUppercase;
  final bool includeLowercase;
  final bool includeNumbers;
  final bool includeSymbols;

  PasswordRequest({
    required this.masterPassword,
    required this.parameter,
    this.length = 16,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSymbols = true,
  })  : assert(masterPassword.isNotEmpty, 'masterPassword must not be empty.'),
        assert(parameter.isNotEmpty, 'parameter must not be empty.'),
        assert(length > 0, 'length must be greater than zero.');

  @override
  String toString() {
    return 'PasswordRequest(parameter: $parameter, length: $length, includeUppercase: $includeUppercase, includeLowercase: $includeLowercase, includeNumbers: $includeNumbers, includeSymbols: $includeSymbols)';
  }
}
