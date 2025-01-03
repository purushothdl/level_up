import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../login/login_screen.dart';
import '../questionnaire/get_screening.dart';
import 'subscription_expired.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _checkLoginStatus(); // Check login status and navigate accordingly
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('user_id');

    // Navigate based on whether token and user_id exist
    if (token != null && userId != null) {
      // Call the check_plan_validity API
      final response = await http.get(
        Uri.parse('https://level-up-backend-9hpz.onrender.com/api/user/check_plan_validity/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool isPlanValid = responseData['is_valid'];

        // Navigate based on plan validity
        Timer(const Duration(seconds: 0), () {
          if (isPlanValid) {
            // Plan is valid, navigate to GetScreeningScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GetScreeningScreen()),
            );
          } else {
            // Plan is expired, navigate to SubscriptionExpiredScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SubscriptionExpiredScreen()),
            );
          }
        });
      } else {
        // Handle API errors
        Timer(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    } else {
      // User is not logged in, navigate to LoginScreen
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.2).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Image.asset(
            'assets/icons/logo.png',
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}