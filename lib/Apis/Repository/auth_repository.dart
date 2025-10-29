import '../services/auth_service.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<void> login(String email, String password) async {
    final data = await _authService.login(email, password);
    // Example: extract and store token
    final token = data['token'];
    if (token != null) {}
  }
}
