import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';

import '../../core/network/dio_client.dart';

class FcmService {
  final Dio _dio = DioClient.instance;

  // GET DEVICE FCM TOKEN

  Future<String?> getFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  // CREATE FCM ENTRY (FIRST INSTALL / SIGNUP)
  // POST /fcm

  Future<void> createFcmEntry({
    required String userId,
    required String token,
    required String platform, // android | ios | web
  }) async {
    await _dio.post(
      ApiEndpoints.createFcm,
      data: {"userId": userId, "token": token, "platform": platform},
    );
  }

  // UPSERT FCM TOKEN (LOGIN / APP OPEN)
  // PUT /fcm/:userId/token

  Future<void> upsertFcmToken({
    required String userId,
    required String token,
    required String platform,
  }) async {
    await _dio.put(
      ApiEndpoints.upsertFcmToken(userId),
      data: {"token": token, "platform": platform},
    );
  }

  // REMOVE FCM TOKEN (LOGOUT)
  // PUT /fcm/:userId/token/remove

  Future<void> removeFcmToken({
    required String userId,
    required String token,
  }) async {
    await _dio.put(ApiEndpoints.removeFcmToken(userId), data: {"token": token});
  }

  // GET USER FCM INFO
  // GET /fcm/:userId

  Future<Response> getUserFcm(String userId) async {
    return await _dio.get(ApiEndpoints.getUserFcm(userId));
  }

  // UPDATE NOTIFICATION SETTINGS
  // PUT /fcm/:userId/settings

  Future<void> updateNotificationSettings({
    required String userId,
    required Map<String, dynamic> settings,
  }) async {
    await _dio.put(ApiEndpoints.updateFcmSettings(userId), data: settings);
  }

  // ADD USER TO NOTIFICATION GROUPS
  // PUT /fcm/:userId/groups/add

  Future<void> addGroups({
    required String userId,
    required List<String> groupIds,
  }) async {
    await _dio.put(
      ApiEndpoints.addFcmGroups(userId),
      data: {"groupIds": groupIds},
    );
  }

  // REMOVE USER FROM NOTIFICATION GROUPS
  // PUT /fcm/:userId/groups/remove

  Future<void> removeGroups({
    required String userId,
    required List<String> groupIds,
  }) async {
    await _dio.put(
      ApiEndpoints.removeFcmGroups(userId),
      data: {"groupIds": groupIds},
    );
  }

  // DISABLE NOTIFICATIONS
  // PUT /fcm/:userId/disable

  Future<void> disableNotifications(String userId) async {
    await _dio.put(ApiEndpoints.disableNotifications(userId));
  }

  // ENABLE NOTIFICATIONS
  // PUT /fcm/:userId/enable

  Future<void> enableNotifications(String userId) async {
    await _dio.put(ApiEndpoints.enableNotifications(userId));
  }
}
