import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final Color? color;
  final double fontSize;
  final double aspectRatio;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onLongPress,
    this.color,
    this.fontSize = 24,
    this.aspectRatio = 1.0,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.color ?? const Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
