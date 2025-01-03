import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import '../home_screen.dart';
import '../dashboard/utils/dashboard_utils.dart';
import '../../login/login_screen.dart';

class UserScreen extends StatefulWidget {
  final Function(int) updateIndex;
  const UserScreen({super.key, required this.updateIndex});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Directly fetch user data from the backend
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          isLoading = false;
        });
        return; // No token, handle this case appropriately (you can redirect to login)
      }

      final response = await http.get(
        Uri.parse('https://level-up-backend-9hpz.onrender.com/api/me'),
        headers: {
          'Authorization': 'Bearer $token', // Add token to headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data['user']; // Save user data into the state
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch user data: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching user data: $e");
    }
  }

  Future<void> _onRefresh() async {
    // Refresh the data by re-fetching it
    setState(() {
      isLoading = true; // Show loading while refreshing
    });
    await fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            widget.updateIndex(0);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: isLoading || userData == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          userData: userData!,
                          onSave: (updatedData) {
                            setState(() {
                              userData = updatedData;
                            });
                          },
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh, // Trigger the refresh
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : userData == null
                ? Center(child: Text("Failed to load user data"))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                  backgroundImage: userData?['photo'] != null
                                                ? NetworkImage(userData!['photo'])  // Use the URL from user data
                                                : AssetImage('assets/images/profile/default_profile.jpg') as ImageProvider,  // Fallback to default image if no photo URL
                                  ),
                                  
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData?['name'] ?? "N/A",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      userData?['role'] ?? "N/A",
                                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Personal Details Widget
                          InfoWidget(
                            header: 'Personal Details',
                            content: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InfoColumn(
                                    title: 'Age',
                                    value: userData?['age'] != null
                                        ? '${userData?['age']} yrs'
                                        : "N/A",
                                  ),
                                  InfoColumn(
                                    title: 'Height',
                                    value: userData?['height'] != null
                                        ? '${userData?['height']} cm'
                                        : "N/A",
                                  ),
                                  InfoColumn(
                                    title: 'Weight',
                                    value: userData?['weight'] != null
                                        ? '${userData?['weight']} kg'
                                        : "N/A",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // LevelUp details
                          InfoWidget(
                            header: 'LevelUp Details',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ContactRow(
                                  icon: Icons.perm_identity,
                                  label: 'Registration Id',
                                  value: userData?['registration_id'] ?? "N/A",
                                  iconColor: Colors.blue,
                                ),
                                ContactRow(
                                  icon: Icons.calendar_today,
                                  label: 'Joined',
                                  value: userData?['created_at'] != null
                                      ? formatDateUser(userData!['created_at'])
                                      : "N/A",
                                  iconColor: Colors.purple,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Contact Details Widget
                          InfoWidget(
                            header: 'Contact',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ContactRow(
                                  icon: Icons.email,
                                  label: 'Email',
                                  value: userData?['email'] ?? "N/A",
                                  iconColor: Colors.orange,
                                ),
                                ContactRow(
                                  icon: Icons.phone,
                                  label: 'Phone No',
                                  value: userData?['phone_no'] ?? "N/A",
                                  iconColor: Colors.green,
                                ),
                                ContactRow(
                                  icon: Icons.work,
                                  label: 'Occupation',
                                  value: userData?['occupation'] ?? "N/A",
                                  iconColor: Colors.blue,
                                ),
                                ContactRow(
                                  icon: Icons.location_on,
                                  label: 'Address',
                                  value: userData?['address'] ?? "N/A",
                                  iconColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Logout Button
                          Center(
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: InkWell(
                                onTap: () async {
                                  final prefs = await SharedPreferences.getInstance();

                                  // Clear all cached details
                                  await prefs.clear();

                                  // Navigate back to the LoginScreen directly
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: const Center(
                                    child: Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}



class InfoWidget extends StatelessWidget {
  final String header;
  final Widget content;

  const InfoWidget({super.key, required this.header, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const InfoColumn({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
      ],
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const ContactRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
