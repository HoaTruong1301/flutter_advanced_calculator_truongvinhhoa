import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculator_mode.dart';

class StorageService {
  static const String _keyHistory = 'calculator_history';
  static const String _keyTheme = 'theme_mode';
  static const String _keyMode = 'calculator_mode';
  static const String _keyMemory = 'memory_value';
  static const String _keyAngle = 'angle_mode';
  static const String _keyPrecision = 'decimal_precision';
  static const String _keyHaptic = 'haptic_feedback';
  static const String _keySound = 'sound_effects';
  static const String _keyMaxHistory = 'max_history_size';

  static Future<void> saveHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyHistory, history);
  }

  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyHistory) ?? [];
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode.toString());
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyTheme);
    if (value == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere((e) => e.toString() == value, orElse: () => ThemeMode.system);
  }

  static Future<void> saveCalculatorMode(CalculatorMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMode, mode.toString());
  }

  static Future<CalculatorMode> getCalculatorMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyMode);
    if (value == null) return CalculatorMode.basic;
    return CalculatorMode.values.firstWhere((e) => e.toString() == value, orElse: () => CalculatorMode.basic);
  }

  static Future<void> saveMemory(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyMemory, value);
  }

  static Future<double> getMemory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyMemory) ?? 0.0;
  }

  static Future<void> saveAngleMode(bool isDegrees) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAngle, isDegrees);
  }

  static Future<bool> getAngleMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAngle) ?? true;
  }

  static Future<void> saveDecimalPrecision(int precision) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPrecision, precision);
  }

  static Future<int> getDecimalPrecision() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPrecision) ?? 7;
  }

  static Future<void> saveHapticFeedback(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptic, enabled);
  }

  static Future<bool> getHapticFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHaptic) ?? true;
  }

  static Future<void> saveSoundEffects(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySound, enabled);
  }

  static Future<bool> getSoundEffects() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySound) ?? false;
  }

  static Future<void> saveMaxHistorySize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMaxHistory, size);
  }

  static Future<int> getMaxHistorySize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxHistory) ?? 50;
  }
}
