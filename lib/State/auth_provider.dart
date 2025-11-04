import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Repository/auth_repository.dart';
import 'package:learner_space_app/Data/Models/UserModel.dart';

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.login(email, password);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(BuildContext context, UserSignUpFormValues data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repo.signup(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Created Successfully')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
