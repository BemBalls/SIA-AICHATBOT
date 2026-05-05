import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_inputbar.dart';
import '../providers/chat_session.dart';
import '../themes/app_theme.dart';

/// Input bar widget wired to [ChatInputProvider].
/// Placed at the bottom of [ChatScreen].
class ChatService extends StatefulWidget {
  const ChatService({super.key, required this.sessionId});
  final String sessionId;

  @override
  State<ChatService> createState() => _ChatServiceState();
}

class _ChatServiceState extends State<ChatService> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = context.watch<ChatInputProvider>();
    final sessionProvider = context.read<ChatSessionProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Text field ──
            Expanded(
              child: TextField(
                controller: _ctrl,
                maxLines: 5,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                    color: AppTheme.textPrimary, fontSize: 14),
                decoration: const InputDecoration(hintText: 'Message…'),
                onChanged: inputProvider.updateDraft,
                onSubmitted: (_) => _send(inputProvider, sessionProvider),
              ),
            ),
            const SizedBox(width: 8),

            // ── Send button ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: inputProvider.hasDraft && !inputProvider.isLoading
                    ? AppTheme.accent
                    : AppTheme.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _send(inputProvider, sessionProvider),
                  child: Center(
                    child: inputProvider.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.textSecondary,
                            ),
                          )
                        : Icon(
                            CupertinoIcons.arrow_up,
                            size: 18,
                            color: inputProvider.hasDraft
                                ? Colors.white
                                : AppTheme.textMuted,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send(ChatInputProvider input, ChatSessionProvider session) {
    if (_ctrl.text.trim().isEmpty || input.isLoading) return;
    input.sendMessage(
      _ctrl.text,
      session.messages,
      session.addMessage,
    );
    _ctrl.clear();
    input.clearDraft();
  }
}