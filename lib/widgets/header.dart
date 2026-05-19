import 'package:flutter/material.dart';

const Color globalOrange = Color.fromARGB(179, 251, 112, 38);

class Header extends StatefulWidget {
  final String header, subheader;
  final List<Widget> children;
  final VoidCallback? onFinished;

  const Header({
    super.key,
    required this.header,
    required this.subheader,
    this.children = const [],
    required this.onFinished,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward().then((_) {
      widget.onFinished?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: -1,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(179, 251, 112, 38),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                widget.header,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.subheader,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              if (widget.children.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...widget.children,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final void Function() onPressed;
  const HeaderButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(179, 251, 112, 38),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Icon(icon, size: size),
        ),
      ),
    );
  }
}
