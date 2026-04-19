# Architecture Document

## Overview
The project follows a layered architecture to ensure separation of concerns and maintainability.

## Layers

### 1. Business Logic (Providers)
- **CalculatorProvider**: The central brain. Manages the calculation state, mode switching, and coordinates with services.
- **ThemeProvider**: Manages UI appearance (Light/Dark mode).
- **HistoryProvider**: Dedicated state for calculation history.

### 2. Core Logic (Utils)
- **CalculatorLogic**: A stateless utility that takes a string expression and returns a result. It uses the `math_expressions` package but adds custom logic for:
  - Percentages
  - Factorials
  - Trigonometry angle conversions (Deg/Rad)
  - Implicit multiplication

### 3. Data Layer (Services & Models)
- **StorageService**: Wrapper around `shared_preferences` for data persistence.
- **Models**: Simple Dart classes (POJOs) for structured data like `CalculationHistory`.

### 4. Presentation (UI)
- Built with reusable widgets (`ButtonGrid`, `CalculatorButton`, `DisplayArea`).
- Responsive layouts for different calculator modes.
