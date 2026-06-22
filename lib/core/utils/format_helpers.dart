import 'package:intl/intl.dart';

class FormatHelpers {
  FormatHelpers._();

  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '\$${formatter.format(amount)}';
  }

  static String formatPriceWithUnit(double price, String type) {
    final formatted = formatCurrency(price);
    if (type == 'rent') {
      return '$formatted/mo';
    }
    return formatted;
  }

  static String formatArea(double sqft) {
    return '${NumberFormat('#,##0', 'en_US').format(sqft)} sqft';
  }

  static String formatPhone(String phone) {
    if (phone.length >= 10) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return phone;
  }
}
