import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_advanced_calculator_truongvinhhoa/utils/calculator_logic.dart';
import 'package:flutter_advanced_calculator_truongvinhhoa/providers/calculator_provider.dart';

void main() {
  group('Unit Tests - CalculatorLogic', () {
    test('Basic arithmetic operations', () {
      expect(CalculatorLogic.calculate('5+3'), '8');
      expect(CalculatorLogic.calculate('10-4'), '6');
      expect(CalculatorLogic.calculate('6*7'), '42');
      expect(CalculatorLogic.calculate('15/3'), '5');
    });

    test('Order of operations', () {
      expect(CalculatorLogic.calculate('2+3*4'), '14');
      expect(CalculatorLogic.calculate('(2+3)*4'), '20');
    });

    test('Scientific functions', () {
      expect(CalculatorLogic.calculate('sin(30)', angleMode: AngleMode.degrees), '0.5');
      expect(CalculatorLogic.calculate('sqrt(16)'), '4');
    });

    test('Complex Test Scenarios (Step 8)', () {
      // 1. Complex expressions: (5 + 3) * 2 - 4 / 2 = 14
      expect(CalculatorLogic.calculate('(5+3)*2-4/2'), '14');

      // 2. Scientific: sin(45) + cos(45) ≈ 1.414
      // Note: Calculator returns string, let's parse to double for approx check
      double scResult = double.parse(CalculatorLogic.calculate('sin(45)+cos(45)', angleMode: AngleMode.degrees, precision: 3));
      expect(scResult, closeTo(1.414, 0.001));

      // 5. Parentheses nesting: ((2 + 3) * (4 - 1)) / 5 = 3
      expect(CalculatorLogic.calculate('((2+3)*(4-1))/5'), '3');

      // 6. Mixed scientific: 2 * pi * sqrt(9) ≈ 18.85
      double mixedResult = double.parse(CalculatorLogic.calculate('2*pi*sqrt(9)', precision: 2));
      expect(mixedResult, closeTo(18.85, 0.01));
    });
  });
}
