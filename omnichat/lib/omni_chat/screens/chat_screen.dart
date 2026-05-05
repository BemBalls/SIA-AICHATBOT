import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/chat_session.dart';
import '../utilities/header.dart';
import '../widgets/chat_messagelist.dart';
import '../widgets/chat_service.dart';
import 'chat_sessions_drawer.dart';

/// Main chat screen 
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final session = context.watch<ChatSessionProvider>();

    return ChangeNotifierProvider(
      create: (_) => ChatInputProvider(sessionId: session.sessionId),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: ChatSessionsDrawer(
          sessionIds:      session.sessionIds,
          activeSessionId: session.sessionId,
          getTitle: (id) => id == session.sessionId
              ? session.previewTitle
              : 'Session $id',
          onSelectSession: session.loadSession,
          onDeleteSession: session.deleteSession,
          onNewSession:    session.startNewSession,
        ),
        appBar: ChatAppBar(
          title:          AppConstants.appName,
          modelLabel:     AppConstants.modelLabel,
          canStartNewChat: session.messages.isNotEmpty,
          onNewChat:       session.startNewSession,
          onOpenHistory:   () => _scaffoldKey.currentState?.openDrawer(),
          onOpenSettings:  () {/* TODO */},
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatMessageList(
                messages:  session.messages,
                isLoading: session.isLoading,
              ),
            ),
            ChatService(sessionId: session.sessionId),
          ],
        ),
      ),
    );
  }
}