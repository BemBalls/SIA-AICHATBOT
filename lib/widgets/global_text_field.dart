import 'package:flutter/material.dart';

class GlobalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const GlobalTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: Color.fromARGB(179, 251, 112, 38),
        selectionColor: Color.fromARGB(80, 251, 112, 38),
        selectionHandleColor: Color.fromARGB(179, 251, 112, 38),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 12),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(179, 251, 112, 38),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
