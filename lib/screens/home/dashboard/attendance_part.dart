import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // HTTP requests

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
        // color: const Color(0xff00b0ff), // Blue Background Color
        color: Colors.black, // Blue Background Color
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
            // color: const Color.fromARGB(255, 13, 95, 162),
            color: Colors.white
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
            color: const Color(0xff04fc04),
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

class _AttendanceButtonState extends State<AttendanceButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false; // To track loading state

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Duration for scale animation
    );

    // Initialize the Tween for scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to mark attendance via backend
  Future<void> _markAttendance() async {
    setState(() {
      _isLoading = true; // Show loading state
    });

    try {
      // Retrieve the token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token not found in shared preferences");
      }

      // Make the POST request to the backend
      final response = await http.post(
        Uri.parse('https://level-up-backend-9hpz.onrender.com/api/mark-attendance'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token to the headers
          'Content-Type': 'application/json', // Set content type to JSON
        },
      );

      if (response.statusCode == 201) {
        // Show success dialog
        _showMessageDialog(
          "Success",
          "Attendance marked successfully!",
          Colors.green,
          true,
        );
      } else {
        print(response);
        // Show failure dialog
        _showMessageDialog(
          "Error",
          "Attendance already marked for today! Try again tomorrow.",
          Colors.red,
          false,
        );
      }
    } catch (error) {
      // Show error dialog for exceptions
      _showMessageDialog(
        "Error",
        "An error occurred while marking attendance.",
        Colors.red,
        false,
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading state
      });
    }
  }

  // Function to display the custom dialog
  void _showMessageDialog(String title, String message, Color color, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Set the dialog background to transparent
          contentPadding: EdgeInsets.zero, // Remove the default padding for the container

          // Custom container with white background and shadow
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4), // Shadow offset
                ),
              ],
            ),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon at the top - Green Check or Red Cross
                Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 20),

                // Success/Failure message
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Close button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: color),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isLoading) {
          _markAttendance(); // Call the backend when the button is pressed
        }
      },
      onTapDown: (_) {
        if (!_isLoading) {
          setState(() {
            _isPressed = true;
          });
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (!_isLoading) {
          setState(() {
            _isPressed = false;
          });
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (!_isLoading) {
          setState(() {
            _isPressed = false;
          });
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedOpacity(
              opacity: _isPressed ? 0.5 : 0.9,
              duration: const Duration(milliseconds: 600), // Slower opacity animation
              curve: Curves.easeInOut,
              child: Container(
                decoration: BoxDecoration(
                  color: _isLoading
                      ? Colors.grey.withOpacity(0.5) // Greyed-out if loading
                      : Colors.white.withOpacity(_isPressed ? 0.5 : 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ) // Show a loader when loading
                      : const Text(
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
        },
      ),
    );
  }
}