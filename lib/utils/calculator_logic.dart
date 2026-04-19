import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';
import '../providers/calculator_provider.dart';
import 'dart:math' as math;

/// Lớp tiện ích xử lý logic tính toán cho ứng dụng máy tính.
/// Sử dụng thư viện math_expressions và bổ sung các tính năng nâng cao.
class CalculatorLogic {
  
  /// Hàm chính để tính toán biểu thức chuỗi.
  /// [equation]: Biểu thức toán học cần tính.
  /// [angleMode]: Chế độ góc (Độ hoặc Radian).
  /// [precision]: Số chữ số thập phân sau dấu phẩy.
  /// [isProgrammer]: Cờ xác định có đang ở chế độ Lập trình viên hay không.
  static String calculate(String equation, {
    AngleMode angleMode = AngleMode.degrees, 
    int precision = 7,
    bool isProgrammer = false,
  }) {
    try {
      if (equation.isEmpty) return "0";

      // Xử lý riêng cho chế độ Lập trình viên (Bitwise & Hex)
      if (isProgrammer || equation.contains(RegExp(r'[&|^~]|<<|>>|[A-F]'))) {
        return _calculateBitwise(equation);
      }
      
      // Chuyển đổi các ký tự hiển thị sang ký tự toán học chuẩn
      String processedExp = equation
          .replaceAll('×', '*')
          .replaceAll('÷', '/');

      // Tự động cân bằng dấu ngoặc: Thêm dấu đóng ngoặc thiếu vào cuối chuỗi
      int openBrackets = 0;
      for (int i = 0; i < processedExp.length; i++) {
        if (processedExp[i] == '(') openBrackets++;
        if (processedExp[i] == ')') openBrackets--;
      }
      while (openBrackets > 0) {
        processedExp += ')';
        openBrackets--;
      }

      // Xử lý nhân ẩn (ví dụ: 2pi -> 2*pi, 2( -> 2*( )
      processedExp = processedExp.replaceAllMapped(RegExp(r'(\d)(\(|pi|e|sin|cos|tan|ln|log|sqrt)'), (match) {
        return '${match.group(1)}*${match.group(2)}';
      });

      // Chuyển đổi từ Độ sang Radian cho các hàm lượng giác nếu đang ở chế độ Degrees
      if (angleMode == AngleMode.degrees) {
        final trigFunctions = ['sin', 'cos', 'tan', 'asin', 'acos', 'atan'];
        for (var func in trigFunctions) {
          int index = 0;
          while ((index = processedExp.indexOf('$func(', index)) != -1) {
            int start = index + func.length + 1;
            int end = _findClosingBracket(processedExp, start);
            if (end != -1) {
              String arg = processedExp.substring(start, end);
              String replacement = func.startsWith('a') ? '($func($arg)*180/pi)' : '$func($arg*pi/180)';
              processedExp = processedExp.replaceRange(index, end + 1, replacement);
              index += replacement.length;
            } else { index++; }
          }
        }
      }

      // Khởi tạo Parser và Context để đánh giá biểu thức
      Parser p = Parser();
      Expression exp = p.parse(processedExp);
      ContextModel cm = ContextModel();
      
      // Gán giá trị cho các hằng số toán học
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      // Thực hiện tính toán kết quả số thực
      double result = exp.evaluate(EvaluationType.REAL, cm);
      if (result.isNaN || result.isInfinite) return "Error";

      // Định dạng kết quả hiển thị dựa trên độ chính xác (precision)
      String pattern = "###." + ("#" * precision);
      final formatter = NumberFormat(pattern, "en_US");
      String formatted = formatter.format(result);
      if (formatted.endsWith('.0')) formatted = formatted.substring(0, formatted.length - 2);
      return formatted;
    } catch (e) {
      return "Error";
    }
  }

  /// Bộ xử lý chuyên biệt cho chế độ Lập trình viên (Hỗ trợ Hex và Bitwise)
  static String _calculateBitwise(String equation) {
    try {
      String exp = equation.replaceAll('0x', '').replaceAll(' ', '');
      
      // Chuyển đổi tất cả các toán hạng Hex sang Thập phân
      exp = exp.replaceAllMapped(RegExp(r'[0-9A-F]+'), (match) {
        String val = match.group(0)!;
        if (RegExp(r'[A-F]').hasMatch(val)) {
          return int.parse(val, radix: 16).toString();
        }
        return val;
      });

      // Xử lý các phép toán Bitwise AND, OR, XOR thủ công
      if (exp.contains('&')) {
        var parts = exp.split('&');
        return (int.parse(parts[0]) & int.parse(parts[1])).toRadixString(16).toUpperCase();
      }
      if (exp.contains('|')) {
        var parts = exp.split('|');
        return (int.parse(parts[0]) | int.parse(parts[1])).toRadixString(16).toUpperCase();
      }
      if (exp.contains('^')) {
        var parts = exp.split('^');
        return (int.parse(parts[0]) ^ int.parse(parts[1])).toRadixString(16).toUpperCase();
      }

      return "Error";
    } catch (e) {
      return "Error";
    }
  }

  /// Tìm vị trí dấu đóng ngoặc tương ứng cho một dấu mở ngoặc
  static int _findClosingBracket(String text, int start) {
    int count = 1;
    for (int i = start; i < text.length; i++) {
      if (text[i] == '(') count++;
      if (text[i] == ')') count--;
      if (count == 0) return i;
    }
    return -1;
  }
}
