import 'package:flutter/material.dart';
import './utils/dashboard_utils.dart';


class GymPlanWidget extends StatelessWidget {
  final String planName;
  final int remainingDays;
  final int totalDays;
  final dynamic lastDate;

  GymPlanWidget({
    required this.planName,
    required this.remainingDays,
    required this.totalDays,
    required this.lastDate
  });

  @override
  Widget build(BuildContext context) {
    double progress = (totalDays - remainingDays) / totalDays;
    int percentage = ((progress) * 100).round();

    return Container(
      margin: EdgeInsets.all(16.0), // Added margin to the entire container
      // height: 180,
      width: double.infinity,
      
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/gym_background.jpg'), // Replace with your image asset
          fit: BoxFit.cover,
        ),
        // color: Colors.black,
        borderRadius: BorderRadius.circular(16.0), // Rounded corners for the container
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0), // Ensuring child elements follow the container's rounded corners
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Name with rounded corners
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3 ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners for the plan name container
                    ),
                    child: Text(
                      planName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  // Plan Duration and Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Plan Duration',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.0),
                  Container(
                    height: 8, // Adjusted height for the progress bar
                    child: Stack(
                      children: [
                        // Background bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(20.0), // Rounded edges
                          ),
                        ),
                        // Glowing progress bar with rounded green edge
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              width: constraints.maxWidth * progress, // Width proportional to the progress
                              height: 8, // Height of the bar
                              decoration: BoxDecoration(
                                color: const Color(0xff04fc04), // Bright green color
                                borderRadius: BorderRadius.circular(20.0), // Rounded edges for green part
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff04fc04).withOpacity(0.6), // Neon glow color
                                    blurRadius: 15.0, // Glow radius
                                    spreadRadius: 3.0, // Glow spread
                                    offset: Offset(0, 0), // Centered glow
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.0),

                  // Centered Remaining and Total Days with larger gap
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the entire row's contents
                    children: [
                      // "Remaining" Section with Expanded to take equal space
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: _buildDayInfo('Remaining', remainingDays, 'days'),
                        ),
                      ),
    
                      // "Total" Section with Expanded to take equal space
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: _buildDayInfo('Total', totalDays, 'days'),
                        ),
                      ),

                      // Last Date section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: _buildDayInfo('Last Day', parseDate(lastDate), ''),
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayInfo(String title, dynamic value, String unit) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 190, 189, 189),
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // If the value is a DateTime object, format it as a date
              if (value is DateTime) 
                Text(
                  formatDate(value),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
              // If the value is an integer (like Remaining or Total days)
              if (value is int) 
                ...[
                  Text(
                    '$value',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    unit,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
            ],
          ),
        ],
      ),
    );
  }

  // // Helper function to format DateTime as "23rd Jan"
  // String _formatDate(DateTime date) {
  //   // Extract day and month from the DateTime
  //   int day = date.day;
  //   String month = _getMonthName(date.month);

  //   // Add the suffix to the day (st, nd, rd, th)
  //   String daySuffix;
  //   if (day >= 11 && day <= 13) {
  //     daySuffix = 'th';
  //   } else {
  //     switch (day % 10) {
  //       case 1:
  //         daySuffix = 'st';
  //         break;
  //       case 2:
  //         daySuffix = 'nd';
  //         break;
  //       case 3:
  //         daySuffix = 'rd';
  //         break;
  //       default:
  //         daySuffix = 'th';
  //     }
  //   }

  //   return '$day$daySuffix $month';
  // }

  // // Helper function to get the month name from the month number
  // String _getMonthName(int month) {
  //   const months = [
  //     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  //   ];
  //   return months[month - 1];
  // }
  // // Helper function to parse backend date string into DateTime
  // DateTime _parseDate(String dateString) {
  //   // Parse the ISO 8601 string to DateTime
  //   return DateTime.parse(dateString);
  // }
}
