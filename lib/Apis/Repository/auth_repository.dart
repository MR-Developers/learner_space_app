import 'package:learner_space_app/Data/Models/UserModel.dart';
import 'package:learner_space_app/Apis/Services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepository {
  final _authService = AuthService();
  final _secureStorage = const FlutterSecureStorage();

  Future<void> login(String email, String password) async {
    final data = await _authService.login(email, password);
    print("DEBUG: Login API response = $data");
    print("DEBUG: Runtime type = ${data.runtimeType}");

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    if (accessToken != null && refreshToken != null) {
      // Decode JWT
      Map<String, dynamic> decoded = JwtDecoder.decode(accessToken);

      final uid = decoded["uid"];
      final userEmail = decoded["email"];
      final role = decoded["role"];

      // Save tokens
      await _secureStorage.write(key: 'accessToken', value: accessToken);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      // Save user info
      await _secureStorage.write(key: 'uid', value: uid.toString());
      await _secureStorage.write(key: 'email', value: userEmail);
      await _secureStorage.write(key: 'role', value: role);

      print("✅ Login: Tokens & User info saved successfully!");
    } else {
      print("⚠️ Missing token or refresh token in response!");
    }
  }

  Future<void> signup(UserSignUpFormValues form) async {
    final data = await _authService.signup(form);

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    if (accessToken != null && refreshToken != null) {
      // Decode JWT
      Map<String, dynamic> decoded = JwtDecoder.decode(accessToken);

      final uid = decoded["uid"];
      final userEmail = decoded["email"];
      final role = decoded["role"];

      // Save tokens
      await _secureStorage.write(key: 'accessToken', value: accessToken);
      await _secureStorage.write(key: 'refreshToken', value: refreshToken);

      // Save user info
      await _secureStorage.write(key: 'uid', value: uid.toString());
      await _secureStorage.write(key: 'email', value: userEmail);
      await _secureStorage.write(key: 'role', value: role);

      print("✅ Signup: Tokens & User info saved successfully!");
    } else {
      print("⚠️ Missing token or refresh token in response!");
    }
  }

  // --------------------------------------------------------------
  // LOGOUT USER
  // --------------------------------------------------------------
  Future<void> logout() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
    await _secureStorage.delete(key: 'uid');
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'role');

    print("🚪 User logged out — storage cleared.");
  }
}
