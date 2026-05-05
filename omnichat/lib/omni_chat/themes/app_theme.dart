import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Palette ───────────────────────────────────────────────
  static const Color background  = Color(0xFF0D0D0D);
  static const Color surface     = Color(0xFF1A1A1A);
  static const Color surfaceAlt  = Color(0xFF242424);
  static const Color border      = Color(0xFF2E2E2E);
  static const Color accent      = Color(0xFF5B8EF4);
  static const Color accentDim   = Color(0xFF2A3F7A);
  static const Color textPrimary   = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textMuted     = Color(0xFF666666);

  // Bubble colours
  static const Color userBubbleBg   = accentDim;
  static const Color userBubbleText = Color(0xFFD0DCFF);
  static const Color botBubbleBg    = surfaceAlt;
  static const Color botBubbleText  = textPrimary;

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          surface:              surface,
          primary:              accent,
          onPrimary:            Colors.white,
          onSurface:            textPrimary,
          onSurfaceVariant:     textSecondary,
          outline:              border,
          outlineVariant:       border,
          surfaceContainerHigh: surfaceAlt,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor:  background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textSecondary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          hintStyle: const TextStyle(color: textMuted, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: accent, width: 1.5)),
        ),
        textTheme: const TextTheme(
          titleLarge:  TextStyle(color: textPrimary,   fontSize: 18, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: textPrimary,   fontSize: 15, fontWeight: FontWeight.w500),
          bodyMedium:  TextStyle(color: textPrimary,   fontSize: 14, height: 1.5),
          bodySmall:   TextStyle(color: textSecondary, fontSize: 12),
          labelLarge:  TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
          labelSmall:  TextStyle(color: textMuted,     fontSize: 11),
        ),
        dividerTheme:
            const DividerThemeData(color: border, thickness: 1, space: 1),
        iconTheme: const IconThemeData(color: textSecondary, size: 20),
      );
}