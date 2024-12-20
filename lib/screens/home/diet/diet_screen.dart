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
  const DietScreen({super.key});

  @override
  DietScreenState createState() => DietScreenState();
}

class DietScreenState extends State<DietScreen> {
  Map<String, dynamic> dietData = {}; // To hold parsed JSON data
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // Track errors if fetching fails

  @override
  void initState() {
    super.initState();
    _loadDietData(); // Fetch diet plan on screen load
  }

Future<void> _loadDietData() async {
  try {
    final userDetails = await UserService.getUserDetails(); // Fetch cached data or API call

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
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
                          imagePath: 'assets/images/diet/detox/test_detox.gif',
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
