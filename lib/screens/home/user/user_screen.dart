import 'package:flutter/material.dart';
import '../../../services/user_service.dart'; // Import your UserService
import 'edit_profile.dart'; // Import the EditProfileScreen

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final data = await UserService.getUserDetails();
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching user data: $e");
    }
  }

  void _updateUserData(Map<String, dynamic> updatedData) {
    setState(() {
      userData = updatedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
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
          : userData == null
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
                                    userData?['user']['name'] ?? "N/A",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    userData?['user']['role'] ?? "N/A",
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
                                  value: userData?['user']?['age'] != null
                                    ? '${userData?['user']?['age']} yrs'
                                    : "N/A",
                                ),
                                InfoColumn(
                                  title: 'Height',
                                  value: userData?['user']?['height'] != null 
                                    ? '${userData?['user']?['height']} cm' 
                                    : "N/A",
                                ),

                                InfoColumn(
                                  title: 'Weight',
                                  value: userData?['user']?['weight'] != null 
                                    ? '${userData?['user']?['weight']} kg' 
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
                                value: userData?['user']['email'] ?? "N/A",
                                iconColor: Colors.orange,
                              ),
                              ContactRow(
                                icon: Icons.phone,
                                label: 'Phone No',
                                value: userData?['user']['phone_no'] ?? "N/A",
                                iconColor: Colors.green,
                              ),
                              ContactRow(
                                icon: Icons.work,
                                label: 'Occupation',
                                value: userData?['user']['occupation'] ?? "N/A",
                                iconColor: Colors.blue,
                              ),
                              ContactRow(
                                icon: Icons.location_on,
                                label: 'Address',
                                value: userData?['user']['address'] ?? "N/A",
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
                                value: (userData?['user']['screening']?['heart_trouble'] ?? "N/A"),
                                iconColor: Colors.red,
                              ),
                              ContactRow(
                                icon: Icons.add_alert,
                                label: 'Chest Pain',
                                value: (userData?['user']['screening']?['chest_pain'] ?? "N/A"),
                                iconColor: Colors.orange,
                              ),
                              ContactRow(
                                icon: Icons.accessibility_new,
                                label: 'Back/Knee Problems',
                                value: (userData?['user']['screening']?['back_or_knees_problem'] ??  "N/A"),
                                iconColor: Colors.blue,
                              ),
                              ContactRow(
                                icon: Icons.restaurant,
                                label: 'Food Preferences',
                                value: userData?['user']['screening']?['food_preferences'] ?? "N/A",
                                iconColor: Colors.purple,
                              ),
                              ContactRow(
                                icon: Icons.warning,
                                label: 'Food Allergies',
                                value: userData?['user']['screening']?['food_allergies'] ?? "None",
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
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
