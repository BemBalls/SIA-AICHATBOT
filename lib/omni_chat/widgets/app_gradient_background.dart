import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final topColor = Color.lerp(AppTheme.background, AppTheme.surfaceAlt, 0.18)!;
    final middleColor = Color.lerp(AppTheme.background, AppTheme.accentDim, 0.08)!;
    final bottomColor = Color.lerp(AppTheme.background, AppTheme.accent, 0.14)!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [topColor, middleColor, bottomColor],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            left: -60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.14),
                    blurRadius: 180,
                    spreadRadius: 88,
                  ),
                ],
              ),
              child: const SizedBox.square(dimension: 200),
            ),
          ),
          Positioned(
            right: -90,
            top: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentDim.withValues(alpha: 0.12),
                    blurRadius: 170,
                    spreadRadius: 84,
                  ),
                ],
              ),
              child: const SizedBox.square(dimension: 180),
            ),
          ),
          Positioned(
            bottom: -130,
            left: -20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.background.withValues(alpha: 0.14),
                    blurRadius: 180,
                    spreadRadius: 88,
                  ),
                ],
              ),
              child: const SizedBox.square(dimension: 190),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -70,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.08),
                    blurRadius: 140,
                    spreadRadius: 72,
                  ),
                ],
              ),
              child: const SizedBox.square(dimension: 130),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
