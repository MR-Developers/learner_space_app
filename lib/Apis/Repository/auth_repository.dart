import 'dart:io';

import 'package:learner_space_app/Data/Models/UserModel.dart';
import 'package:learner_space_app/Apis/Services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:learner_space_app/Apis/Services/fcm_service.dart';

class AuthRepository {
  final _authService = AuthService();
  final _fcmService = FcmService();
  final _secureStorage = const FlutterSecureStorage();

  // LOGIN

  Future<void> login(String email, String password) async {
    final data = await _authService.login(email, password);

    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    if (accessToken == null || refreshToken == null) {
      throw Exception("Missing tokens from login response");
    }

    final decoded = JwtDecoder.decode(accessToken);
    final uid = decoded["uid"].toString();
    final emailFromToken = decoded["email"];
    final role = decoded["role"];

    await _persistAuthData(
      accessToken: accessToken,
      refreshToken: refreshToken,
      uid: uid,
      email: emailFromToken,
      role: role,
    );

    // 🔔 UPSERT FCM TOKEN (LOGIN)
    await _syncFcmOnLogin(uid);

    print("✅ Login completed with FCM synced");
  }

  // SIGNUP

  Future<void> signup(UserSignUpFormValues form) async {
    await _authService.signup(form);
  }

  // LOGOUT

  Future<void> logout() async {
    final userId = await _secureStorage.read(key: 'uid');
    final fcmToken = await _secureStorage.read(key: 'fcmToken');

    if (userId != null && fcmToken != null) {
      await _fcmService.removeFcmToken(userId: userId, token: fcmToken);
    }

    await _secureStorage.deleteAll();
    print("🚪 User logged out — FCM removed & storage cleared");
  }

  // INTERNAL HELPERS

  Future<void> _persistAuthData({
    required String accessToken,
    required String refreshToken,
    required String uid,
    required String email,
    required String role,
  }) async {
    await _secureStorage.write(key: 'accessToken', value: accessToken);
    await _secureStorage.write(key: 'refreshToken', value: refreshToken);
    await _secureStorage.write(key: 'uid', value: uid);
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'role', value: role);
  }

  /// 🔔 Signup → create FCM entry
  Future<void> _registerFcmOnSignup(String userId) async {
    try {
      final token = await _fcmService.getFcmToken();
      if (token == null) return;

      final platform = _getPlatform();

      await _secureStorage.write(key: 'fcmToken', value: token);

      await _fcmService.createFcmEntry(
        userId: userId,
        token: token,
        platform: platform,
      );

      print("🔥 FCM entry created for user $userId");
    } catch (e) {
      print("⚠️ Failed to create FCM entry: $e");
    }
  }

  /// 🔁 Login → upsert FCM token
  Future<void> _syncFcmOnLogin(String userId) async {
    try {
      final token = await _fcmService.getFcmToken();
      if (token == null) return;

      final platform = _getPlatform();

      await _secureStorage.write(key: 'fcmToken', value: token);

      await _fcmService.upsertFcmToken(
        userId: userId,
        token: token,
        platform: platform,
      );

      print("🔁 FCM token upserted for user $userId");
    } catch (e) {
      print("⚠️ Failed to upsert FCM token: $e");
    }
  }

  String _getPlatform() {
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    return "web";
  }
}
