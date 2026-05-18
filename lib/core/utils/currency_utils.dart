import 'package:intl/intl.dart';

class CurrencyUtils {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String format(double value) => _currencyFormat.format(value);
}
