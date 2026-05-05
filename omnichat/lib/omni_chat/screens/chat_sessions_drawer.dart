import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../constants/app_constants.dart';

/// Slide-in drawer listing all past sessions.
class ChatSessionsDrawer extends StatelessWidget {
  const ChatSessionsDrawer({
    super.key,
    required this.sessionIds,
    required this.activeSessionId,
    required this.getTitle,
    required this.onSelectSession,
    required this.onDeleteSession,
    required this.onNewSession,
  });

  final List<String> sessionIds;
  final String activeSessionId;
  final String Function(String id) getTitle;
  final void Function(String id) onSelectSession;
  final void Function(String id) onDeleteSession;
  final VoidCallback onNewSession;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.surface,
      width: AppConstants.drawerWidth,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
              child: Row(
                children: [
                  const Text('History',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onNewSession();
                    },
                    child: const Icon(CupertinoIcons.square_pencil,
                        size: 18, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ── Session list ──
            Expanded(
              child: sessionIds.isEmpty
                  ? const Center(
                      child: Text('No history yet',
                          style: TextStyle(color: AppTheme.textMuted)))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: sessionIds.length,
                      separatorBuilder: (_, _) => const Divider(
                          height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, i) {
                        final id = sessionIds[i];
                        final isActive = id == activeSessionId;
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            onSelectSession(id);
                          },
                          tileColor: isActive
                              ? AppTheme.accentDim.withOpacity(0.25)
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          title: Text(
                            getTitle(id),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isActive
                                  ? AppTheme.accent
                                  : AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => onDeleteSession(id),
                            child: const Icon(CupertinoIcons.trash,
                                size: 15, color: AppTheme.textMuted),
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