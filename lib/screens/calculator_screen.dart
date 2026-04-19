import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculatorProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          calc.mode == CalculatorMode.basic
              ? 'Basic'
              : calc.mode == CalculatorMode.scientific
                  ? 'Scientific'
                  : 'Programmer',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          PopupMenuButton<CalculatorMode>(
            icon: const Icon(Icons.swap_horiz),
            onSelected: (mode) => calc.setMode(mode),
            itemBuilder: (context) => [
              const PopupMenuItem(value: CalculatorMode.basic, child: Text('Basic Mode')),
              const PopupMenuItem(value: CalculatorMode.scientific, child: Text('Scientific Mode')),
              const PopupMenuItem(value: CalculatorMode.programmer, child: Text('Programmer Mode')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                DisplayArea(
                  equation: calc.equation,
                  display: calc.display,
                  previousResult: calc.previousResult,
                  hasError: calc.hasError,
                  angleMode: calc.angleMode,
                  hasMemory: calc.hasMemory,
                ),
                // Separate Gesture Detectors to avoid conflicts
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        calc.clearEntry(); // Swipe right
                      }
                    },
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryScreen()),
                        ); // Swipe up
                      }
                    },
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onScaleUpdate: (details) {
                      if (details.scale != 1.0) {
                        calc.setFontSize(calc.fontSize * (details.scale > 1 ? 1.01 : 0.99));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          if (calc.history.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: calc.history.length > 3 ? 3 : calc.history.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => calc.reuseHistory(calc.history[index]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        calc.history[index].split(' = ').last,
                        style: const TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),

          const Divider(height: 1),

          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildCurrentModeGrid(context, calc),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentModeGrid(BuildContext context, CalculatorProvider calc) {
    switch (calc.mode) {
      case CalculatorMode.scientific:
        return _buildScientificMode(calc);
      case CalculatorMode.programmer:
        return _buildProgrammerMode(calc);
      case CalculatorMode.basic:
      default:
        return _buildBasicMode(calc);
    }
  }

  Widget _buildBasicMode(CalculatorProvider calc) {
    return ButtonGrid(
      rows: const [
        ['C', 'CE', '%', '÷'],
        ['7', '8', '9', '×'],
        ['4', '5', '6', '-'],
        ['1', '2', '3', '+'],
        ['±', '0', '.', '='],
      ],
      onButtonPressed: (value) => calc.press(value),
      onLongPress: (value) {
        if (value == 'C') calc.clearHistory();
      },
      isBasic: true,
    );
  }

  Widget _buildScientificMode(CalculatorProvider calc) {
    return ButtonGrid(
      rows: const [
        ['2nd', 'sin', 'cos', 'tan', 'Ln', 'log'],
        ['x²', '√', 'x^y', '(', ')', '÷'],
        ['MC', '7', '8', '9', 'C', '×'],
        ['MR', '4', '5', '6', 'CE', '-'],
        ['M+', '1', '2', '3', '%', '+'],
        ['M-', '±', '0', '.', 'π', '='],
      ],
      onButtonPressed: (value) => calc.press(value),
      isBasic: false,
    );
  }

  Widget _buildProgrammerMode(CalculatorProvider calc) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _baseButton('HEX', calc),
              _baseButton('DEC', calc),
              _baseButton('OCT', calc),
              _baseButton('BIN', calc),
            ],
          ),
        ),
        Expanded(
          child: ButtonGrid(
            rows: const [
              ['A', 'B', 'Lsh', 'Rsh', 'C', 'CE'],
              ['C', 'D', 'AND', 'OR', '(', ')'],
              ['E', 'F', 'XOR', 'NOT', '÷', '×'],
              ['7', '8', '9', '4', '5', '6'],
              ['1', '2', '3', '0', '-', '+'],
              ['±', '.', '00', 'Ans', '=', ''],
            ],
            onButtonPressed: (value) => calc.press(value),
            isBasic: false,
          ),
        ),
      ],
    );
  }

  Widget _baseButton(String label, CalculatorProvider calc) {
    bool isSelected = calc.currentBase.toString().split('.').last.toUpperCase() == label;
    return GestureDetector(
      onTap: () => calc.press(label),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.orange : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
