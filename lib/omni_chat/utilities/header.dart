import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Top app-bar with title, model badge, and action icons.
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.title,
    required this.modelLabel,
    required this.canStartNewChat,
    required this.onNewChat,
    required this.onOpenHistory,
    required this.onOpenSettings,
  });

  final String title;
  final String modelLabel;
  final bool canStartNewChat;
  final VoidCallback onNewChat;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenSettings;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          // ── Left: title + badge ──
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 2),
                _ModelBadge(label: modelLabel),
              ],
            ),
          ),

          // ── Right: icons ──
          _AppBarIcon(
            icon: CupertinoIcons.square_pencil,
            tooltip: 'New chat',
            enabled: canStartNewChat,
            onTap: onNewChat,
          ),
          _AppBarIcon(
            icon: CupertinoIcons.clock,
            tooltip: 'History',
            onTap: onOpenHistory,
          ),
          _AppBarIcon(
            icon: CupertinoIcons.slider_horizontal_3,
            tooltip: 'Settings',
            onTap: onOpenSettings,
          ),
        ],
      ),
    );
  }
}

class _ModelBadge extends StatelessWidget {
  const _ModelBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.sparkles,
              size: 11, color: AppTheme.accent),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  const _AppBarIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon,
              size: 19,
              color: enabled ? AppTheme.textSecondary : AppTheme.textMuted),
        ),
      ),
    );
  }
}