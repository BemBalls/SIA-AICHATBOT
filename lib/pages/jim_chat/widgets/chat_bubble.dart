import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  void _openFullscreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer( 
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: kIsWeb
                  ? Image.memory(message.imageBytes!)
                  : Image.file(File(message.imagePath!)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFFF9F6D) : const Color(0xFFF7F0E9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imagePath != null || message.imageBytes != null)
              GestureDetector(
                onTap: () => _openFullscreen(context), 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: kIsWeb
                      ? Image.memory(
                          message.imageBytes!,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200, 
                        )
                      : Image.file(
                          File(message.imagePath!),
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200, 
                        ),
                ),
              ),
            if (message.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: isUser ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}