import 'package:flutter/material.dart';

class AttendanceWidget extends StatelessWidget {
  final int presentDays;
  final int totalDays;

  const AttendanceWidget({
    super.key,
    required this.presentDays,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (presentDays / totalDays) * 100;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff00b0ff), // Blue Background Color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // First Element: Percentage and Circle Indicator
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Percentage',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCircularPercentage(percentage),
              ],
            ),
          ),
          // Second Element: Vertical Divider
          Container(
            width: 1,
            height: 120,
            color: const Color.fromARGB(255, 13, 95, 162),
          ),
          // Third Element: Days and Button (Takes 2x Space)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Row 1: Present and Total Days with Divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildDayElement(presentDays, 'Present Days'),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white54,
                      margin: const EdgeInsets.symmetric(horizontal: 8), // Reduced spacing
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildDayElement(totalDays, 'Total Days'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // 2px padding on both sides
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Centers the content within the Row
                    children: [
                      Expanded(
                        child: AttendanceButton(), // The button will take up the full available width
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Circular Progress Indicator for Percentage
  Widget _buildCircularPercentage(double percentage) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 8,
            color: Colors.white,
            backgroundColor: Colors.white24,
          ),
          Center(
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Day Element Widget
  Widget _buildDayElement(int value, String label) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// Attendance Button Widget with Press Effect
class AttendanceButton extends StatefulWidget {
  @override
  _AttendanceButtonState createState() => _AttendanceButtonState();
}



class _AttendanceButtonState extends State<AttendanceButton> {
  bool _isPressed = false; // To track if the button is pressed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Action to perform when the button is pressed
        print('Attendance marked!');
        // You can add more actions like navigating or updating state here
      },
      onTapDown: (_) {
        // Change the state when the button is pressed down
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        // Revert the state when the button is released
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        // Revert the state if the tap is canceled
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedOpacity(
        opacity: _isPressed ? 0.5 : 0.9, // Change opacity based on press state
        duration: const Duration(milliseconds: 1600), // Smooth duration
        curve: Curves.easeInOut, // Smooth easing curve
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_isPressed ? 0.5 : 0.2), // Change color opacity
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Center( // Wrap the Text widget with Center
            child: Text(
              'Mark Attendance',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
