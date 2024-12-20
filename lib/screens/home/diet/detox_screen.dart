import 'package:flutter/material.dart';
import 'package:LevelUp/services/user_service.dart';
import './diet_widgets/menu_plan_widget.dart';

class DetoxScreen extends StatefulWidget {
  const DetoxScreen({super.key});

  @override
  State<DetoxScreen> createState() => _DetoxScreenState();
}

class _DetoxScreenState extends State<DetoxScreen> {
  Map<String, dynamic> detoxData = {}; // Holds detox data
  bool isLoading = true; // Loading state
  String errorMessage = ''; // Error message

  @override
  void initState() {
    super.initState();
    _loadDetoxPlan(); // Fetch detox plan from cache
  }

  Future<void> _loadDetoxPlan() async {
    try {
      final userDetails = await UserService.getUserDetails(); // Fetch cached user details
      setState(() {
        detoxData = userDetails['user']['diet_plan']['one_day_detox_plan'] ?? {}; 
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load detox plan.';
        isLoading = false;
      });
      print("Error loading detox plan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text(
          'Detox Plan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : detoxData.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MenuPlanWidget(timings: detoxData), // Pass detox data to MenuPlanWidget
                    )
                  : const Center(child: Text('No detox plan available.')),
    );
  }
}
