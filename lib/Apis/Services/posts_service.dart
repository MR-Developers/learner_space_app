import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class PostsService {
  final Dio _dio = DioClient.instance;

  // CREATE POST

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.createPost, data: data);

      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to create post";
      throw Exception(message);
    }
  }

  // LIKE POST

  Future<Map<String, dynamic>> likePost(String postId) async {
    try {
      final response = await _dio.post(ApiEndpoints.likePost(postId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to like post";
      throw Exception(message);
    }
  }

  // UPDATE POST

  Future<Map<String, dynamic>> updatePost(
    String postId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updatePost(postId),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to update post";
      throw Exception(message);
    }
  }

  // DELETE POST

  Future<Map<String, dynamic>> deletePost(String postId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.deletePost(postId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to delete post";
      throw Exception(message);
    }
  }

  // GET ALL POSTS

  Future<Map<String, dynamic>> getAllPosts() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllPosts);
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to fetch posts";
      throw Exception(message);
    }
  }

  // GET POSTS BY USER

  Future<Map<String, dynamic>> getPostsByUser(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getPostsByUser(userId));
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch user posts";
      throw Exception(message);
    }
  }

  // GET POSTS BY CATEGORY

  Future<Map<String, dynamic>> getPostsByCategory(String category) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getPostsByCategory(category),
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch category posts";
      throw Exception(message);
    }
  }
}
