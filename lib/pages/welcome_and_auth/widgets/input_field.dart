import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextSelectionTheme(
        data: TextSelectionThemeData(
          cursorColor: Color.fromARGB(179, 251, 112, 38),
          selectionColor: Color.fromARGB(80, 251, 112, 38),
          selectionHandleColor: Color.fromARGB(179, 251, 112, 38),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
    );
  }
}
