import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static String encryptPayload({
    required Map<String, dynamic> payload,
    required String publicKey,
  }) {
    final rsaPublicKey = CryptoUtils.rsaPublicKeyFromPem(publicKey);

    final encrypter = Encrypter(
      RSA(publicKey: rsaPublicKey, encoding: RSAEncoding.PKCS1),
    );

    final jsonPayload = jsonEncode(payload);

    return encrypter.encrypt(jsonPayload).base64;
  }
}
