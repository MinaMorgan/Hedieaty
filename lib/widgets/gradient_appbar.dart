import 'package:flutter/material.dart';

class GradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showButton;
  final VoidCallback? onButtonPressed;

  const GradientAppBar({
    super.key,
    required this.title,
    this.showButton = false,
    this.onButtonPressed,
  });

  @override
  _GradientAppBarState createState() => _GradientAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF1E3A8A), Color(0xFF1E88E5)],
          ),
        ),
        child: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            if (widget.showButton)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: widget.onButtonPressed, // Call the provided callback
              ),
          ],
        ),
      ),
    );
  }
}
