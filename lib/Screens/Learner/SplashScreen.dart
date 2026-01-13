import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import 'package:learner_space_app/Apis/Services/preferences_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    const storage = FlutterSecureStorage();

    final token = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');
    final userId = await storage.read(key: 'uid');

    await Future.delayed(const Duration(seconds: 2));

    if (token == null || refreshToken == null || userId == null) {
      _go('/getStarted');
      return;
    }
    // 🔹 Check preferences existence
    try {
      await _preferencesService.getUserPreferences(userId);

      // Preferences exist → go home
      _go('/home');
    } catch (e) {
      // Preferences NOT found → go to setup screen
      _go('/preferencesSetup');
    }
  }

  void _go(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Colors.orange)),
    );
  }
}
