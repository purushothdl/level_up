import 'package:flutter/material.dart';
import '../dashboard/attendance_part.dart';
import 'weight_track_part.dart';
import 'app_title_part.dart';
import './dashboard_widgets/header_widget.dart';
import 'plan_part.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GymPlanWidget(
                planName: "Premium Plan",
                remainingDays: 15,
                totalDays: 90,
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
              AttendanceWidget(presentDays: 8, totalDays: 10,),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
