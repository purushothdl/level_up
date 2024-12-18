import 'package:flutter/material.dart';
import 'package:level_up/screens/home/dashboard/attendance_part.dart';
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
        scaffoldBackgroundColor: Colors.white, // Set the entire Scaffold to have a white background color
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Prevents default back button
          backgroundColor: Colors.white,
          elevation: 0, // Optional: remove shadow
          title: AppTitle(
            title: 'Level', // Replace with your actual title
            subtitle: 'Up', // Replace with your subtitle
            imagePath: 'assets/images/deadlift.jpeg', // Replace with your desired image path
          ),
        ),
        
        body: SingleChildScrollView(
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:20),
              GymPlanWidget(imagePath: 'assets/images/profile/chetan.jpg', name: "Chetan Reddy", planName: "Premium Plan"),
              SizedBox(height: 1,),
              HeaderWidget(
                heading: 'Weight Tracker',
                caption: 
                '''Monitor your weight trends to understand your progress. ''',
              ),
              
              SizedBox(
                height: 290,  // Adjust height as needed
                child: WeightGraph(),
              ),

              // SizedBox(height: 20),
              HeaderWidget(
                heading: 'Attendance',
                caption: 
                '''Measures consistency and your ability to commit. ''',
              ),
              SizedBox(height: 40,),
              AttendancePart(totalDays: 10, presentDays: 8)

            
            ],
          ),
        )

      )
    );
  }
}
