import 'package:intl/intl.dart';

class AppDateFormatter {
  static String formatHour(int unixTimestamp, {String locale = 'en'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat.jm(locale).format(date);
  }

  static String formatWeekday(int unixTimestamp, {String locale = 'en'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    final now = DateTime.now();

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return locale.startsWith('ar') ? 'اليوم' : 'Today';
    }
    return DateFormat.E(locale).format(date);
  }

  static String formatFullDate(int unixTimestamp, {String locale = 'en'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat.MMMMEEEEd(locale).format(date);
  }

  static String formatTime(int unixTimestamp, {String locale = 'en'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return DateFormat.jm(locale).format(date);
  }

  static String formatRelativeTime(DateTime dateTime, {String locale = 'en'}) {
    final difference = DateTime.now().difference(dateTime);

    if (locale.startsWith('ar')) {
      if (difference.inMinutes < 1) return 'الآن';
      if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
      if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
      return 'منذ ${difference.inDays} يوم';
    } else {
      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      return '${difference.inDays}d ago';
    }
  }
}
