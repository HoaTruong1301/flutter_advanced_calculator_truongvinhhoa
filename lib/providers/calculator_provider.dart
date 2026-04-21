import 'package:flutter/material.dart';
import '../utils/calculator_logic.dart';
import '../services/storage_service.dart';
import '../models/calculator_mode.dart';

enum AngleMode { degrees, radians }
enum NumberBase { hex, dec, oct, bin }

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  NumberBase _currentBase = NumberBase.dec;
  
  double _memory = 0;
  bool _hasMemory = false;
  bool _hasError = false;
  String _previousResult = '';
  List<String> _history = [];
  bool _isSecondFunction = false;
  double _fontSize = 64.0;

  // New Settings
  int _decimalPrecision = 7;
  bool _hapticFeedback = true;
  bool _soundEffects = false;
  int _maxHistorySize = 50;

  // Getters
  String get display => _result;
  String get equation => _expression;
  String get previousResult => _previousResult;
  CalculatorMode get mode => _mode;
  bool get isScientific => _mode == CalculatorMode.scientific;
  bool get isProgrammer => _mode == CalculatorMode.programmer;
  AngleMode get angleMode => _angleMode;
  NumberBase get currentBase => _currentBase;
  bool get hasMemory => _hasMemory;
  bool get hasError => _hasError;
  List<String> get history => _history;
  bool get isSecondFunction => _isSecondFunction;
  double get fontSize => _fontSize;
  
  int get decimalPrecision => _decimalPrecision;
  bool get hapticFeedback => _hapticFeedback;
  bool get soundEffects => _soundEffects;
  int get maxHistorySize => _maxHistorySize;

  CalculatorProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _history = await StorageService.getHistory();
    _mode = await StorageService.getCalculatorMode();
    _memory = await StorageService.getMemory();
    _hasMemory = _memory != 0;
    bool isDeg = await StorageService.getAngleMode();
    _angleMode = isDeg ? AngleMode.degrees : AngleMode.radians;
    
    // Load new settings
    _decimalPrecision = await StorageService.getDecimalPrecision();
    _hapticFeedback = await StorageService.getHapticFeedback();
    _soundEffects = await StorageService.getSoundEffects();
    _maxHistorySize = await StorageService.getMaxHistorySize();
    
    notifyListeners();
  }

  void setMode(CalculatorMode mode) {
    _mode = mode;
    StorageService.saveCalculatorMode(mode);
    notifyListeners();
  }

  void setDecimalPrecision(int precision) {
    _decimalPrecision = precision;
    StorageService.saveDecimalPrecision(precision);
    notifyListeners();
  }

  void setAngleMode(AngleMode mode) {
    _angleMode = mode;
    StorageService.saveAngleMode(mode == AngleMode.degrees);
    notifyListeners();
  }

  void setHapticFeedback(bool enabled) {
    _hapticFeedback = enabled;
    StorageService.saveHapticFeedback(enabled);
    notifyListeners();
  }

  void setSoundEffects(bool enabled) {
    _soundEffects = enabled;
    StorageService.saveSoundEffects(enabled);
    notifyListeners();
  }

  void setMaxHistorySize(int size) {
    _maxHistorySize = size;
    StorageService.saveMaxHistorySize(size);
    if (_history.length > _maxHistorySize) {
      _history = _history.take(_maxHistorySize).toList();
      StorageService.saveHistory(_history);
    }
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size.clamp(30.0, 100.0);
    notifyListeners();
  }

  void toggleSecondFunction() {
    _isSecondFunction = !_isSecondFunction;
    notifyListeners();
  }

  void setNumberBase(NumberBase base) {
    if (_mode != CalculatorMode.programmer) return;
    try {
      int val = int.parse(_result, radix: _getRadix(_currentBase));
      _currentBase = base;
      _result = val.toRadixString(_getRadix(base)).toUpperCase();
    } catch (e) {
      _result = '0';
    }
    _currentBase = base;
    notifyListeners();
  }

  int _getRadix(NumberBase base) {
    switch (base) {
      case NumberBase.hex: return 16;
      case NumberBase.oct: return 8;
      case NumberBase.bin: return 2;
      default: return 10;
    }
  }

  void press(String value) {
    _hasError = false;
    
    if (value == 'C' || value == 'AC') {
      _expression = '';
      _result = '0';
      _previousResult = '';
    } else if (value == 'CE') {
      clearEntry();
    } else if (value == '=') {
      _calculate();
    } else if (value == '±') {
      _toggleSign();
    } else if (value == '2nd') {
      toggleSecondFunction();
    } else if (['MC', 'MR', 'M+', 'M-'].contains(value)) {
      _handleMemory(value);
    } else if (['HEX', 'DEC', 'OCT', 'BIN'].contains(value)) {
      setNumberBase(NumberBase.values[ ['HEX', 'DEC', 'OCT', 'BIN'].indexOf(value) ]);
    } else if (value == 'DEG' || value == 'RAD') {
       setAngleMode(value == 'DEG' ? AngleMode.degrees : AngleMode.radians);
    } else {
      _addToExpression(value);
    }
    notifyListeners();
  }

  void clearEntry() {
    if (_result.length > 1) {
      _result = _result.substring(0, _result.length - 1);
    } else {
      _result = '0';
    }
    if (_expression.isNotEmpty) _expression = _expression.substring(0, _expression.length - 1);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    StorageService.saveHistory(_history);
    notifyListeners();
  }

  void _toggleSign() {
    if (_result.startsWith('-')) {
      _result = _result.substring(1);
    } else if (_result != '0') {
      _result = '-$_result';
    }
  }

  void _addToExpression(String value) {
    if (_result == '0' && !['+', '-', '×', '÷', '%'].contains(value)) {
      _result = value;
    } else {
      _result += value;
    }

    String op = value;
    if (op == '×') op = '*';
    if (op == '÷') op = '/';
    
    Map<String, String> map = {
      'sin': 'sin(', 'cos': 'cos(', 'tan': 'tan(',
      'asin': 'asin(', 'acos': 'acos(', 'atan': 'atan(',
      'Ln': 'ln(', 'log': 'log10(', 'x²': '^2', 'x³': '^3', 'x^y': '^', '√': 'sqrt(',
      'π': 'pi', 'e': 'e', 'AND': '&', 'OR': '|', 'XOR': '^', 'NOT': '~',
      'Lsh': '<<', 'Rsh': '>>', 'n!': '!'
    };

    _expression += map[value] ?? op;
  }

  void _calculate() {
    try {
      String res = CalculatorLogic.calculate(
        _expression, 
        angleMode: _angleMode, 
        precision: _decimalPrecision,
        isProgrammer: _mode == CalculatorMode.programmer,
      );
      if (res == "Error") {
        _hasError = true;
      } else {
        _previousResult = _result;
        _result = res;
        _history.insert(0, "$_expression = $res");
        if (_history.length > _maxHistorySize) _history.removeLast();
        StorageService.saveHistory(_history);
        _expression = res;
      }
    } catch (e) {
      _hasError = true;
    }
  }

  void _handleMemory(String action) {
    double val = double.tryParse(_result) ?? 0;
    switch (action) {
      case 'MC': _memory = 0; _hasMemory = false; break;
      case 'MR': _result = _memory.toString(); _expression += _memory.toString(); break;
      case 'M+': _memory += val; _hasMemory = true; break;
      case 'M-': _memory -= val; _hasMemory = true; break;
    }
    StorageService.saveMemory(_memory);
  }

  void reuseHistory(String entry) {
    _result = entry.split(' = ').last;
    _expression = _result;
    notifyListeners();
  }
}
