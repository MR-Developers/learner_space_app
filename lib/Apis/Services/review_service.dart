import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class ReviewService {
  final Dio _dio = DioClient.instance;

  // -------------------------------
  // CREATE REVIEW
  // -------------------------------
  Future<Map<String, dynamic>> createReview(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.createReview, data: data);
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to create review";
      throw Exception(message);
    }
  }

  // -------------------------------
  // GET ALL REVIEWS (ADMIN / INTERNAL)
  // -------------------------------
  Future<Map<String, dynamic>> getAllReviews() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllReviews);
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to fetch reviews";
      throw Exception(message);
    }
  }

  // -------------------------------
  // GET REVIEWS BY COURSE
  // -------------------------------
  Future<Map<String, dynamic>> getReviewsByCourse(String courseId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getReviewsByCourse(courseId),
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch course reviews";
      throw Exception(message);
    }
  }

  // -------------------------------
  // UPDATE REVIEW
  // -------------------------------
  Future<Map<String, dynamic>> updateReview(
    String reviewId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateReview(reviewId),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to update review";
      throw Exception(message);
    }
  }

  // -------------------------------
  // DELETE REVIEW
  // -------------------------------
  Future<Map<String, dynamic>> deleteReview(String reviewId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.deleteReview(reviewId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to delete review";
      throw Exception(message);
    }
  }
}
