
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = Provider.of<CalculatorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme Selection'),
            subtitle: Text(themeProvider.themeMode.toString().split('.').last.toUpperCase()),
            trailing: const Icon(Icons.palette),
            onTap: () => _showThemeDialog(context, themeProvider),
          ),
          const Divider(),

          ListTile(
            title: const Text('Decimal Precision'),
            subtitle: Slider(
              value: calcProvider.decimalPrecision.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: calcProvider.decimalPrecision.toString(),
              onChanged: (value) {
                calcProvider.setDecimalPrecision(value.toInt());
              },
            ),
            trailing: Text('${calcProvider.decimalPrecision} places'),
          ),
          const Divider(),

          SwitchListTile(
            title: const Text('Angle Mode'),
            subtitle: Text(calcProvider.angleMode == AngleMode.degrees ? 'Degrees' : 'Radians'),
            value: calcProvider.angleMode == AngleMode.degrees,
            secondary: const Icon(Icons.rotate_right),
            onChanged: (value) {
              calcProvider.setAngleMode(value ? AngleMode.degrees : AngleMode.radians);
            },
          ),
          const Divider(),

          SwitchListTile(
            title: const Text('Haptic Feedback'),
            value: calcProvider.hapticFeedback,
            secondary: const Icon(Icons.vibration),
            onChanged: (value) {
              calcProvider.setHapticFeedback(value);
            },
          ),
          const Divider(),

          SwitchListTile(
            title: const Text('Sound Effects'),
            value: calcProvider.soundEffects,
            secondary: const Icon(Icons.volume_up),
            onChanged: (value) {
              calcProvider.setSoundEffects(value);
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('History Size'),
            subtitle: Text('${calcProvider.maxHistorySize} calculations'),
            trailing: const Icon(Icons.history),
            onTap: () => _showHistorySizeDialog(context, calcProvider),
          ),
          const Divider(),

          ListTile(
            title: const Text('Clear All History', style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () => _showClearHistoryConfirmation(context, calcProvider),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: provider.themeMode,
              onChanged: (mode) {
                provider.setTheme(mode!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: provider.themeMode,
              onChanged: (mode) {
                provider.setTheme(mode!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: provider.themeMode,
              onChanged: (mode) {
                provider.setTheme(mode!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHistorySizeDialog(BuildContext context, CalculatorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Max History Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [25, 50, 100].map((size) {
            return RadioListTile<int>(
              title: Text('$size calculations'),
              value: size,
              groupValue: provider.maxHistorySize,
              onChanged: (value) {
                provider.setMaxHistorySize(value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showClearHistoryConfirmation(BuildContext context, CalculatorProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('This will permanently delete all calculation history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared')),
              );
            },
            child: const Text('CLEAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
