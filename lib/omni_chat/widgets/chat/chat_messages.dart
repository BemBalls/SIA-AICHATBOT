import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../themes/app_theme.dart';
import '../chat_bubble.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({
    super.key,
    required this.messages,
    required this.scrollController,
    this.isLoading = false,
    this.bottomPadding = 24,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isLoading;
  final double bottomPadding;

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  void didUpdateWidget(covariant ChatMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (!widget.scrollController.hasClients) return;
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty && !widget.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, size: 36, color: AppTheme.textMuted),
            SizedBox(height: 12),
            Text('Start a conversation', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(top: 8, bottom: widget.bottomPadding),
      itemCount: widget.messages.length + (widget.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.messages.length) {
          return const _TypingIndicator();
        }
        return ChatBubble(message: widget.messages[index]);
      },
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => _Dot(delay: index * 180)),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});
  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Container(
        width: 7,
        height: 7,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: Color.lerp(AppTheme.textMuted, AppTheme.accent, _animation.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
