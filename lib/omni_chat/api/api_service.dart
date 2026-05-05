import 'dart:convert';
import 'package:http/http.dart' as http;

/// Central API service — swap out the base URL and model as needed.
/// Currently stubbed for Gemini; adapt headers for OpenAI or others.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // TODO: move to .env / constants
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  static const String _apiKey = 'YOUR_API_KEY';

  /// Sends [prompt] to the model and returns the response text.
  Future<String> sendMessage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] as String;
      } else {
        throw Exception('API error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}