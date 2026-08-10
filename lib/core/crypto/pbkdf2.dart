import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Derivação de chave PBKDF2-SHA256.
class Pbkdf2Sha256 {
  static const int _hashLength = 32;

  static Uint8List deriveKey(
    String password,
    String salt, {
    int iterations = 100000,
    int outputBytes = 32,
  }) {
    final passwordBytes = utf8.encode(password);
    final saltBytes = utf8.encode(salt);
    return deriveKeyBytes(passwordBytes, saltBytes, iterations, outputBytes);
  }

  static Uint8List deriveKeyBytes(
    List<int> password,
    List<int> salt,
    int iterations,
    int dkLen,
  ) {
    final hmac = Hmac(sha256, password);
    final blocks = (dkLen + _hashLength - 1) ~/ _hashLength;
    final derived = Uint8List(blocks * _hashLength);
    var offset = 0;

    for (var blockIndex = 1; blockIndex <= blocks; blockIndex++) {
      final block = _pbkdf2Block(hmac, salt, iterations, blockIndex);
      derived.setRange(offset, offset + block.length, block);
      offset += block.length;
    }

    return Uint8List.fromList(derived.sublist(0, dkLen));
  }

  static Uint8List _pbkdf2Block(
    Hmac hmac,
    List<int> salt,
    int iterations,
    int blockIndex,
  ) {
    final saltWithIndex = Uint8List(salt.length + 4)
      ..setRange(0, salt.length, salt);
    saltWithIndex.buffer
        .asByteData()
        .setUint32(salt.length, blockIndex, Endian.big);

    var u = hmac.convert(saltWithIndex).bytes;
    final output = Uint8List.fromList(u);

    for (var iteration = 1; iteration < iterations; iteration++) {
      u = hmac.convert(u).bytes;
      for (var i = 0; i < output.length; i++) {
        output[i] ^= u[i];
      }
    }

    return output;
  }
}
