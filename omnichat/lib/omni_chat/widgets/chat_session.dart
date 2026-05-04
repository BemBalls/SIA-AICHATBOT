import 'dart:convert';
import 'chat_message.dart';

class ChatSession {
  final String id;
  String title;
  final DateTime createdAt;
  List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  // Returns a display-friendly title — either the custom title or the first user message truncated to 30 chars.
  String get displayTitle {
    if (title.isNotEmpty) return title;
    final first = messages.firstWhere(
      (m) => m.isUser && m.text.isNotEmpty,
      orElse: () => ChatMessage(text: 'New Chat', isUser: true),
    );
    final t = first.text;
    return t.length > 30 ? '${t.substring(0, 30)}…' : t;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map(_messageToJson).toList(),
      };

  static ChatSession fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        messages: (json['messages'] as List<dynamic>)
            .map((m) => _messageFromJson(m as Map<String, dynamic>))
            .toList(),
      );


  static Map<String, dynamic> _messageToJson(ChatMessage m) => {
        'text': m.text,
        'isUser': m.isUser,
        'imageBytes': m.imageBytes != null ? base64Encode(m.imageBytes!) : null,
      };

  static ChatMessage _messageFromJson(Map<String, dynamic> j) => ChatMessage(
        text: j['text'] as String,
        isUser: j['isUser'] as bool,
        imageBytes: j['imageBytes'] != null
            ? base64Decode(j['imageBytes'] as String)
            : null,
      );
}