import 'dart:typed_data';

/// Embaralha uma lista de forma determinística a partir de bytes de origem.
class DeterministicShuffle {
  static List<T> shuffle<T>(List<T> items, Uint8List source) {
    final result = List<T>.from(items);
    for (var i = result.length - 1; i > 0; i--) {
      final swapIndex = _byteToIndex(source, i, i + 1);
      final temp = result[i];
      result[i] = result[swapIndex];
      result[swapIndex] = temp;
    }
    return result;
  }

  static int _byteToIndex(Uint8List source, int index, int modulus) {
    if (modulus <= 0) return 0;
    final byte = source[index % source.length];
    return byte % modulus;
  }
}
