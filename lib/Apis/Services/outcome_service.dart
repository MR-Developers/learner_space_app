import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class OutcomeService {
  final Dio _dio = DioClient.instance;

  // CREATE OUTCOME
  Future<Map<String, dynamic>> createOutcome(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.createOutcome, data: data);
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to create outcome";
      throw Exception(message);
    }
  }

  // GET ALL OUTCOMES
  Future<Map<String, dynamic>> getAllOutcomes() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllOutcomes);
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch outcomes";
      throw Exception(message);
    }
  }

  // GET OUTCOME BY ID
  Future<Map<String, dynamic>> getOutcomeById(String outcomeId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getOutcomeById(outcomeId));
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to fetch outcome";
      throw Exception(message);
    }
  }

  // GET OUTCOMES BY USER

  Future<Map<String, dynamic>> getOutcomesByUser(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getOutcomesByUser(userId));
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch user outcomes";
      throw Exception(message);
    }
  }

  // GET OUTCOMES BY COURSE
  Future<Map<String, dynamic>> getOutcomesByCourse(String courseId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.getOutcomesByCourse(courseId),
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to fetch course outcomes";
      throw Exception(message);
    }
  }

  // UPDATE OUTCOME
  Future<Map<String, dynamic>> updateOutcome(
    String outcomeId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateOutcome(outcomeId),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to update outcome";
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> getFeaturedOutcomes() async {
    try {
      final response = await _dio.get(ApiEndpoints.getFeatureOutcomes);
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to verify outcome";
      throw Exception(message);
    }
  }

  // -------------------------------
  // DELETE OUTCOME
  // -------------------------------
  Future<Map<String, dynamic>> deleteOutcome(String outcomeId) async {
    try {
      final response = await _dio.delete(ApiEndpoints.deleteOutcome(outcomeId));
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to delete outcome";
      throw Exception(message);
    }
  }
}
