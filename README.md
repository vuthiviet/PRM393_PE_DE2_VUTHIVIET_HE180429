# Quản lý chi tiêu

Bài Flutter đơn giản theo MVVM, dùng Riverpod và riverpod_generator.

## Chạy ứng dụng

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Chọn Android hoặc iOS. SQLite trong bài dùng sqflite, không hỗ trợ chạy web/Windows trực tiếp.

## Cấu trúc dễ nhớ

- `lib/models/expense.dart`: dữ liệu của một khoản chi.
- `lib/data/expense_repository.dart`: tạo SQLite, thêm 5 khoản mẫu lần đầu, đọc và cập nhật dữ liệu.
- `lib/viewmodels/expense_view_model.dart`: lấy danh sách, lưu chỉnh sửa rồi tải lại danh sách.
- `lib/viewmodels/currency_view_model.dart`: đọc/lưu đơn vị tiền tệ bằng SharedPreferences.
- `lib/views/`: danh sách, màn hình chỉnh sửa và hộp thoại tiền tệ.
- File `.g.dart`: Riverpod Generator tự sinh, không sửa tay.

Luồng xử lý: View gọi ViewModel → ViewModel gọi Repository → SQLite. View theo dõi provider để tự cập nhật.

## Sử dụng

1. Mở app để xem danh sách từ SQLite, sắp theo ngày mới nhất.
2. Nhấn bút chì, sửa tên/số tiền/danh mục/ngày rồi nhấn Lưu. Hủy hoặc quay lại sẽ bỏ thay đổi chưa lưu.
3. Nhấn bánh răng, chọn VND hoặc USD rồi nhấn Lưu. Cài đặt được giữ sau khi tắt và mở lại ứng dụng.

Tên không được để trống; số tiền phải lớn hơn 0. Số tiền nhập không có dấu phân cách hàng nghìn, ví dụ `150000` hoặc `12.50`.
Đơn vị tiền tệ chỉ thay đổi nhãn VND/USD, không tự quy đổi tỷ giá vì đề không cung cấp tỷ giá.

## Kiểm tra

```sh
flutter analyze
flutter test
```
