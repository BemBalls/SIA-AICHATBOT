import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../app_icon_button.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.modelLabel,
    required this.canStartNewChat,
    required this.onOpenHistory,
    required this.onOpenSettings,
    required this.onNewChat,
  });

  final String title;
  final String subtitle;
  final String modelLabel;
  final bool canStartNewChat;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenSettings;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CompactMetric(icon: CupertinoIcons.sparkles, label: modelLabel),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: CupertinoIcons.square_pencil,
              tooltip: 'New chat',
              isEnabled: canStartNewChat,
              onTap: onNewChat,
            ),
            const SizedBox(width: 8),
            AppIconButton(
              icon: CupertinoIcons.clock,
              tooltip: 'History',
              onTap: onOpenHistory,
            ),
            const SizedBox(width: 8),
            AppIconButton(
              icon: CupertinoIcons.settings,
              tooltip: 'Settings',
              onTap: onOpenSettings,
            ),
          ],
        ),
      ],
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppTheme.textSecondary),
            const SizedBox(width: 5),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
