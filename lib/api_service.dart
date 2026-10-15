import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://172.16.84.191:8080';

  static Future<String> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/queue/test'));

      if (response.statusCode == 200) {
        return response.body;
      }

      return 'Server error: ${response.statusCode}';
    } catch (e) {
      return 'Connection failed: $e';
    }
  }

  static Future<String> joinQueue(String userName) async {
    final response = await http
        .post(
          Uri.parse(
            '$baseUrl/api/queue/join',
          ).replace(queryParameters: {'userName': userName}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception('Could not join queue: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> getTokenStatus(int tokenNumber) async {
    final uri = Uri.parse(
      '$baseUrl/api/queue/status',
    ).replace(queryParameters: {'tokenNumber': tokenNumber.toString()});

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Could not fetch token status: ${response.statusCode}');
  }

  static Future<List<String>> getQueue() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/queue'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => item.toString()).toList();
    }

    throw Exception('Could not load queue: ${response.statusCode}');
  }

  static Future<String> leaveQueue(int tokenNumber) async {
    final uri = Uri.parse(
      '$baseUrl/api/queue/skip',
    ).replace(queryParameters: {'tokenNumber': tokenNumber.toString()});

    final response = await http.post(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception('Could not leave queue: ${response.statusCode}');
  }
}
