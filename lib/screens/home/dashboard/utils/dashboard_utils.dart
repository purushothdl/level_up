  // Plan part widget
  // Helper function to format DateTime as "23rd Jan"  (Plan part in dashboard)
  String formatDate(DateTime date) {
    int day = date.day;
    String month = getMonthName(date.month);

    String daySuffix;
    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    return '$day$daySuffix $month';
  }

  // Helper function to get the month name from the month number
  String getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Helper function to parse backend date string into DateTime
  DateTime parseDate(String dateString) {
    return DateTime.parse(dateString);
  }



/// For Weight Tracking
// Helper function to format date as 'Nov 23rd (for weight track widget in dashboard)
  String formatWeightDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    int day = parsedDate.day;
    String month = getMonthName(parsedDate.month);

    // Add the suffix to the day (st, nd, rd, th)
    String daySuffix;
    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    return '$month $day$daySuffix';
  }


// For info widget User screen 
String formatDateUser(String date) {
  final parsedDate = DateTime.parse(date);
  final day = parsedDate.day;
  final month = getMonthName(parsedDate.month); // Helper function for month name
  final year = parsedDate.year;

  // Determine the correct day suffix
  final suffix = _getDaySuffix(day);

  // Return the formatted date
  return '$day$suffix $month, $year';
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return 'th'; // Special case for 11th, 12th, 13th
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}