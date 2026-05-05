import 'package:flutter/material.dart';
import '../db/chat_storage.dart';
import '../models/chat_message.dart';

/// Holds the full list of messages for the active session
/// and manages session switching / creation.
class ChatSessionProvider extends ChangeNotifier {
  ChatSessionProvider() {
    _init();
  }

  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  String get sessionId => _sessionId;

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  List<String> _sessionIds = [];
  List<String> get sessionIds => List.unmodifiable(_sessionIds);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Init ────

  Future<void> _init() async {
    _sessionIds = await ChatStorage.instance.getSessionIds();
    if (_sessionIds.isNotEmpty) {
      await loadSession(_sessionIds.first);
    }
    notifyListeners();
  }

  // ── Public API ──

  void addMessage(ChatMessage msg) {
    _messages = [..._messages, msg];
    notifyListeners();
  }

  Future<void> loadSession(String sessionId) async {
    _isLoading = true;
    notifyListeners();

    _sessionId = sessionId;
    _messages  = await ChatStorage.instance.getMessages(sessionId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> startNewSession() async {
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _messages  = [];
    notifyListeners();
  }

  Future<void> deleteSession(String sessionId) async {
    await ChatStorage.instance.deleteSession(sessionId);
    _sessionIds = await ChatStorage.instance.getSessionIds();
    if (sessionId == _sessionId) await startNewSession();
    notifyListeners();
  }

  String get previewTitle {
    if (_messages.isEmpty) return 'New chat';
    final first = _messages.firstWhere(
      (m) => m.isUser,
      orElse: () => _messages.first,
    );
    final text = first.content;
    return text.length > 40 ? '${text.substring(0, 40)}…' : text;
  }
}