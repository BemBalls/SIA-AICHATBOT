import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:omnichat/widgets/response_page.dart';
import 'chat_message.dart';

class ChatRepository {
  static const String _baseUrl = "http://18.179.119.18:8000";
  static const String _loadChatsEndpoint = "/chat_messages";

  static Future<List<ChatMessage>> loadMessages({
    int offset = 0,
    int limit = 100,
  }) async {
    try {
      final token = await DeviceStorage.getToken();
      if (token == null) return [];

      final response = await http
          .get(
            Uri.parse("$_baseUrl$_loadChatsEndpoint").replace(
              queryParameters: {
                "limit": limit.toString(),
                "offset": offset.toString(),
              },
            ),
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json",
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List messages = data['messages'] ?? [];

        // Chronological sort
        messages.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

        return messages
            .map(
              (m) => ChatMessage(
                isUser: m['role'] == 'user',
                text: m['content'] ?? '',
              ),
            )
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
