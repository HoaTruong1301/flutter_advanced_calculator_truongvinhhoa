# Tài liệu Kiến trúc Hệ thống

## Tổng quan
Dự án tuân theo kiến trúc phân lớp (layered architecture) nhằm đảm bảo sự tách biệt giữa các thành phần và khả năng bảo trì cao.

## Các lớp thành phần

### 1. Logic nghiệp vụ (Providers)
- **CalculatorProvider**: Bộ não trung tâm. Quản lý trạng thái tính toán, chuyển đổi chế độ và điều phối với các dịch vụ khác.
- **ThemeProvider**: Quản lý giao diện người dùng (Chế độ Sáng/Tối).
- **HistoryProvider**: Chuyên trách quản lý trạng thái lịch sử tính toán.

### 2. Logic cốt lõi (Utils)
- **CalculatorLogic**: Một tiện ích phi trạng thái (stateless) nhận vào một biểu thức dạng chuỗi và trả về kết quả. Lớp này sử dụng gói `math_expressions` nhưng bổ sung logic tùy chỉnh cho:
  - Tính phần trăm (%)
  - Giai thừa (!)
  - Chuyển đổi góc lượng giác (Độ/Radian)
  - Nhân ẩn (ví dụ: 2pi -> 2*pi)

### 3. Lớp dữ liệu (Services & Models)
- **StorageService**: Lớp bao quanh `shared_preferences` để lưu trữ dữ liệu bền vững.
- **Models**: Các lớp Dart đơn giản (POJO) cho dữ liệu có cấu trúc như `CalculationHistory`.

### 4. Giao diện (Presentation - UI)
- Được xây dựng bằng các widget có khả năng tái sử dụng (`ButtonGrid`, `CalculatorButton`, `DisplayArea`).
- Bố cục đáp ứng (Responsive layout) cho các chế độ máy tính khác nhau.
