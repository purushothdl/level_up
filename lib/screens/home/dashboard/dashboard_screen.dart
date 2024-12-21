import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // To make the HTTP request
import 'dart:convert'; // To decode JSON

import '../dashboard/attendance_part.dart';
import 'weight_track_part.dart';
import 'app_title_part.dart';
import './dashboard_widgets/header_widget.dart';
import 'plan_part.dart';
import 'package:LevelUp/services/user_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> userData = {}; // To store the user details
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // Track errors if fetching fails

  // Attendance Data
  bool isAttendanceLoading = true;
  String attendanceErrorMessage = '';
  Map<String, dynamic> attendanceData = {}; // To store attendance data

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch user data (including gym plan)
    _fetchAttendanceData(); // Fetch attendance data
  }

  Future<void> _loadUserData() async {
    try {
      final userDetails = await UserService.getUserDetails(); // Fetch user data from the service

      setState(() {
        userData = userDetails['user']; // Store the user data
        isLoading = false; // Stop loading once data is fetched
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load user data. Please try again.';
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  Future<void> _fetchAttendanceData() async {
    try {
      // Fetch user_id and token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      String? token = prefs.getString('token');

      if (userId != null && token != null) {
        final response = await http.get(
          Uri.parse('https://level-up-backend-9hpz.onrender.com/api/get-attendance/$userId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            attendanceData = json.decode(response.body); // Decode response
            isAttendanceLoading = false;
          });
        } else {
          setState(() {
            attendanceErrorMessage = 'Failed to load attendance data.';
            isAttendanceLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        attendanceErrorMessage = 'Failed to load attendance data.';
        isAttendanceLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: AppTitle(
          title: 'Level',
          subtitle: 'Up',
          imagePath: 'assets/images/deadlift.jpeg',
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // Show error if any
              : SingleChildScrollView(
                  padding: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      if (userData['subscription_plan'] != null)
                        GymPlanWidget(
                          planName: userData['subscription_plan']['plan_name'] ?? "Unknown Plan",
                          remainingDays: userData['subscription_plan']['remaining_days'] ?? 0,
                          totalDays: userData['subscription_plan']['duration'] ?? 0,
                          lastDate: userData['subscription_plan']['end_date'] ?? "Unknown",
                        ),
                      const SizedBox(height: 16),

                      // Weight Tracker Section
                      HeaderWidget(
                        heading: 'Weight Tracker',
                        caption: '''Monitor your weight trends to understand your progress.''',
                      ),
                      const SizedBox(height: 10),

                      // Responsive Graph Section
                      Container(
                        padding: const EdgeInsets.all(0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9, // Maintain proportional graph
                          child: StyledWeightGraph(),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Attendance Section
                      HeaderWidget(
                        heading: 'Attendance',
                        caption: '''Measures consistency and your ability to commit.''',
                      ),
                      const SizedBox(height: 10),

                      // Attendance Data Loading State or Error Message
                      isAttendanceLoading
                          ? Center(child: CircularProgressIndicator())
                          : attendanceErrorMessage.isNotEmpty
                              ? Center(child: Text(attendanceErrorMessage))
                              : attendanceData.isNotEmpty
                                  ? AttendanceWidget(
                                      presentDays: attendanceData['present_days'] ?? 0,
                                      totalDays: attendanceData['total_days'] ?? 0,
                                    )
                                  : const Center(child: Text('No attendance data available.')),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }
}
