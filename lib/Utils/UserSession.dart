import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getUserId() async {
    return await _storage.read(key: 'uid');
  }
}
