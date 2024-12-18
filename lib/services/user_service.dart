import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Map<String, dynamic>? _userDetails; // Cache variable

  // Fetch user details if not already fetched
  static Future<Map<String, dynamic>> getUserDetails() async {
    if (_userDetails != null) {
      print("Using cached user details");
      return _userDetails!; // Return cached data
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? userId = prefs.getString('user_id');

    if (token == null) {
      throw Exception("Token is missing. Please log in again.");
    }

    final response = await http.get(
      Uri.parse('https://level-up-backend-9hpz.onrender.com/api/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _userDetails = json.decode(response.body); // Cache user details
      print("User details fetched and cached: $_userDetails");
      return _userDetails!;
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  // Method to clear cached data (e.g., on logout)
  static void clearCache() {
    _userDetails = null;
  }
}
