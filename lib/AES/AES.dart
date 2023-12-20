import 'dart:convert';

class AES {
  String base64Decode(String input) {
    // Decode base64 encoded string
    List<int> decodedBytes = base64.decode(input);
    return utf8.decode(decodedBytes);
  }

  String xorEncode(String input, String key) {
    String encodedData = "";
    for (int i = 0; i < input.length; i++) {
      encodedData += String.fromCharCode(
          input.codeUnitAt(i) ^ key.codeUnitAt(i % key.length));
    }
    return encodedData;
  }

  String decodeWithKey(String encodedData, String key) {
    // Decode base64 and XOR with key
    List<int> decodedBytes = base64.decode(encodedData);
    List<int> keyBytes = utf8.encode(key);

    for (int i = 0; i < decodedBytes.length; i++) {
      decodedBytes[i] ^= keyBytes[i % keyBytes.length];
    }

    return utf8.decode(decodedBytes);
  }
}
