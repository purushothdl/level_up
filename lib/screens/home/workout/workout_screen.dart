import 'package:flutter/material.dart';
import 'package:LevelUp/services/user_service.dart';
import '../home_screen.dart';
import 'weight_plan_part.dart';
import 'workout_part.dart';
import '../diet/diet_widgets/header_widget.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  Map<String, dynamic> workoutData = {};
  Map<String, dynamic> weightPlanData = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    try {
      final userDetails = await UserService.getUserDetails();
      setState(() {
        workoutData = userDetails['user']['workout_plan']?['workout_plan_details']?['schedule'] ?? {};
        weightPlanData = userDetails['user']['workout_plan'] ?? {};
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load workout data.';
        isLoading = false;
      });
      print("Error loading workout data: $e");
    }
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
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
                          planName: weightPlanData['workout_plan_details']['workout_plan_name'],
                          currentWeightHeader: 'Current Weight',
                          currentWeight: weightPlanData['current_weight']?.toInt() ?? 70,
                          currentWeightUnits: 'Kg',
                          goalWeightHeader: 'Goal Weight',
                          goalWeight: weightPlanData['end_weight']?.toInt() ?? 60.0,
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
                        WorkOutPart(workoutData: workoutData),
                      ],
                    ),
                  ),
                ),
      backgroundColor: Colors.white,
    );
  }
}


