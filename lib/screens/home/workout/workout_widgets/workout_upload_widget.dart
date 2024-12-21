import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutUploadDialog extends StatefulWidget {
  final String workout;
  final String imagePath;
  final int setsAssigned;
  final int repsAssigned;

  const WorkoutUploadDialog({
    Key? key,
    required this.workout,
    required this.imagePath,
    required this.setsAssigned,
    required this.repsAssigned,
  }) : super(key: key);

  @override
  _WorkoutUploadDialogState createState() => _WorkoutUploadDialogState();
}

class _WorkoutUploadDialogState extends State<WorkoutUploadDialog> {
  late TextEditingController setsController;
  late TextEditingController repsController;
  late TextEditingController weightController;
  String? selectedIntensity = "5";  // Default intensity value
  bool isUploading = false;  // To manage loading state

  @override
  void initState() {
    super.initState();
    setsController = TextEditingController(text: '0'); // Default to 0
    repsController = TextEditingController(text: '0'); // Default to 0
    weightController = TextEditingController(); // Optional weight field
  }

  @override
  void dispose() {
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    super.dispose();
  }

  // Function to upload workout data to the backend
  Future<void> _uploadWorkout() async {
    // Show loading dialog before starting the upload
    setState(() {
      isUploading = true;
    });

    final String token = await _getToken();

    if (token.isEmpty) {
      // Handle no token scenario
      setState(() {
        isUploading = false;
      });
      _showMessageDialog('Authentication token is missing.', 'Please log in again.', Colors.red, false);
      return;
    }

    final String url = 'https://level-up-backend-9hpz.onrender.com/api/exercise/upload_workout_task';
    final Map<String, dynamic> workoutData = {
      'workout': {
        'workout_name': widget.workout,
        'sets_assigned': widget.setsAssigned,
        'sets_done': int.tryParse(setsController.text) ?? 0,
        'reps_assigned': widget.repsAssigned,
        'reps_done': int.tryParse(repsController.text) ?? 0,
        'weight': weightController.text.isNotEmpty ? double.tryParse(weightController.text) ?? 1.0 : 1.0,
        'intensity': int.tryParse(selectedIntensity ?? '5') ?? 5,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(workoutData),
      );

      // Close the loading dialog after the upload is complete
      setState(() {
        isUploading = false;
      });

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        print('Upload success: $responseJson');
        
        // Show success message pop-up
        _showMessageDialog('Upload Successful!', 'Your workout data has been successfully uploaded.', Colors.green, true);
      } else {
        print('Upload failed with status: ${response.statusCode}');
        _showMessageDialog('Upload Failed!', 'There was an error uploading your workout data. Please try again.', Colors.red, false);
      }
    } catch (e) {
      print('Error during upload: $e');
      
      // Close the loading dialog in case of an error
      setState(() {
        isUploading = false;
      });

      // Show failure message pop-up
      _showMessageDialog('Upload Failed!', 'An error occurred during the upload. Please check your connection and try again.', Colors.red, false);
    }
  }

  // Function to get token from shared preferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
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
                  'Workout Upload',
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imagePath,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text('Workout', style: TextStyle(fontWeight: FontWeight.w600)),
              TextField(
                readOnly: true,
                controller: TextEditingController(text: widget.workout),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                decoration: InputDecoration(
                  fillColor: Colors.orange[200],
                  hintText: 'Workout name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange.withOpacity(0.6), width: 1.5),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sets', style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          height: 50,
                          child: TextField(
                            controller: setsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter sets',
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
                        const Text('Reps', style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          height: 50,
                          child: TextField(
                            controller: repsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter reps',
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
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weight (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          height: 50,
                          child: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter weight',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Intensity', style: TextStyle(fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.6),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (selectedIntensity != null && int.parse(selectedIntensity!) > 1) {
                                      selectedIntensity = (int.parse(selectedIntensity!) - 1).toString();
                                    }
                                  });
                                },
                                color: Colors.blue,
                              ),
                              Text(
                                selectedIntensity ?? "5",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    if (selectedIntensity != null && int.parse(selectedIntensity!) < 10) {
                                      selectedIntensity = (int.parse(selectedIntensity!) + 1).toString();
                                    }
                                  });
                                },
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _uploadWorkout,
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
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
