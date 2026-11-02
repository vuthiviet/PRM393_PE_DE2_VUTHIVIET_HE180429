import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/formatters.dart';
import '../viewmodels/currency_view_model.dart';
import '../viewmodels/expense_view_model.dart';
import 'edit_expense_screen.dart';
import 'currency_dialog.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseViewModelProvider);
    final currency = ref.watch(currencyViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            tooltip: 'Đơn vị tiền tệ',
            icon: const Icon(Icons.settings),
            onPressed: currency.asData == null
                ? null
                : () => showDialog<void>(
                    context: context,
                    builder: (_) =>
                        CurrencyDialog(currency: currency.asData!.value),
                  ),
          ),
        ],
      ),
      body: currency.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(currencyViewModelProvider),
            child: const Text('Không tải được cài đặt. Thử lại'),
          ),
        ),
        data: (unit) => expenses.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: TextButton(
              onPressed: () => ref.invalidate(expenseViewModelProvider),
              child: const Text('Không tải được chi tiêu. Thử lại'),
            ),
          ),
          data: (items) => items.isEmpty
              ? const Center(child: Text('Chưa có khoản chi'))
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final expense = items[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(expense.category),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatDate(expense.date)),
                              const SizedBox(height: 6),
                              Text(
                                formatMoney(expense.amount, unit),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            tooltip: 'Chỉnh sửa ${expense.name}',
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    EditExpenseScreen(expense: expense),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
