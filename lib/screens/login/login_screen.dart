import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../questionnaire/get_screening.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs(); // Initialize SharedPreferences
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

Future<void> _login() async {
  final String url = 'https://level-up-backend-9hpz.onrender.com/api/auth/login';

  if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
    setState(() {
      _errorMessage = 'Incorrect Email or Password';
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String token = responseBody['access_token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // Fetch user_id after login
      await _fetchUserId(token);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GetScreeningScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Incorrect Email or Password';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An error occurred. Please try again.';
    });
  }
}

Future<void> _fetchUserId(String token) async {
  final response = await http.get(
    Uri.parse('https://level-up-backend-9hpz.onrender.com/api/me'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    String userId = data['user']['id'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);

    print("User ID Stored: $userId");
  } else {
    print("Failed to fetch user ID.");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/logo.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 10),
                Text(
                  'Level Up',
                  style: TextStyle(
                    fontFamily: 'Jersey20-Regular',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(thickness: 1, color: Colors.grey[400]),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(  // Wrap with SingleChildScrollView
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              Text(
                'Log in with your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              // Display success or error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _errorMessage == 'You will be logged in shortly'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () => _login(), // Call the login function
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange[700],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Add Sign-Up functionality here
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
