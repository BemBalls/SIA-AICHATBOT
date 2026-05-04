import 'package:flutter/material.dart';
import 'chat_session.dart';

class ChatSessionsDrawer extends StatelessWidget {
  final List<ChatSession> sessions;
  final String activeSessionId;
  final VoidCallback onNewChat;
  final Function(ChatSession) onSelectSession;
  final Function(ChatSession) onDeleteSession;

  const ChatSessionsDrawer({
    super.key,
    required this.sessions,
    required this.activeSessionId,
    required this.onNewChat,
    required this.onSelectSession,
    required this.onDeleteSession,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF5F5F0),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x14000000), width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Jim Chat',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onNewChat,
                      icon: const Icon(Icons.add, size: 18, color: Colors.black),
                      label: const Text('New Chat', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9F6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  final isActive = session.id == activeSessionId;
                  return ListTile(
                    selected: isActive,
                    title: Text(
                      session.displayTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive ? const Color(0xFFFF9F6D) : const Color(0xFF1A1A1A),
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      onSelectSession(session);
                      Navigator.pop(context);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => onDeleteSession(session),
                      color: const Color(0xFF999999),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}