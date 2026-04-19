# Testing Document

## Strategy
We use unit testing to verify the mathematical core of the application. The goal is to ensure >80% coverage of the calculation logic.

## Test Cases

### 1. Basic Arithmetic
- `5 + 3 = 8`
- `10 - 4 = 6`
- `6 * 7 = 42`
- `15 / 3 = 5`

### 2. Order of Operations (PEMDAS)
- `2 + 3 * 4 = 14`
- `(2 + 3) * 4 = 20`

### 3. Scientific Functions
- `sin(30) = 0.5` (Degree mode)
- `sqrt(16) = 4`
- `2 * pi * sqrt(9) ≈ 18.85`

### 4. Edge Cases
- Division by zero: `5 / 0` -> Returns "Error"
- Negative square root: `sqrt(-4)` -> Returns "Error"

## How to run tests
1. Open terminal in the project root.
2. Run the following command:
```bash
flutter test
```
