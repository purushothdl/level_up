import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import 'screening.dart';

class GetScreeningScreen extends StatefulWidget {
  const GetScreeningScreen({super.key});

  @override
  _GetScreeningScreenState createState() => _GetScreeningScreenState();
}

class _GetScreeningScreenState extends State<GetScreeningScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

Future<void> _fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? userId = prefs.getString('user_id');

  if (token == null || userId == null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    return;
  }

  await _checkScreeningDetails(userId);
}

Future<void> _checkScreeningDetails(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  final response = await http.get(
    Uri.parse('https://level-up-backend-9hpz.onrender.com/api/screening/details/$userId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  setState(() {
    loading = false;
  });

  if (response.statusCode == 200) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  } else if (response.statusCode == 404) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ScreeningScreen(userId: userId)),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: ${response.reasonPhrase}')),
    );
  }
}


@override
Widget build(BuildContext context) {
  if (loading) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center( // Use Center to position the child in the middle
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loading/loading_circle.gif'), // Replace with the correct path to your GIF
              fit: BoxFit.cover, // Ensures the GIF fits inside the Container
            ),
          ),
        ),
      ),
    );
  }

  // Replace this with your non-loading UI or return the appropriate widget
  return Scaffold(
    body: Center(child: Text('Not loading')),
  );
}

}
