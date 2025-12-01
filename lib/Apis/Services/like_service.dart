import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class LikesService {
  final Dio _dio = DioClient.instance;

  // LIKE POST

  Future<Map<String, dynamic>> likePost(String postId, String userId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.likePost(postId),
        data: {"userId": userId},
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to like post";
      throw Exception(message);
    }
  }

  // UNLIKE POST

  Future<Map<String, dynamic>> unlikePost(String postId, String userId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.unlikePost(postId),
        data: {"userId": userId},
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to unlike post";
      throw Exception(message);
    }
  }

  // CHECK IF USER LIKED POST

  Future<bool> checkIsLiked(String postId, String userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.checkIsLiked(postId, userId),
      );

      return response.data["data"] == true;
    } on DioException catch (e) {
      final message =
          e.response?.data?['error'] ??
          "Failed to check if user liked this post";
      throw Exception(message);
    }
  }

  // GET ALL LIKES FOR A POST
  Future<List<dynamic>> getLikesForPost(String postId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getLikesForPost(postId));

      return response.data["data"] ?? [];
    } on DioException catch (e) {
      final message =
          e.response?.data?['error'] ?? "Failed to fetch likes for post";
      throw Exception(message);
    }
  }
}
