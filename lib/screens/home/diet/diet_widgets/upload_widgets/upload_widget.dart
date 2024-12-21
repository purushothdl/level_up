import 'dart:convert';
import 'dart:io';
import './dashed_border_painter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class MenuDialog extends StatefulWidget {
  // Existing properties
  final dynamic menuItem;
  final String imagePath;
  final Map<String, bool> imageExistenceCache;

  const MenuDialog({
    Key? key,
    required this.menuItem,
    required this.imagePath,
    required this.imageExistenceCache,
  }) : super(key: key);

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  late TextEditingController foodController;
  late TextEditingController quantityController;
  String? selectedUnit;
  File? uploadedImage;

  @override
  void initState() {
    super.initState();
    foodController = TextEditingController(text: widget.menuItem['food_name']);
    quantityController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    foodController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  // Pick Image from gallery
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          uploadedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

Future<void> _uploadDietLog() async {
  // Show a loading dialog before starting the upload
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing the dialog until the upload is complete
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Uploading... Please wait', style: TextStyle(color: Colors.black)),
          ],
        ),
      );
    },
  );

  // Get token from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token == null) {
    // Handle case where token is not available
    print('Token is missing!');
    return;
  }

  final Uri apiUrl = Uri.parse('https://level-up-backend-9hpz.onrender.com/api/diet-plan/upload_diet_logs');
  var request = http.MultipartRequest('POST', apiUrl);

  // Set headers with the authorization token
  request.headers['Authorization'] = 'Bearer $token';

  // Adding form fields (food name, quantity, and units)
  request.fields['food_name'] = foodController.text;
  request.fields['quantity'] = quantityController.text;
  request.fields['units'] = selectedUnit ?? ''; // Can be null if not selected

  // Adding image file if available
  if (uploadedImage != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        uploadedImage!.path,
        contentType: MediaType('image', 'jpeg'), // You can adjust the content type
      ),
    );
  }

  try {
    // Send the request
    final response = await request.send();

    // Close the loading dialog after the upload is complete
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseData);
      print('Upload success: $responseJson');
      
      // Show success message pop-up
      if (mounted) {
        _showMessageDialog('Upload Successful!', 'Your diet log has been successfully uploaded.', Colors.green, true);
      }
    } else {
      print('Upload failed with status: ${response.statusCode}');
      
      // Show failure message pop-up
      if (mounted) {
        _showMessageDialog('Upload Failed!', 'There was an error uploading your diet log. Please try again.', Colors.red, false);
      }
    }
  } catch (e) {
    print('Error during upload: $e');
    
    // Close the loading dialog in case of an error
    Navigator.of(context).pop();

    // Show failure message pop-up
    if (mounted) {
      _showMessageDialog('Upload Failed!', 'An error occurred during the upload. Please check your connection and try again.', Colors.red, false);
    }
  }
}


// Function to show the success or failure pop-up
void _showMessageDialog(String title, String message, Color color, bool isSuccess) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent, // Set the dialog background to transparent
        contentPadding: EdgeInsets.zero, // Remove the default padding for the container

        // Custom container with white background and shadow
        content: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4), // Shadow offset
              ),
            ],
          ),
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon at the top - Green Check or Red Cross
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: isSuccess ? Colors.green : Colors.red,
                size: 50,
              ),
              const SizedBox(height: 20),

              // Success/Failure message
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Close button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: color),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      title: Container(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  'Diet Upload',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.2),
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.red),
                  iconSize: 15,
                  padding: const EdgeInsets.all(4),
                ),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and form fields (same as before)
              // ...
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    widget.imageExistenceCache[widget.imagePath] == true
                        ? widget.imagePath
                        : 'assets/images/diet/menu/oats with milk and fruits.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Food Item', style: TextStyle(fontWeight: FontWeight.w600)),
              TextField(
                controller: foodController,
                decoration: InputDecoration(
                  hintText: 'Enter food name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                  ),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          height: 50,
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter quantity',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Units', style: TextStyle(fontWeight: FontWeight.w600)),
                        DropdownButtonFormField<String>(
                          value: selectedUnit,
                          hint: const Text('gms', style: TextStyle(fontWeight: FontWeight.bold)),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUnit = newValue!;
                            });
                          },
                          items: <String>['gms', 'ml', 'pcs', 'cup', 'tsp']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
                            ),
                          ),
                          dropdownColor: Colors.white,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                          isExpanded: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Text('Image', style: TextStyle(fontWeight: FontWeight.w600)),
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(double.infinity, 100),
                      painter: DashedBorderPainter(),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: uploadedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                uploadedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, color: Colors.blue, size: 30),
                                const SizedBox(height: 8),
                                Text(
                                  'Click to Upload image',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Supports: JPG, JPEG2000, PNG',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              _uploadDietLog(); // Trigger the upload when the button is pressed
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              backgroundColor: Colors.green.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Upload',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
