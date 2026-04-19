import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<String> _history = [];
  List<String> get history => _history;

  HistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = await StorageService.getHistory();
    notifyListeners();
  }

  void addHistory(String entry) {
    _history.add(entry);
    StorageService.saveHistory(_history);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    StorageService.saveHistory(_history);
    notifyListeners();
  }
}
