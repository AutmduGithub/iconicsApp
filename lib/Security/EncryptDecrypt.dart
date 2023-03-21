import 'package:encrypt/encrypt.dart';

class AESAlgorithm {
  static Encrypted encryptWithAES(String key, text) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));
    Encrypted data = encryptService.encrypt(text, iv: initVector);
    return data;
  }

  static String decryptWithAES(String key, text) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));
    return encryptService.decrypt64(text, iv: initVector);
  }
}
