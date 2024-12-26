import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:convert';  // For handling the response in JSON format
import 'package:shared_preferences/shared_preferences.dart'; // For token management

import '../../diet/diet_widgets/upload_widgets/dashed_border_painter.dart'; // Make sure this file exists

class WeightHeightUploadDialog extends StatefulWidget {
  final double initialWeight;  // Add this parameter to accept the weight from the parent widget
  
  const WeightHeightUploadDialog({Key? key, required this.initialWeight}) : super(key: key);

  @override
  State<WeightHeightUploadDialog> createState() =>
      _WeightHeightUploadDialogState();
}

class _WeightHeightUploadDialogState extends State<WeightHeightUploadDialog> {
  late TextEditingController weightController; // Make it late to initialize in initState
  File? uploadedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController(text: widget.initialWeight.toStringAsFixed(1)); // Set the initial weight
  }

  // Simulating an image picker function
  void _pickImage() async {
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

  // Function to handle the upload
  Future<void> _upload() async {
    // Show loading dialog while uploading
    setState(() {
      _isUploading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print('Token is missing!');
      setState(() {
        _isUploading = false;
      });
      return;
    }

    final Uri apiUrl = Uri.parse('https://level-up-backend-9hpz.onrender.com/api/user/upload_weight');
    var request = http.MultipartRequest('POST', apiUrl);

    // Set headers with the authorization token
    request.headers['Authorization'] = 'Bearer $token';

    // Add the form fields for weight and height
    request.fields['weight'] = weightController.text;

    // Add the image if it's available
    if (uploadedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          uploadedImage!.path,
          contentType: MediaType('image', 'jpeg'), // You can adjust the content type based on the image
        ),
      );
    }

    try {
      final response = await request.send();

      // After the upload completes, stop the loading state
      setState(() {
        _isUploading = false;
      });

      if (response.statusCode == 201) {
        // If the upload is successful, show success message
        final responseData = await response.stream.bytesToString();
        final responseJson = jsonDecode(responseData);

        print('Upload success: $responseJson');
        _showMessageDialog('Upload Successful!', 'Your weight has been successfully uploaded.', Colors.green, true);
      } else if (response.statusCode == 400){
        // If upload fails, show failure message
        _showMessageDialog('Upload Failed!', 'You have already uploaded your weight for this week!', Colors.red, false);
      }
    } catch (e) {
      print('Error during upload: $e');
      setState(() {
        _isUploading = false;
      });
      _showMessageDialog('Upload Failed!', 'An error occurred during the upload. Please check your connection and try again.', Colors.red, false);
    }
  }

  // Function to show success or failure pop-up
  void _showMessageDialog(String title, String message, Color color, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 20),
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
                  color: Colors.orange.withOpacity(1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  'Weight Upload',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Weight Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weight (kg)', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                        const SizedBox(height: 5),
                        TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter weight',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green.withOpacity(0.6), width: 1.5),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 16),
              // Image Upload Section
              const Text('Image', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
              SizedBox(height: 5,),
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
            onPressed: _isUploading ? null : _upload,  // Disable button if uploading
            style: TextButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              backgroundColor: Colors.green.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _isUploading ? 'Uploading...' : 'Upload',  // Change button text when uploading
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