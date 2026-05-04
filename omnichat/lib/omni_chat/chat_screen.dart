import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/chat_message.dart';
import 'widgets/chat_messagelist.dart';
import 'widgets/chat_inputbar.dart';
import 'widgets/chat_service.dart';
import 'widgets/chat_storage.dart';

class OmniChatApp extends StatefulWidget {
  const OmniChatApp({super.key});

  @override
  State<OmniChatApp> createState() => _OmniChatAppState();
}

class _OmniChatAppState extends State<OmniChatApp> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [];
  bool _isWaitingForResponse = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final loaded = await ChatStorage.loadMessages();
    setState(() {
      messages = loaded.isNotEmpty
          ? loaded
          : [
              ChatMessage(
                isUser: false,
                text: 'Hi! I\'m your AI assistant. How can I help you today?',
              )
            ];
    });
  }

  Future<void> _saveMessages() async {
    await ChatStorage.saveMessages(messages);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend(String text, XFile? image, Uint8List? bytes) {
    if (text.trim().isEmpty && image == null) return;
    if (_isWaitingForResponse) return;

    final userMsg = ChatMessage(
      isUser: true,
      text: text.trim(),
      imagePath: kIsWeb ? null : image?.path,
      imageBytes: bytes,
    );

    setState(() {
      messages.add(userMsg);
      _isWaitingForResponse = true;
    });

    _saveMessages();
    _scrollToBottom();
    _fetchAIResponse();
  }

  Future<void> _fetchAIResponse() async {
    try {
      final response = await ChatService.sendMessage(messages, "", {});

      setState(() {
        messages.add(response);
        _isWaitingForResponse = false;
      });

      _saveMessages();
      _scrollToBottom();
    } catch (e) {
      final errorMsg = ChatMessage(
        isUser: false,
        text: "Error: ${e.toString()}",
      );

      setState(() {
        messages.add(errorMsg);
        _isWaitingForResponse = false;
      });

      _saveMessages();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('OmniChat'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              messages: messages,
              scrollController: _scrollController,
            ),
          ),
          ChatInputBar(
            controller: _controller,
            onSend: _handleSend,
            isLoading: _isWaitingForResponse,
          ),
        ],
      ),
    );
  }


}