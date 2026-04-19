import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => historyProvider.clearHistory(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: historyProvider.history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(historyProvider.history[index]),
          );
        },
      ),
    );
  }
}
