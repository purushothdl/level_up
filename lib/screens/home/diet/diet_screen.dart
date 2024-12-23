import 'dart:async';
import 'package:flutter/material.dart';
import 'package:LevelUp/screens/home/home_screen.dart';
import 'package:LevelUp/services/user_service.dart';
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
  late StreamSubscription _userDataSubscription;

  @override
  void initState() {
    super.initState();
    _loadDietData();
    
    // Subscribe to user data updates
    _userDataSubscription = UserService.userDataStream.listen((userData) {
      if (mounted) {
        setState(() {
          dietData = userData['user']['diet_plan'] ?? {};
        });
      }
    });
  }

  Future<void> _loadDietData() async {
    try {
      final userDetails = await UserService.getUserDetails();

      if (userDetails['user'] != null && userDetails['user']['diet_plan'] != null) {
        setState(() {
          dietData = userDetails['user']['diet_plan'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No diet plan found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load diet plan. Please try again.';
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
        title: Text(
          'Diet Plan',
          style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20),
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
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage)) // Show error if any
              : SingleChildScrollView(
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
                        if (dietData['menu_plan'] != null &&
                            dietData['menu_plan']['timings'] != null)
                          MenuPlanWidget(timings: dietData['menu_plan']['timings']),
                        if (dietData['menu_plan'] == null ||
                            dietData['menu_plan']['timings'].isEmpty)
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
                          targetScreen: DetoxScreen(),
                        ),
                        SizedBox(height: 20),
                        HeaderWidget(
                          heading: 'Guidelines',
                          caption: 'Advice from the Trainers',
                        ),
                        SizedBox(height: 4),
                        if (dietData['guidelines'] != null)
                          ...buildGuidelines(dietData['guidelines']),
                      ],
                    ),
                  ),
                ),
    );
  }
}
