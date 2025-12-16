import 'package:dio/dio.dart';
import 'package:learner_space_app/Core/Network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class LeadService {
  final Dio _dio = DioClient.instance;

  Future<void> createLead(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiEndpoints.createLead, data: data);
    } catch (_) {}
  }
}
