import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(
    String? date, {
    String pattern = 'dd/MM/yyyy HH:mm',
  }) {
    if (date == null || date.isEmpty) return '';

    final dt = DateTime.tryParse(date);
    if (dt == null) return date;

    return DateFormat(pattern).format(dt);
  }
}

class PriceFormatter {
  PriceFormatter._();

  // format kiểu 10000 -> 10.000đ
  static String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(price);
  }
}
