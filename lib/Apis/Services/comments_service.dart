import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class CommentsService {
  final Dio _dio = DioClient.instance;

  // ADD COMMENT
  Future<Map<String, dynamic>> addComment(
    String postId,
    String userId,
    String text,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addComment,
        data: {"postId": postId, "userId": userId, "text": text},
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to add comment";
      throw Exception(message);
    }
  }

  // ADD REPLY
  Future<Map<String, dynamic>> addReply(
    String parentCommentId,
    String postId,
    String userId,
    String text,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addReply(parentCommentId),
        data: {"postId": postId, "userId": userId, "text": text},
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to add reply";
      throw Exception(message);
    }
  }

  // GET ALL COMMENTS FOR A POST
  Future<Map<String, dynamic>> getComments(String postId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getCommentsForPost(postId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to load comments";
      throw Exception(message);
    }
  }

  // GET REPLIES FOR A COMMENT
  Future<Map<String, dynamic>> getReplies(String commentId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getReplies(commentId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to load replies";
      throw Exception(message);
    }
  }

  // DELETE COMMENT
  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.deleteComment(commentId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error'] ?? "Failed to delete comment";
      throw Exception(message);
    }
  }
}
