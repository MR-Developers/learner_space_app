import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class CourseService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> getRecommendedCourses(String userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getRecommendedCourses(userId),
      );

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? 'Failed to fetch recommended courses';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> getRecommendedCourseByCategory(
    String userId,
    String categoryId,
  ) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getRecommendedCourseByCat(userId, categoryId),
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          'Failed to fetch recommended courses by category';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> getCourses({
    int page = 1,
    int limit = 20,
    List<String>? courseCategory,
    List<String>? industry,
    double? priceMin,
    double? priceMax,
    String? mode,
    List<String>? language,
    String? placementAssistance,
    String? instructorId,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (courseCategory != null) 'category': courseCategory,
        if (industry != null) 'companyCategory': industry,
        if (priceMin != null) 'priceMin': priceMin,
        if (priceMax != null) 'priceMax': priceMax,
        if (mode != null) 'mode': mode,
        if (language != null) 'language': language,
        if (placementAssistance != null && placementAssistance != "Any")
          'placementAssistance': placementAssistance.toString(),
        if (instructorId != null) 'instructorId': instructorId,
        if (search != null) 'search': search,
      };

      final response = await _dio.get(
        ApiEndpoints.getCourses,
        queryParameters: queryParams,
      );

      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch course list";
      throw Exception(message);
    }
  }
}
