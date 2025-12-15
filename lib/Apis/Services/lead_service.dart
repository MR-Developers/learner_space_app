import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class LeadService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> createLead(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.createLead, data: data);
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to create lead';
      throw Exception(message);
    }
  }
}
