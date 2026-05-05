import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Full-page states: loading, error, and empty.


enum ResponsePageState { loading, error, empty }

class ResponsePage extends StatelessWidget {
  const ResponsePage({
    super.key,
    required this.state,
    this.message,
    this.onRetry,
  });

  final ResponsePageState state;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _icon,
            const SizedBox(height: 16),
            Text(
              message ?? _defaultMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (state == ResponsePageState.error && onRetry != null) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onRetry,
                child: const Text('Try again',
                    style: TextStyle(color: AppTheme.accent)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget get _icon {
    switch (state) {
      case ResponsePageState.loading:
        return const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.accent,
          ),
        );
      case ResponsePageState.error:
        return const Icon(Icons.error_outline_rounded,
            size: 36, color: AppTheme.textMuted);
      case ResponsePageState.empty:
        return const Icon(Icons.auto_awesome_rounded,
            size: 36, color: AppTheme.textMuted);
    }
  }

  String get _defaultMessage {
    switch (state) {
      case ResponsePageState.loading: return 'Loading…';
      case ResponsePageState.error:   return 'Something went wrong.';
      case ResponsePageState.empty:   return 'Start a conversation.';
    }
  }
}