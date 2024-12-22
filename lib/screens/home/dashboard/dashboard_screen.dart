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
import '../home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) updateIndex;

  const DashboardScreen({super.key, required this.updateIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with AutomaticKeepAliveClientMixin {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  String errorMessage = '';
  bool _isInitialized = false;

  bool isAttendanceLoading = true;
  String attendanceErrorMessage = '';
  Map<String, dynamic> attendanceData = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _fetchData(useCache: true); // Use cache on initial load
      _isInitialized = true;
    }
  }

  Future<void> _fetchData({bool useCache = false}) async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
      isAttendanceLoading = true;
      errorMessage = '';
      attendanceErrorMessage = '';
    });

    await Future.wait([
      _loadUserData(useCache: useCache),
      _fetchAttendanceData(),
    ]);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadUserData({bool useCache = false}) async {
    try {
      final userDetails = useCache 
          ? await UserService.getUserDetails()  // Use cached data if available
          : await UserService.fetchFreshUserDetails();  // Force fresh data
      if (!mounted) return;
      setState(() {
        userData = userDetails['user'];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to load user data. Please try again.';
      });
      print("Error loading user data: $e");
    }
  }
  Future<void> _fetchAttendanceData() async {
    // The attendance fetching logic remains unchanged
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
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: AppTitle(
          title: 'Level',
          subtitle: 'Up',
          imagePath: 'assets/images/profile/chetan.jpg',
          updateIndex: widget.updateIndex,  // Pass it to AppTitle
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _fetchData(useCache: false), // Force fresh data on pull-to-refresh
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(6),
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
                        HeaderWidget(
                          heading: 'Weight Tracker',
                          caption: 'Monitor your weight trends to understand your progress.',
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: StyledWeightGraph(),
                          ),
                        ),
                        const SizedBox(height: 25),
                        HeaderWidget(
                          heading: 'Attendance',
                          caption: 'Measures consistency and your ability to commit.',
                        ),
                        const SizedBox(height: 10),
                        isAttendanceLoading
                            ? const Center(child: CircularProgressIndicator())
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
      ),
    );
  }
}
