import 'chat_message.dart';

class ChatService {
  static Future<ChatMessage> sendMessage(List<ChatMessage> messages, String userToken, Map<String, dynamic> userProfile) async {
    // Mock response
    await Future.delayed(const Duration(seconds: 1));
    return ChatMessage(
      isUser: false,
      text: "This is a mock AI response. Please implement the actual API.",
    );
  }
}