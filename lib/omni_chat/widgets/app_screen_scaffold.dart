import 'package:flutter/material.dart';
import 'app_gradient_background.dart';

class AppScreenScaffold extends StatelessWidget {
  const AppScreenScaffold({
    super.key,
    this.scaffoldKey,
    this.drawer,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget? drawer;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: drawer,
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SizedBox.expand(
        child: AppGradientBackground(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
