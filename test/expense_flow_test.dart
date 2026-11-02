import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pe_prm/data/expense_repository.dart';
import 'package:pe_prm/main.dart';
import 'package:pe_prm/models/expense.dart';
import 'package:pe_prm/viewmodels/expense_view_model.dart';

class MemoryRepository extends ExpenseRepository {
  Expense expense = Expense(
    id: 1,
    name: 'Ăn uống',
    amount: 150000,
    category: 'Sinh hoạt',
    date: DateTime(2026, 10, 29),
  );
  @override
  Future<List<Expense>> getExpenses() async => [expense];
  @override
  Future<void> updateExpense(Expense value) async {
    expense = value;
  }
}

void main() {
  testWidgets('Sửa khoản chi và lưu đơn vị tiền tệ', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = MemoryRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [expenseRepositoryProvider.overrideWithValue(repository)],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('150,000 VND'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Ăn trưa');
    await tester.enterText(find.byType(TextFormField).at(1), '0');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Nhập số tiền lớn hơn 0'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), '200000');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Ăn trưa'), findsOneWidget);
    expect(find.text('200,000 VND'), findsOneWidget);
    expect(repository.expense.amount, 200000);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD (Đô la Mỹ)'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('200,000 USD'), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('currency'), 'USD');
  });
}
