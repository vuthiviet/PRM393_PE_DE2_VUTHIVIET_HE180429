import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/currency_view_model.dart';

class CurrencyDialog extends ConsumerStatefulWidget {
  const CurrencyDialog({super.key, required this.currency});
  final String currency;
  @override
  ConsumerState<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends ConsumerState<CurrencyDialog> {
  late String _currency = widget.currency;
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(currencyViewModelProvider.notifier).save(_currency);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Không lưu được. Vui lòng thử lại.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: const Text('Đơn vị tiền tệ'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final unit in ['VND', 'USD'])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _currency == unit
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(
                unit == 'VND' ? 'VND (Việt Nam Đồng)' : 'USD (Đô la Mỹ)',
              ),
              onTap: _saving ? null : () => setState(() => _currency = unit),
            ),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Đang lưu...' : 'Lưu'),
        ),
      ],
    ),
  );
}
