/// App-wide constants — one place to update strings, sizes, durations.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName    = 'OmniChat';
  static const String modelLabel = 'Gemini';

  // UI
  static const double borderRadius      = 14.0;
  static const double bubbleBorderRadius = 16.0;
  static const double drawerWidth       = 280.0;
  static const double inputMaxLines     = 5.0;
  static const List<String> starterPrompts = [
    'Summarize my day in one sentence',
    'Explain Flutter widgets simply',
    'Give me a quick productivity tip',
  ];

  // Durations
  static const Duration animShort  = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration typingDot  = Duration(milliseconds: 600);

  // Storage keys
  static const String keySessionList = 'session_list';
  static const String keyActiveSession = 'active_session';
}