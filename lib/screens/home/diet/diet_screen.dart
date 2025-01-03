import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'detox_screen.dart';
import './diet_widgets/menu_plan_widget.dart';
import './diet_plan_part.dart';
import './diet_widgets/guidelines_widget.dart';
import './diet_widgets/header_widget.dart';
import './diet_widgets/image_over_lay_button.dart';

class DietScreen extends StatefulWidget {
  final Function(int) updateIndex;
  const DietScreen({super.key, required this.updateIndex});

  @override
  DietScreenState createState() => DietScreenState();
}

class DietScreenState extends State<DietScreen> {
  Map<String, dynamic> dietData = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadDietData();
  }

  Future<void> _loadDietData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Retrieve user ID and token from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      final String? token = prefs.getString('token');

      if (userId == null || token == null) {
        throw Exception('User credentials not found.');
      }

      // Fetch diet data from the backend
      final String apiUrl = 'https://level-up-backend-9hpz.onrender.com/api/diet-plan/$userId';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          dietData = responseData;
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Handle the 404 error when no data is found
        setState(() {
          dietData = {}; // Clear existing diet data
          isLoading = false;
          errorMessage = 'No Diet data available';
        });
      } else {
        throw Exception('Failed to load diet data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load diet plan. Please try again.';
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  Future<void> _refreshDietData() async {
    await _loadDietData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          'Diet Plan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.updateIndex(0); // Use the callback to switch tabs instead of navigation
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshDietData, // Pull-to-refresh action
              child: dietData.isEmpty
                  ? buildDietFallbackUI() // Fallback UI when diet data is empty
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget(
                              heading: 'Personalised Diet Plan',
                              caption: "Health goals recommended by Trainer.",
                            ),
                            SizedBox(height: 4),
                            buildWeightGainDetails(context, dietData),
                            SizedBox(height: 20),
                            HeaderWidget(
                              heading: 'Curated Menu',
                              caption: 'List of foods to choose from.',
                            ),
                            SizedBox(height: 4),
                            if (dietData['menu_plan'] != null && dietData['menu_plan']['timings'] != null)
                              MenuPlanWidget(timings: dietData['menu_plan']['timings']),
                            if (dietData['menu_plan'] == null || dietData['menu_plan']['timings'].isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('No menu items available for this period.'),
                              ),
                            SizedBox(height: 20),
                            HeaderWidget(
                              heading: 'Detox Plan',
                              caption: 'One day detox plan to lose weight in a healthy way.',
                            ),
                            SizedBox(height: 4),
                            ImageOverlayButton(
                              imagePath: 'assets/image.png',
                              buttonLabel: 'Detox',
                              targetScreen: DetoxScreen(detoxData: dietData['one_day_detox_plan'] ?? {}),
                            ),
                            SizedBox(height: 20),
                            HeaderWidget(
                              heading: 'Guidelines',
                              caption: 'Advice from the Trainers',
                            ),
                            SizedBox(height: 4),
                            if (dietData['guidelines'] != null) ...buildGuidelines(dietData['guidelines']),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  /// Fallback UI when diet data is empty
  Widget buildDietFallbackUI() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(), // Make the fallback UI scrollable
      child: Container(
        height: 600, // Fill the screen height
        alignment: Alignment.center,
        child: Text(
          'No Diet data available',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}