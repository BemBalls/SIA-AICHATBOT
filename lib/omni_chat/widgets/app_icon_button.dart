import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.isEnabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Opacity(
        opacity: isEnabled ? 1 : 0.42,
        child: IconButton(
          onPressed: isEnabled ? onTap : null,
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.surfaceAlt,
            foregroundColor: AppTheme.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.border),
            ),
            minimumSize: const Size(42, 42),
            padding: EdgeInsets.zero,
          ),
          icon: Icon(icon, size: 20),
        ),
      ),
    );
  }
}
