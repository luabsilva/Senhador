import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Utilitário HMAC-SHA256 para material criptográfico adicional.
class HmacSha256 {
  static Uint8List compute(Uint8List key, List<int> message) {
    final hmac = Hmac(sha256, key);
    return Uint8List.fromList(hmac.convert(message).bytes);
  }
}
