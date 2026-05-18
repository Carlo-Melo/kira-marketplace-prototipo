import 'package:intl/intl.dart';

class DateUtilsKira {
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  static String formatDateTime(DateTime value) => _dateTimeFormat.format(value);
  static String formatDate(DateTime value) => _dateFormat.format(value);
}
