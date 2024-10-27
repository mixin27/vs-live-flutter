import 'package:intl/intl.dart';

class Format {
  static String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String matchDate(DateTime date) {
    final formattedDate = DateFormat.MEd().format(date);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date == today) return "Today ($formattedDate)";
    if (date == tomorrow) return "Tomorrow ($formattedDate)";

    return formattedDate;
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }

  static DateTime parseMatchDateTime(String date, String time) {
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm a");
    final formattedStr = format.parse('$date $time');
    return formattedStr;
  }

  static String matchDateAndTime(DateTime date) {
    return DateFormat().add_MEd().add_jm().format(date);
  }

  static String parseAndFormatMatchDateTime(String date, String time) {
    final parsedDate = parseMatchDateTime(date, time);
    return matchDateAndTime(parsedDate);
  }
}
