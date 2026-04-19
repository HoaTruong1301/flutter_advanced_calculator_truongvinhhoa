import 'package:flutter/material.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  final List<List<String>> rows;
  final Function(String) onButtonPressed;
  final Function(String)? onLongPress;
  final bool isBasic;

  const ButtonGrid({
    super.key,
    required this.rows,
    required this.onButtonPressed,
    this.onLongPress,
    this.isBasic = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((btn) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CalculatorButton(
                  text: btn,
                  aspectRatio: isBasic ? 1.0 : 1.2,
                  fontSize: isBasic ? 24 : 16,
                  color: _getButtonColor(btn),
                  onPressed: () => onButtonPressed(btn),
                  onLongPress: onLongPress != null ? () => onLongPress!(btn) : null,
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Color _getButtonColor(String text) {
    if (text == '=') return Colors.orange;
    if (['+', '-', '×', '÷'].contains(text)) return Colors.orange.withOpacity(0.8);
    if (['C', 'CE', 'MC', 'MR', 'M+', 'M-'].contains(text)) return Colors.grey[700]!;
    return const Color(0xFF333333);
  }
}
