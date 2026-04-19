import 'package:flutter/material.dart';
import '../providers/calculator_provider.dart';

class DisplayArea extends StatefulWidget {
  final String equation;
  final String display;
  final String previousResult;
  final bool hasError;
  final AngleMode angleMode;
  final bool hasMemory;

  const DisplayArea({
    super.key,
    required this.equation,
    required this.display,
    required this.previousResult,
    required this.hasError,
    required this.angleMode,
    required this.hasMemory,
  });

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void didUpdateWidget(DisplayArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.only(left: _animation.value, right: -_animation.value),
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Indicators Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.hasMemory)
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text('M', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ),
                    Text(
                      widget.angleMode == AngleMode.degrees ? 'DEG' : 'RAD',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                if (widget.previousResult.isNotEmpty)
                  Text(
                    'Ans: ${widget.previousResult}',
                    style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 16),
                  ),
              ],
            ),
            const Spacer(),
            // Equation (Scrollable)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                widget.equation.isEmpty ? '' : widget.equation,
                style: const TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            // Result/Display
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.hasError ? 'Error' : widget.display,
                style: TextStyle(
                  fontSize: 64,
                  color: widget.hasError ? Colors.red : Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
