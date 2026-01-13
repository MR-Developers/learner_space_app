import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class PreferencesService {
  final Dio _dio = DioClient.instance;

  // ================= GET PREFERENCES =================

  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getUserPreferences(userId));
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch preferences";
      throw Exception(message);
    }
  }

  // ================= CREATE PREFERENCES =================

  Future<Map<String, dynamic>> createUserPreferences(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createUserPreferences(userId),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to create preferences";
      throw Exception(message);
    }
  }

  // ================= UPDATE PREFERENCES =================

  Future<Map<String, dynamic>> updateUserPreferences(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateUserPreferences(userId),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to update preferences";
      throw Exception(message);
    }
  }

  // ================= RESET PREFERENCES =================

  Future<Map<String, dynamic>> resetUserPreferences(String userId) async {
    try {
      final response = await _dio.delete(
        ApiEndpoints.resetUserPreferences(userId),
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to reset preferences";
      throw Exception(message);
    }
  }
}
