# Tài liệu Kiểm thử

## Chiến lược
Chúng tôi sử dụng kiểm thử đơn vị (Unit Testing) để xác minh lõi toán học của ứng dụng. Mục tiêu là đảm bảo độ bao phủ (coverage) >80% cho logic tính toán.

## Các kịch bản kiểm thử

### 1. Số học cơ bản
- `5 + 3 = 8`
- `10 - 4 = 6`
- `6 * 7 = 42`
- `15 / 3 = 5`

### 2. Thứ tự thực hiện phép tính (PEMDAS)
- `2 + 3 * 4 = 14`
- `(2 + 3) * 4 = 20`

### 3. Các hàm khoa học
- `sin(30) = 0.5` (Chế độ Độ - Degree)
- `sqrt(16) = 4`
- `2 * pi * sqrt(9) ≈ 18.85`

### 4. Các trường hợp biên (Edge Cases)
- Chia cho 0: `5 / 0` -> Trả về "Error"
- Căn bậc hai số âm: `sqrt(-4)` -> Trả về "Error"

## Cách chạy kiểm thử
1. Mở terminal tại thư mục gốc của dự án.
2. Chạy lệnh sau:
```bash
flutter test
```
