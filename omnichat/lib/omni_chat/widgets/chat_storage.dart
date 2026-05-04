import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_message.dart';

// Persists chat messages to device storage via shared_preferences.
class ChatStorage {
  static const _key = 'ai_chat_messages';

  // Load all messages.
  static Future<List<ChatMessage>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List<dynamic>)
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  // Save all messages.
  static Future<void> saveMessages(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(messages.map((m) => m.toJson()).toList()));
  }

  // Clear all messages.
  static Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}