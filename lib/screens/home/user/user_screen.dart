import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final Map<String, dynamic> userData = {
    "_id": "67138135f52876ae3f39ebaf",
    "name": "Chethan Reddy",
    "email": "achethanreddy1921@gmail.com",
    "role": "CUSTOMER",
    "phone_no": "9030496717",
    "created_at": "2024-10-19T09:51:41.677+00:00",
    "updated_at": "2024-10-19T09:51:41.677+00:00",
    "registration_id": "24LEVELUP0002",
    "verified": true,
    "age": 30,
    "height": "5'9\"",
    "weight": "70kg",
    "occupation": "Software Engineer",
    "address": "123, Main Street, Cityville",
    "medical_info": {
      "heart_trouble": false,
      "chest_pain": false,
      "back_knee_problems": true,
      "injuries": false,
      "food_preferences": "Vegetarian",
      "food_allergies": "None",
    }
  };

  UserScreen({super.key});

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
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(16.0), // Add margin to the body content
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8), // Padding inside the column
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
                            userData['name'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            ' ${userData['role']}',
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
                        InfoColumn(title: 'Age', value: userData['age'].toString()),
                        InfoColumn(title: 'Height', value: userData['height']),
                        InfoColumn(title: 'Weight', value: userData['weight']),
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
                        value: userData['email'],
                        iconColor: Colors.orange,
                      ),
                      ContactRow(
                        icon: Icons.phone,
                        label: 'Phone No',
                        value: userData['phone_no'],
                        iconColor: Colors.green,
                      ),
                      ContactRow(
                        icon: Icons.work,
                        label: 'Occupation',
                        value: userData['occupation'],
                        iconColor: Colors.blue,
                      ),
                      ContactRow(
                        icon: Icons.location_on,
                        label: 'Address',
                        value: userData['address'],
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // LevelUp Details Widget
                InfoWidget(
                  header: 'LevelUp Details',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContactRow(
                        icon: Icons.card_membership,
                        label: 'Registration ID',
                        value: userData['registration_id'],
                        iconColor: Colors.purple,
                      ),
                      ContactRow(
                        icon: Icons.calendar_today,
                        label: 'Joined At',
                        value: userData['created_at'].split('T')[0],
                        iconColor: Colors.teal,
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
                        value: (userData['medical_info']?['heart_trouble'] ?? false) ? 'Yes' : 'No',
                        iconColor: Colors.red,
                      ),
                      ContactRow(
                        icon: Icons.add_alert,
                        label: 'Chest Pain',
                        value: (userData['medical_info']?['chest_pain'] ?? false) ? 'Yes' : 'No',
                        iconColor: Colors.orange,
                      ),
                      ContactRow(
                        icon: Icons.accessibility_new,
                        label: 'Back/Knee Problems',
                        value: (userData['medical_info']?['back_knee_problems'] ?? false) ? 'Yes' : 'No',
                        iconColor: Colors.blue,
                      ),
                      ContactRow(
                        icon: Icons.healing,
                        label: 'Injuries',
                        value: (userData['medical_info']?['injuries'] ?? false) ? 'Yes' : 'No',
                        iconColor: Colors.green,
                      ),
                      ContactRow(
                        icon: Icons.restaurant,
                        label: 'Food Preferences',
                        value: userData['medical_info']?['food_preferences'] ?? 'Not Specified',
                        iconColor: Colors.purple,
                      ),
                      ContactRow(
                        icon: Icons.warning,
                        label: 'Food Allergies',
                        value: userData['medical_info']?['food_allergies'] ?? 'None',
                        iconColor: Colors.redAccent,
                      ),
                    ],
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
