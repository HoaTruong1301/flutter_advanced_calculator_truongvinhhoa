import 'package:math_expressions/math_expressions.dart';

class ExpressionParser {
  static double parseAndEvaluate(String equation) {
    Parser p = Parser();
    Expression exp = p.parse(equation);
    ContextModel cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }
}
