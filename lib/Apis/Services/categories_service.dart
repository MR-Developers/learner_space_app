import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class CategoryService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> getAllCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllCategories);
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to load categories';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> getCompanyCategoryCount(int categoryId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getCompanyCategoryCount(categoryId),
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to load category count';
      throw Exception(message);
    }
  }
}
