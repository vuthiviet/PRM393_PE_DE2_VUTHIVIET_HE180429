import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'currency_view_model.g.dart';

@Riverpod(keepAlive: true)
class CurrencyViewModel extends _$CurrencyViewModel {
  @override
  Future<String> build() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('currency') == 'USD' ? 'USD' : 'VND';
  }

  Future<void> save(String currency) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString('currency', currency);
    if (!saved) throw Exception('Không lưu được đơn vị tiền tệ');
    state = AsyncData(currency);
  }
}
