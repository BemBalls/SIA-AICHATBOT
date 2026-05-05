import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'omni_chat/themes/app_theme.dart';
import 'omni_chat/providers/chat_session.dart';
import 'omni_chat/screens/chat_screen.dart';

void main() {
  runApp(const OmniChatApp());
}

class OmniChatApp extends StatelessWidget {
  const OmniChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatSessionProvider(),
      child: MaterialApp(
        title: 'OmniChat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const ChatScreen(),
      ),
    );
  }
}