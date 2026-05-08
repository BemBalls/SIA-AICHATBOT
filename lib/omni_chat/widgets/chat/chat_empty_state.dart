import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../themes/app_theme.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({
    super.key,
    required this.onSuggestionTap,
    this.showStarterPrompts = true,
  });

  final ValueChanged<String> onSuggestionTap;
  final bool showStarterPrompts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 44),
          Text(
            'How can I help?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Start with a prompt below.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          if (showStarterPrompts) ...[
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.starterPrompts
                  .map(
                    (prompt) => ActionChip(
                      avatar: const Icon(CupertinoIcons.sparkles, size: 14),
                      label: Text(prompt),
                      onPressed: () => onSuggestionTap(prompt),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
