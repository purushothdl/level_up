import 'package:flutter/material.dart';
import 'edit_profile.dart';


class UserScreen extends StatelessWidget {
  final Map<String, dynamic> userData = {
    "_id": "67138135f52876ae3f39ebaf",
    "name": "Chethan",
    "email": "achethanreddy1921@gmail.com",
    "role": "CUSTOMER",
    "phone_no": "9030496717",
    "created_at": "2024-10-19T09:51:41.677+00:00",
    "updated_at": "2024-10-19T09:51:41.677+00:00",
    "registration_id": "24LEVELUP0002",
    "verified": true,
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Photo
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/profile/chetan.jpg'), // Placeholder image
                ),
              ),
              SizedBox(height: 10),
              // Edit Profile Button
              ElevatedButton(
               onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userData: userData,
                    ),
                  ),
                );
              },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              // User Details Cards
              CustomerDetailsCard(
                icon: Icons.person,
                iconColor: Colors.teal,
                text: 'Name',
                subtitle: userData['name'],
              ),
              SizedBox(height: 10),
              CustomerDetailsCard(
                icon: Icons.email,
                iconColor: Colors.orange,
                text: 'Email',
                subtitle: userData['email'],
              ),
              SizedBox(height: 10),
              CustomerDetailsCard(
                icon: Icons.phone,
                iconColor: Colors.green,
                text: 'Phone Number',
                subtitle: userData['phone_no'],
              ),
              SizedBox(height: 10),
              CustomerDetailsCard(
                icon: Icons.verified_user,
                iconColor: Colors.purple,
                text: 'Role',
                subtitle: userData['role'],
              ),
              SizedBox(height: 10),
              CustomerDetailsCard(
                icon: Icons.card_membership,
                iconColor: Colors.red,
                text: 'Registration ID',
                subtitle: userData['registration_id'],
              ),
              SizedBox(height: 10),
              CustomerDetailsCard(
                icon: userData['verified'] ? Icons.check_circle : Icons.error,
                iconColor: userData['verified'] ? Colors.green : Colors.red,
                text: 'Verification Status',
                subtitle: userData['verified'] ? 'Verified' : 'Not Verified',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerDetailsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final String subtitle;

  const CustomerDetailsCard({super.key, 
    required this.icon,
    required this.text,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
