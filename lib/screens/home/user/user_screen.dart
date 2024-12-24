import 'dart:async';
import 'package:flutter/material.dart';
import '../../../services/user_service.dart';
import 'edit_profile.dart';
import '../home_screen.dart';

class UserScreen extends StatefulWidget {
  final Function(int) updateIndex;
  const UserScreen({super.key, required this.updateIndex});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? user;
  bool isLoading = true;
  late StreamSubscription _userDataSubscription;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    
    // Subscribe to user data updates
    _userDataSubscription = UserService.userDataStream.listen((data) {
      if (mounted) {
        setState(() {
          userData = data;
          user = data['user'];
        });
      }
    });
  }

  Future<void> fetchUserData() async {
    try {
      final data = await UserService.getUserDetails();
      print("Fetched user data: $data");
      if (mounted) {
        setState(() {
          userData = data;
          user = data['user'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching user data: $e");
    }
  }

  void _updateUserData(Map<String, dynamic> updatedData) {
    if (mounted) {
      setState(() {
        userData = updatedData;
        user = updatedData['user'];
      });
    }
  }

  @override
  void dispose() {
    _userDataSubscription.cancel();
    super.dispose();
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
  leading: IconButton( // Place the back arrow here
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
                    onSave: _updateUserData,
                  ),
                ),
              );
            },
    ),
  ],
),

      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user == null
              ? Center(child: Text("Failed to load user data"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                                  backgroundImage: AssetImage('assets/images/profile/chetan.jpg'),
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
                                    user?['name'] ?? "N/A",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user?['role'] ?? "N/A",
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
                                  value: user?['age'] != null
                                    ? '${user?['age']} yrs'
                                    : "N/A",
                                ),
                                InfoColumn(
                                  title: 'Height',
                                  value: user?['height'] != null 
                                    ? '${user?['height']} cm' 
                                    : "N/A",
                                ),

                                InfoColumn(
                                  title: 'Weight',
                                  value: user?['weight'] != null 
                                    ? '${user?['weight']} kg' 
                                    : "N/A",
                                ),
                              ],
                            ),
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
                                value: user?['email'] ?? "N/A",
                                iconColor: Colors.orange,
                              ),
                              ContactRow(
                                icon: Icons.phone,
                                label: 'Phone No',
                                value: user?['phone_no'] ?? "N/A",
                                iconColor: Colors.green,
                              ),
                              ContactRow(
                                icon: Icons.work,
                                label: 'Occupation',
                                value: user?['occupation'] ?? "N/A",
                                iconColor: Colors.blue,
                              ),
                              ContactRow(
                                icon: Icons.location_on,
                                label: 'Address',
                                value: user?['address'] ?? "N/A",
                                iconColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Medical Info Widget
                        InfoWidget(
                          header: 'Medical Info',
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ContactRow(
                                icon: Icons.favorite,
                                label: 'Heart Trouble',
                                value: (user?['screening']?['heart_trouble'] ?? "N/A"),
                                iconColor: Colors.red,
                              ),
                              ContactRow(
                                icon: Icons.add_alert,
                                label: 'Chest Pain',
                                value: (user?['screening']?['chest_pain'] ?? "N/A"),
                                iconColor: Colors.orange,
                              ),
                              ContactRow(
                                icon: Icons.accessibility_new,
                                label: 'Back/Knee Problems',
                                value: (user?['screening']?['back_or_knees_problem'] ??  "N/A"),
                                iconColor: Colors.blue,
                              ),
                              ContactRow(
                                icon: Icons.restaurant,
                                label: 'Food Preferences',
                                value: user?['screening']?['food_preferences'] ?? "N/A",
                                iconColor: Colors.purple,
                              ),
                              ContactRow(
                                icon: Icons.warning,
                                label: 'Food Allergies',
                                value: user?['screening']?['food_allergies'] ?? "None",
                                iconColor: Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
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
