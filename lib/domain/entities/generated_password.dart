/// Representa o resultado de uma geração de senha.
///
/// A entidade é imutável e não revela o valor completo em `toString`.
class GeneratedPassword {
  final String value;
  final int strengthScore;

  const GeneratedPassword({
    required this.value,
    required this.strengthScore,
  });

  @override
  String toString() => 'GeneratedPassword(strengthScore: $strengthScore)';
}
