import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  static Future<List?> fechTasks() async {
    final url = Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=20');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final data = json['items'] as List;
      return data;
    } else {
      return null;
    }
  }

  static Future<bool> submitTask({required Map body}) async {
    final url = Uri.parse(
      'https://api.nstack.in/v1/todos',
    );
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateTask({
    required String id,
    required Map body,
  }) async {
    final url = Uri.parse(
      'https://api.nstack.in/v1/todos/$id',
    );
    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteByID({required String id}) async {
    final url = Uri.parse('https://api.nstack.in/v1/todos/$id');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }
}
