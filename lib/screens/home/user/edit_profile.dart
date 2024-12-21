import 'package:LevelUp/services/profile_update.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileScreen({super.key, required this.userData, required this.onSave});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController heightController;
  late TextEditingController occupationController;
  late TextEditingController addressController;

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['user']['name'] ?? '');
    phoneController = TextEditingController(text: widget.userData['user']['phone_no'] ?? '');
    heightController = TextEditingController(text: widget.userData['user']['height'].toString());
    occupationController = TextEditingController(text: widget.userData['user']['occupation'] ?? '');
    addressController = TextEditingController(text: widget.userData['user']['address'] ?? '');
  }

  // Show the bottom sheet to pick an image from the gallery or camera
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _profileImage = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);  // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Choose from gallery'),
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _profileImage = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);  // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image container
              Center(
                child: GestureDetector(
                  onTap: _pickImage,  // Image picker on tap
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      shape: BoxShape.circle,
                      image: _profileImage != null
                          ? DecorationImage(image: FileImage(_profileImage!), fit: BoxFit.cover)
                          : DecorationImage(image: AssetImage('assets/images/profile/chetan.jpg'), fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Form fields for user details
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: 'Name',
                      controller: nameController,
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      label: 'Phone Number',
                      controller: phoneController,
                      icon: Icons.phone,
                    ),
                    _buildTextField(
                      label: 'Height',
                      controller: heightController,
                      icon: Icons.height,
                    ),
                    _buildTextField(
                      label: 'Occupation',
                      controller: occupationController,
                      icon: Icons.work,
                    ),
                    _buildTextField(
                      label: 'Address',
                      controller: addressController,
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Call the profile update service
                    var result = await ProfileUpdateService.updateProfile(
                      name: nameController.text,
                      phoneNo: phoneController.text,
                      height: int.tryParse(heightController.text),
                      address: addressController.text,
                      profileImage: _profileImage,
                      context: context,
                    );

                    if (result['success']) {
                      // Handle success (e.g., show a success message)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
                      Navigator.pop(context);  // Close the screen
                    } else {
                      // Handle failure (e.g., show an error message)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 1),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
