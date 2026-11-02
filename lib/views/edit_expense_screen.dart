import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense.dart';
import '../utils/formatters.dart';
import '../viewmodels/expense_view_model.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  const EditExpenseScreen({super.key, required this.expense});
  final Expense expense;
  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.expense.name);
  late final _amount = TextEditingController(
    text: widget.expense.amount.toString().replaceFirst(RegExp(r'\.0$'), ''),
  );
  late String _category = widget.expense.category;
  late DateTime _date = widget.expense.date;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) setState(() => _date = date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(expenseViewModelProvider.notifier)
          .save(
            Expense(
              id: widget.expense.id,
              name: _name.text.trim(),
              amount: double.parse(_amount.text.trim()),
              category: _category,
              date: _date,
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không lưu được khoản chi. Vui lòng thử lại.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa khoản chi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              enabled: !_saving,
              decoration: const InputDecoration(labelText: 'Tên khoản chi *'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Vui lòng nhập tên khoản chi'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amount,
              enabled: !_saving,
              decoration: const InputDecoration(labelText: 'Số tiền *'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              validator: (value) {
                final amount = double.tryParse(value?.trim() ?? '');
                return amount == null || !amount.isFinite || amount <= 0
                    ? 'Nhập số tiền lớn hơn 0'
                    : null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Danh mục *'),
              items: ['Sinh hoạt', 'Đi lại', 'Học tập', 'Sức khỏe']
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _category = value!),
            ),
            const SizedBox(height: 20),
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Ngày chi tiêu *'),
              child: InkWell(
                onTap: _saving ? null : _pickDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDate(_date)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Đang lưu...' : 'Lưu'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
