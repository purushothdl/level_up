import 'package:flutter/material.dart';
import './dashboard_widgets/attendance_widget.dart';
import './dashboard_widgets/attendance_number_widget.dart';

class AttendancePart extends StatelessWidget {
  final int totalDays;
  final int presentDays;

  const AttendancePart({
    super.key,
    required this.totalDays,
    required this.presentDays,
  });

  @override
  Widget build(BuildContext context) {
    // Define fixed padding for the container and widget spacing
    const double containerPadding = 16.0; // Padding for the container
    const double widgetPadding = 30.0; // Fixed padding for widgets

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the children vertically
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space widgets with fixed distance
        children: [
          // Padding for AttendanceBar
          Padding(
            padding: EdgeInsets.only(left: widgetPadding+16), // Fixed distance from the left
            child: AttendanceBar(
              totalDays: totalDays,
              presentDays: presentDays,
            ),
          ),
          // Padding for Column containing InfoContainers
          Padding(
            padding: EdgeInsets.only(right: widgetPadding-10), // Fixed distance from the right
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoContainer(
                  header: 'Total Days',
                  number: totalDays.toString(),
                  unit: 'Days',
                ),
                const SizedBox(height: 10),
                InfoContainer(
                  header: 'Present Days',
                  number: presentDays.toString(),
                  unit: 'Days',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
