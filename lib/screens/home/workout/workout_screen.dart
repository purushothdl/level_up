import 'dart:async';
import 'package:flutter/material.dart';
import 'package:LevelUp/services/user_service.dart';
import '../diet/diet_widgets/header_widget.dart';
import 'weight_plan_part.dart';
import 'workout_part.dart';
import '../home_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final Function(int) updateIndex;

  const WorkoutScreen({super.key, required this.updateIndex});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Map<String, dynamic> workoutData = {};
  Map<String, dynamic> weightPlanData = {};
  bool isLoading = true;
  String errorMessage = '';
  late StreamSubscription _userDataSubscription;

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();

    // Subscribe to user data updates
    _userDataSubscription = UserService.userDataStream.listen((userData) {
      if (mounted) {
        setState(() {
          workoutData = userData['user']['workout_plan']?['workout_plan_details']?['schedule'] ?? {};
          weightPlanData = userData['user']['workout_plan'] ?? {};
        });
      }
    });
  }

  Future<void> _loadWorkoutData() async {
    try {
      final userDetails = await UserService.getUserDetails();

      if (userDetails['user'] != null && userDetails['user']['workout_plan']['workout_plan_details'] != null) {
        setState(() {
          workoutData = userDetails['user']['workout_plan']?['workout_plan_details']?['schedule'] ?? {};
          weightPlanData = userDetails['user']['workout_plan'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No workout plan found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load workout plan. Please try again.';
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text(
          'Workout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.updateIndex(0); // Use the callback to switch tabs instead of navigation
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : (weightPlanData['workout_plan_details'] == null || weightPlanData.isEmpty) // Handle null or empty workout plan
              ? buildWorkoutFallbackUI() // Show fallback UI if no data is available
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: HeaderWidget(
                            heading: 'Workout Plan',
                            caption: "Fitness plan recommended by Trainer.",
                          ),
                        ),
                        const SizedBox(height: 0),
                        WeightPlanWidget(
                          planName: weightPlanData['workout_plan_details']?['workout_plan_name'] ?? 'No Plan Name', // Add default
                          currentWeightHeader: 'Current Weight',
                          currentWeight: weightPlanData['current_weight']?.toInt() ?? 0, // Default to 0
                          currentWeightUnits: 'Kg',
                          goalWeightHeader: 'Goal Weight',
                          goalWeight: weightPlanData['end_weight']?.toInt() ?? 0, // Default to 0
                          goalWeightUnits: 'Kg',
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: HeaderWidget(
                            heading: 'Exercises',
                            caption: "Weekly Exercises curated by Trainer.",
                          ),
                        ),
                        if (workoutData.isNotEmpty)
                          WorkOutPart(workoutData: workoutData)
                        else
                          Center(
                            child: Text(
                              'No exercise schedule available',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

/// Fallback UI when workout data is empty
Widget buildWorkoutFallbackUI() {
  return Center(
    child: Container(
      height: 130,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        'No Workout data available',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}


