import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.obscureText,
    this.controller,
    this.hintText,
    this.onChanged,
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
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,

        style: TextStyle(fontSize: 12),

        decoration: InputDecoration(
          hintText: hintText ?? '',

          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

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
