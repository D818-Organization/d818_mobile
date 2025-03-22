import 'package:flutter/foundation.dart';

class DateTimeHelper {
  String formatDateParse(DateTime date) {
    String day = date.day.toString(), month = date.month.toString();
    if (date.day.toString().length == 1) day = "0${date.day}";
    if (date.month.toString().length == 1) month = "0${date.month}";
    String formatedDate = "${date.year}-$month-$day";
    debugPrint(formatedDate);
    return formatedDate;
  }

  String formatDate(DateTime date) {
    String day = date.day.toString(), month = date.month.toString();
    if (date.day.toString().length == 1) day = "0${date.day}";
    if (date.month.toString().length == 1) month = "0${date.month}";
    String formatedDate = "$day/$month/${date.year}";
    debugPrint(formatedDate);
    return formatedDate;
  }

  String timeAgo(String isoTime) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(isoTime);
    Duration difference = now.difference(time);

    if (difference.inDays > 365) {
      int years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 7) {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
