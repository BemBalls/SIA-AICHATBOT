import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';

class ChatStorage {
  ChatStorage._();
  static final ChatStorage instance = ChatStorage._();

  static const String _sessionIdsKey = 'session_ids';

  static String _messageKey(String sessionId) => 'session:$sessionId';

  Future<List<String>> getSessionIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_sessionIdsKey) ?? <String>[];
  }

  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_messageKey(sessionId));
    if (raw == null || raw.isEmpty) return <ChatMessage>[];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map(ChatMessage.fromJson)
        .toList();
  }

  Future<void> saveMessages(String sessionId, List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(messages.map((m) => m.toJson()).toList());
    await prefs.setString(_messageKey(sessionId), encoded);

    final ids = prefs.getStringList(_sessionIdsKey) ?? <String>[];
    if (!ids.contains(sessionId)) {
      ids.insert(0, sessionId);
      await prefs.setStringList(_sessionIdsKey, ids);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messageKey(sessionId));

    final ids = prefs.getStringList(_sessionIdsKey) ?? <String>[];
    ids.remove(sessionId);
    await prefs.setStringList(_sessionIdsKey, ids);
  }
}

class ChatStorageWidget extends StatefulWidget {
  const ChatStorageWidget({
    super.key,
    required this.sessionId,
    required this.builder,
  });

  final String sessionId;
  final Widget Function(
    BuildContext context,
    List<ChatMessage> messages,
    bool isLoading,
  ) builder;

  @override
  State<ChatStorageWidget> createState() => _ChatStorageWidgetState();
}

class _ChatStorageWidgetState extends State<ChatStorageWidget> {
  List<ChatMessage> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ChatStorageWidget old) {
    super.didUpdateWidget(old);
    if (old.sessionId != widget.sessionId) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final msgs = await ChatStorage.instance.getMessages(widget.sessionId);
    if (mounted) setState(() { _messages = msgs; _loading = false; });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _messages, _loading);
}