import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const AuthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 16),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: onPressed,
          style:
              ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(179, 251, 112, 38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ).copyWith(
                overlayColor: WidgetStatePropertyAll(
                  Color.fromARGB(60, 251, 112, 38),
                ),
              ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
