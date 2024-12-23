import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Map<String, dynamic>? _userDetails;
  
  // Create a StreamController to broadcast user data updates
  static final _userDataController = StreamController<Map<String, dynamic>>.broadcast();
  
  // Expose the stream for listeners
  static Stream<Map<String, dynamic>> get userDataStream => _userDataController.stream;

  // Fetch user details (from cache or network)
  static Future<Map<String, dynamic>> getUserDetails() async {
    if (_userDetails != null) {
      print("Using cached user details");
      return _userDetails!;
    }
    return fetchFreshUserDetails();
  }

  // Fetch fresh user details and notify listeners
  static Future<Map<String, dynamic>> fetchFreshUserDetails() async {
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
      _userDetails = json.decode(response.body);
      // Notify all listeners of the new data
      _userDataController.add(_userDetails!);
      print("User details fetched and cached: $_userDetails");
      return _userDetails!;
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  // Clear cached data
  static void clearCache() {
    _userDetails = null;
  }

  // Dispose of the StreamController when no longer needed
  static void dispose() {
    _userDataController.close();
  }
}