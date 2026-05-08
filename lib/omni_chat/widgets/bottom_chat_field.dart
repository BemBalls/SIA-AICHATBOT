import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_inputbar.dart';
import '../providers/chat_session.dart';
import '../themes/app_theme.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key, required this.sessionId});

  final String sessionId;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputProvider = context.watch<ChatInputProvider>();
    final sessionProvider = context.read<ChatSessionProvider>();
    final canSend = inputProvider.hasDraft && !inputProvider.isLoading;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.surface.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.send,
                          minLines: 1,
                          maxLines: 5,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(color: AppTheme.textSecondary),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          ),
                          onChanged: inputProvider.updateDraft,
                          onSubmitted: (_) => _send(inputProvider, sessionProvider),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: canSend ? AppTheme.accent : AppTheme.surfaceAlt,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: canSend ? () => _send(inputProvider, sessionProvider) : null,
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
                                      size: 20,
                                      color: canSend ? Colors.white : AppTheme.textMuted,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _send(ChatInputProvider inputProvider, ChatSessionProvider sessionProvider) {
    if (_controller.text.trim().isEmpty || inputProvider.isLoading) return;
    inputProvider.sendMessage(
      _controller.text.trim(),
      sessionProvider.messages,
      sessionProvider.addMessage,
    );
    _controller.clear();
    inputProvider.clearDraft();
  }
}
