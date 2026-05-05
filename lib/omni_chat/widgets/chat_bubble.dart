import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../themes/app_theme.dart';
import '../utilities/fade_slide_up.dart';

/// A single chat bubble with entrance animation.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message; // ← only this, no separate 'content' field

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return FadeSlideUp(
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? AppTheme.userBubbleBg : AppTheme.botBubbleBg,
              borderRadius: BorderRadius.only(
                topLeft:     const Radius.circular(16),
                topRight:    const Radius.circular(16),
                bottomLeft:  Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: isUser
                  ? null
                  : Border.all(color: AppTheme.border, width: 0.8),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: isUser ? AppTheme.userBubbleText : AppTheme.botBubbleText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}