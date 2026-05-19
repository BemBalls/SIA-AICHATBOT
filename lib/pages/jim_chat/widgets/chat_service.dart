import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omnichat/widgets/response_page.dart';
import 'chat_message.dart';

class ChatService {
  static const String _baseUrl = "http://127.0.0.1:8000";
  static const String _completionEndpoint = "/generate_gym_chat_completions";

  static Future<String> sendMessage({
    required List<ChatMessage> messageHistory,
    required Map<String, dynamic> userProfile,
  }) async {
    try {
      final token = await DeviceStorage.getToken();
      if (token == null) throw Exception("Session expired.");

      final messages = messageHistory
          .where((m) => m.text.trim().isNotEmpty && m.text != "...")
          .map(
            (msg) => {
              "role": msg.isUser ? "user" : "assistant",
              "content": msg.text,
            },
          )
          .toList();

      final minimalProfile = <String, dynamic>{};
      final allowedKeys = ["user_id", "email", "name", "created_at"];
      for (final k in allowedKeys) {
        if (userProfile.containsKey(k)) minimalProfile[k] = userProfile[k];
      }

      final requestBody = jsonEncode({
        "user_profile": minimalProfile,
        "messages": messages,
      });

      final response = await http
          .post(
            Uri.parse("$_baseUrl$_completionEndpoint"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: requestBody,
          )
          .timeout(const Duration(seconds: 60));

      final responseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data['message']?.toString() ?? "No response.";
      }

      String errorDetail = responseBody;
      try {
        final errorJson = jsonDecode(responseBody);
        if (errorJson is Map && errorJson['detail'] != null) {
          errorDetail = errorJson['detail'].toString();
        }
      } catch (_) {
        // Keep raw responseBody if JSON parsing fails.
      }

      throw Exception("Error ${response.statusCode}: $errorDetail");
    } catch (e) {
      rethrow;
    }
  }
}
