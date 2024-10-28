import 'dart:convert';
import 'package:http/http.dart' as http;

class Request {

  static Future<dynamic> Get(String url) async {
    late String? apiUrl;
    apiUrl = GetApiUrl();
    final uri = Uri.parse('$apiUrl$url');

    final response = await http.get(uri,
      headers: {'Content-Type': 'application/json' },
    );

    return json.decode(response.body);
  }

  static String GetApiUrl() {
    return "";
  }
}