import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String imagePath;

  const SocialButton({super.key, required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 55,
        decoration: BoxDecoration(
          color: const Color.fromARGB(179, 251, 112, 38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
