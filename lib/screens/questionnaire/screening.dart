import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';

class ScreeningScreen extends StatefulWidget {
  final String userId;

  const ScreeningScreen({super.key, required this.userId});

  @override
  _ScreeningScreenState createState() => _ScreeningScreenState();
}

class _ScreeningScreenState extends State<ScreeningScreen> {
  final List<String> questions = [
    'What is your occupation?',
    'What are your nutrition goals?',
    'What do you usually have for breakfast?',
    'What snacks do you prefer?',
    'What do you usually have for lunch?',
    'What do you usually have for dinner?',
    'Have you checked your blood pressure recently?',
    'Do you drink or smoke?',
    'What is your training goal?',
    'What are your training expectations?',
    'Have you checked your blood glucose level recently?',
    'Do you have any past surgeries?',
    'How much time do you spend working out daily?',
    'What is your lifting experience?',
    'What is your current water intake?',
    'Are you using steroids or drugs?',
    'Are you currently taking any supplements?',
    'What is your lowest weight?',
    'What is your highest weight?',
    'Have you experienced dizziness or balance loss?',
    'Do you have any food allergies?',
    'What is your height in cm?',
    'What is your weight in kg?',
    'What is your age?',
    'How many days do you work out per week?',
    'Do you have any food preferences?',
    'Do you skip meals?',
    'How often do you dine out?',
    'Do you have any heart troubles?',
    'Have you experienced chest pain?',
    'Do you have any injuries?',
    'Are you committed to a workout plan?',
    'Have you had any gaps in lifting?',
    'Do you have any back or knee problems?',
    'Are you okay with a six-day workout plan?',
    'What is your training intensity (1-10)?',
  ];

  final Map<String, String?> responses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        titleSpacing: 16.0,
        title: Padding(
          padding: const EdgeInsets.only(right: 46.0),
          child: Center(
            child: Text(
              'Client Details Form',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questions[index],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          onChanged: (value) {
                            responses[questions[index]] = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitScreeningDetails();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitScreeningDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    
    if (token == null) {
          // Handle the case when the token is not available
          return;
        }

    final response = await http.post(
      Uri.parse('https://level-up-backend-9hpz.onrender.com/api/screening'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': widget.userId,
        'occupation': responses[questions[0]],
        'nutrition_goals': responses[questions[1]],
        'breakfast': responses[questions[2]],
        'snacks': responses[questions[3]],
        'lunch': responses[questions[4]],
        'dinner': responses[questions[5]],
        'blood_pressure_check': responses[questions[6]],
        'drink_or_smoke': responses[questions[7]],
        'training_goal': responses[questions[8]],
        'training_expectations': responses[questions[9]],
        'blood_glucose_level': responses[questions[10]],
        'surgeries': responses[questions[11]],
        'workout_time': responses[questions[12]],
        'lifting_experience': responses[questions[13]],
        'current_water_intake': responses[questions[14]],
        'steroids_or_drugs': responses[questions[15]],
        'supplements_usage': responses[questions[16]],
        'lowest_weight': double.tryParse(responses[questions[17]] ?? '') ?? 0,
        'highest_weight': double.tryParse(responses[questions[18]] ?? '') ?? 0,
        'dizziness_balance_loss': responses[questions[19]],
        'food_allergies': responses[questions[20]],
        'height': double.tryParse(responses[questions[21]] ?? '') ?? 0,
        'weight': double.tryParse(responses[questions[22]] ?? '') ?? 0,
        'age': int.tryParse(responses[questions[23]] ?? '') ?? 0,
        'workout_days_per_week': int.tryParse(responses[questions[24]] ?? '') ?? 0,
        'food_preferences': responses[questions[25]],
        'skip_meals': responses[questions[26]],
        'dine_out_frequency': responses[questions[27]],
        'heart_trouble': responses[questions[28]],
        'chest_pain': responses[questions[29]],
        'injuries': responses[questions[30]],
        'committed': responses[questions[31]],
        'gap_in_lifting': responses[questions[32]],
        'back_or_knees_problem': responses[questions[33]],
        'okay_with_six_day_workout': responses[questions[34]],
        'training_intensity': int.tryParse(responses[questions[35]] ?? '') ?? 0,
      }),
    );

    if (response.statusCode == 201) {
    // Successfully created
    final responseBody = json.decode(response.body);
    final message = responseBody['message'];

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    // Navigate to HomeScreen after a short delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  } else {
    // Handle error response appropriately
    final responseBody = json.decode(response.body);
    final errorMessage = responseBody['detail']['message'] ?? 'An error occurred';

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
}
