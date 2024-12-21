  
  // Helper function to format DateTime as "23rd Jan"
  String formatDate(DateTime date) {
    int day = date.day;
    String month = getMonthName(date.month);

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
// Helper function to format date as 'Nov 23rd
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