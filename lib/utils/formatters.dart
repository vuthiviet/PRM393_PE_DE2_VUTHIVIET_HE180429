String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

// Chỉ đổi nhãn đơn vị, không tự quy đổi tỷ giá.
String formatMoney(double amount, String currency) {
  final parts = amount
      .toStringAsFixed(amount == amount.roundToDouble() ? 0 : 2)
      .split('.');
  final digits = parts.first.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},',
  );
  return '$digits${parts.length > 1 ? '.${parts[1]}' : ''} $currency';
}
