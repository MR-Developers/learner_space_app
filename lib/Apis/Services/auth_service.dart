import 'package:dio/dio.dart';
import 'package:learner_space_app/Data/Models/UserModel.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';

class AuthService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Login failed';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> signup(UserSignUpFormValues form) async {
    try {
      final data = form.toJson();

      final response = await _dio.post(
        ApiEndpoints.register,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "SignUp Failed";
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.changePassword,
        data: {"currentPassword": currentPassword, "newPassword": newPassword},
      );

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to change password';
      throw Exception(message);
    }
  }
}
