import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/expense_repository.dart';
import '../models/expense.dart';
part 'expense_view_model.g.dart';

@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) => ExpenseRepository();

@riverpod
class ExpenseViewModel extends _$ExpenseViewModel {
  @override
  Future<List<Expense>> build() =>
      ref.watch(expenseRepositoryProvider).getExpenses();

  Future<void> save(Expense expense) async {
    await ref.read(expenseRepositoryProvider).updateExpense(expense);
    ref.invalidateSelf();
  }
}
