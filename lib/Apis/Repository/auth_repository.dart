import 'package:learner_space_app/Data/Models/UserModel.dart';
import 'package:learner_space_app/Apis/Services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final _authService = AuthService();
  final _secureStorage = const FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    final data = await _authService.login(email, password);

    final token = data['accessToken'];
    final refreshToken = data['refreshToken'];

    if (token != null && refreshToken != null) {
      await _secureStorage.write(key: 'accessToken', value: token);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      print("✅ Tokens saved successfully!");
    } else {
      print("⚠️ Missing token or refresh token in response!");
    }
  }

  Future<void> signup(UserSignUpFormValues form) async {
    final data = await _authService.signup(form);
    final token = data['accessToken'];
    final refreshToken = data['refreshToken'];
    if (token != null && refreshToken != null) {
      await _secureStorage.write(key: 'accessToken', value: token);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      print("✅ Tokens saved successfully!");
    } else {
      print("⚠️ Missing token or refresh token in response!");
    }
  }
}
