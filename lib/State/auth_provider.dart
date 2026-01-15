import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Repository/auth_repository.dart';
import 'package:learner_space_app/Apis/Services/preferences_service.dart';
import 'package:learner_space_app/Data/Models/UserModel.dart';
import 'package:learner_space_app/Utils/UserSession.dart';

class AuthProvider extends ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();

  final _repo = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // LOGIN
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    debugPrint("AuthProvider: LOGIN attempt for email=$email");
    debugPrint(
      "AuthProvider: BASE_URL = ${const String.fromEnvironment("BASE_URL")}",
    );

    try {
      await _repo.login(email, password);

      debugPrint("AuthProvider: LOGIN SUCCESS for email=$email");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));

      await _handlePostAuthNavigation(context);
    } catch (e) {
      debugPrint("AuthProvider: LOGIN ERROR -> $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("AuthProvider: LOGIN finished");
    }
  }

  // SIGNUP
  Future<void> signup(BuildContext context, UserSignUpFormValues data) async {
    _isLoading = true;
    notifyListeners();

    debugPrint("AuthProvider: SIGNUP attempt for email=${data.email}");
    debugPrint(
      "AuthProvider: BASE_URL = ${const String.fromEnvironment("BASE_URL")}",
    );

    try {
      await _repo.signup(data);

      debugPrint("AuthProvider: SIGNUP SUCCESS for email=${data.email}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Created Successfully')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      debugPrint("AuthProvider: SIGNUP ERROR -> $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("AuthProvider: SIGNUP finished");
    }
  }

  // LOGOUT
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    debugPrint("AuthProvider: LOGOUT attempt");
    debugPrint(
      "AuthProvider: BASE_URL = ${const String.fromEnvironment("BASE_URL")}",
    );

    try {
      await _repo.logout();

      debugPrint("AuthProvider: LOGOUT SUCCESS");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out successfully')));

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      debugPrint("AuthProvider: LOGOUT ERROR -> $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("AuthProvider: LOGOUT finished");
    }
  }

  Future<void> _handlePostAuthNavigation(BuildContext context) async {
    final userId = await UserSession.getUserId();

    if (userId == null) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    try {
      await _preferencesService.getUserPreferences(userId);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/preferencesSetup');
    }
  }
}
