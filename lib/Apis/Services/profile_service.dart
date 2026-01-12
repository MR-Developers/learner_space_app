import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class ProfileService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getUserInfo(userId));

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch user info";
      throw Exception(message);
    }
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateUserInfo(userId),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch user info";
      throw Exception(message);
    }
  }
}
