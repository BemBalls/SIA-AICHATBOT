import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/chat_inputbar.dart';
import '../providers/chat_session.dart';
import '../widgets/app_screen_scaffold.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/chat/chat_empty_state.dart';
import '../widgets/chat/chat_header.dart';
import '../widgets/chat/chat_messages.dart';
import 'chat_sessions_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<ChatSessionProvider>();

    return ChangeNotifierProvider(
      create: (_) => ChatInputProvider(sessionId: session.sessionId),
      child: AppScreenScaffold(
        scaffoldKey: _scaffoldKey,
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            ChatHeader(
              title: AppConstants.appName,
              subtitle: session.previewTitle,
              modelLabel: AppConstants.modelLabel,
              canStartNewChat: session.messages.isNotEmpty,
              onNewChat: session.startNewSession,
              onOpenHistory: () => _scaffoldKey.currentState?.openDrawer(),
              onOpenSettings: () {/* TODO */},
            ),
            const SizedBox(height: 18),
            Expanded(
              child: session.messages.isEmpty && !session.isLoading
                  ? ChatEmptyState(
                      onSuggestionTap: (prompt) {
                        final inputProvider = context.read<ChatInputProvider>();
                        final sessionProvider = context.read<ChatSessionProvider>();
                        inputProvider.sendMessage(
                          prompt,
                          sessionProvider.messages,
                          sessionProvider.addMessage,
                        );
                      },
                    )
                  : ChatMessages(
                      messages: session.messages,
                      scrollController: _scrollController,
                      isLoading: session.isLoading,
                      bottomPadding: MediaQuery.of(context).viewPadding.bottom + 120,
                    ),
            ),
            BottomChatField(sessionId: session.sessionId),
          ],
        ),
      ),
    );
  }
}