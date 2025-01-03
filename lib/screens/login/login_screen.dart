import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../questionnaire/get_screening.dart';
import '../loading/subscription_expired.dart';

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
  bool _isPasswordVisible = false; // Track the password visibility state

  @override
  void initState() {
    super.initState();
    _initPrefs(); // Initialize SharedPreferences
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible; // Toggle the visibility state
    });
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

      // Check subscription plan validity
      final validityResponse = await http.get(
        Uri.parse('https://level-up-backend-9hpz.onrender.com/api/user/check_plan_validity/${prefs.getString('user_id')}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (validityResponse.statusCode == 200) {
        final validityData = json.decode(validityResponse.body);
        final bool isPlanValid = validityData['is_valid'];

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
      } else {
        // Handle API errors
        setState(() {
          _errorMessage = 'Failed to check subscription plan. Please try again.';
        });
      }
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
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            // Top Section with background image and circular logo
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login/gym_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 185),
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/icons/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Wrap content in a container with margin
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(255, 245, 245, 245),
                                prefixIcon: const Icon(Icons.email, color: Colors.blueGrey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                                ),
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible, // Toggle visibility
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(255, 245, 245, 245),
                                prefixIcon: const Icon(Icons.lock, color: Colors.blueGrey),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility 
                                        : Icons.visibility_off,
                                    color: Colors.orange,
                                  ),
                                  onPressed: _togglePasswordVisibility, // Toggle visibility
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                                ),
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Display error message if any
                            if (_errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ElevatedButton(
                              onPressed: () => _login(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[700],
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                shadowColor: Colors.orange,
                                side: const BorderSide(color: Colors.transparent),
                                elevation: 4,
                              ).copyWith(
                                side: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const BorderSide(color: Colors.orange, width: 2);
                                  }
                                  return BorderSide.none;
                                }),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'For login credentials, contact Admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



