import 'package:learner_space_app/Data/Models/UserModel.dart';
import 'package:learner_space_app/Apis/Services/auth_service.dart';

class AuthRepository {
  final _authService = AuthService();

  Future<void> login(String email, String password) async {
    final data = await _authService.login(email, password);
    // Example: extract and store token
    final token = data['token'];
    if (token != null) {}
  }

  Future<void> signup(UserSignUpFormValues form) async {
    final data = await _authService.signup(form);
    final token = data['token'];
    if (token != null) {}
  }
}
