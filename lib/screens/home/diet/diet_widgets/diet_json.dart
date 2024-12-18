import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String jsonData = ''; // Variable to store the diet plan JSON as a String

// Function to fetch and store diet plan as JSON
Future<void> fetchDietPlan() async {
  try {
    // Access stored user_id and token
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');
    final String? token = prefs.getString('token');

    if (userId == null || token == null) {
      throw Exception("User ID or token is missing. Please log in again.");
    }

    // Construct the API URL
    final String url =
        "https://level-up-backend-9hpz.onrender.com/api/diet-plan/$userId";

    // Make the GET request
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Check for success
    if (response.statusCode == 200) {
      jsonData = response.body; // Store JSON response as a String
      print("Diet Plan Fetched and Stored");
    } else {
      throw Exception(
          "Failed to fetch data. Status Code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching diet plan: $e");
    rethrow;
  }
}

// Function to return the stored diet plan JSON
String getDietJsonData() {
  return jsonData;
}
