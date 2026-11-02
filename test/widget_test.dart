import 'package:flutter_test/flutter_test.dart';
import 'package:pe_prm/models/expense.dart';
import 'package:pe_prm/utils/formatters.dart';

void main() {
  test('Expense giữ nguyên dữ liệu khi chuyển sang dữ liệu SQLite', () {
    final expense = Expense(
      id: 1,
      name: 'Ăn uống',
      amount: 150000,
      category: 'Sinh hoạt',
      date: DateTime(2026, 10, 29),
    );
    final restored = Expense.fromMap(expense.toMap());
    expect(restored.toMap(), expense.toMap());
  });

  test('Định dạng ngày và tiền theo mẫu', () {
    expect(formatDate(DateTime(2026, 1, 9)), '09/01/2026');
    expect(formatMoney(150000, 'VND'), '150,000 VND');
    expect(formatMoney(12.5, 'USD'), '12.50 USD');
  });
}
