import 'package:flutter/material.dart';
import '../db/chat_storage.dart' as db;
import '../models/chat_message.dart';


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
    final msgs =
        await db.ChatStorage.instance.getMessages(widget.sessionId);
    if (mounted) setState(() { _messages = msgs; _loading = false; });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _messages, _loading);
}