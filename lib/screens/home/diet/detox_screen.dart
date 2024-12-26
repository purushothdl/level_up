import 'package:flutter/material.dart';
import 'package:LevelUp/services/user_service.dart';
import './diet_widgets/menu_plan_widget.dart';

class DetoxScreen extends StatefulWidget {
  final Map<String, dynamic> detoxData;

  const DetoxScreen({super.key, required this.detoxData});

  @override
  State<DetoxScreen> createState() => _DetoxScreenState();
}

class _DetoxScreenState extends State<DetoxScreen> {
  late Map<String, dynamic> detoxData; // Local state for detox data
  bool isLoading = true; // Loading state
  String errorMessage = ''; // Error message

  @override
  void initState() {
    super.initState();
    _initializeDetoxPlan(); // Initialize detox plan from passed data
  }

  void _initializeDetoxPlan() {
    setState(() {
      if (widget.detoxData.isNotEmpty) {
        detoxData = widget.detoxData;
        isLoading = false;
      } else {
        errorMessage = 'No detox plan available.';
        isLoading = false;
      }
    });
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
      body: SingleChildScrollView( // Wrap the body in a scroll view
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loader
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  : detoxData.isNotEmpty
                      ? MenuPlanWidget(timings: detoxData) // Pass detox data to MenuPlanWidget
                      : const Center(child: Text('No detox plan available.')),
        ),
      ),
    );
  }
}
