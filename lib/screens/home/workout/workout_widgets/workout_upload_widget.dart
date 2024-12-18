import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For rootBundle

class WorkoutUploadDialog extends StatefulWidget {
  final String workout;
  final String imagePath;
  final int sets;
  final int reps;

  const WorkoutUploadDialog({
    Key? key,
    required this.workout,
    required this.imagePath,
    required this.sets,
    required this.reps,
  }) : super(key: key);

  @override
  _WorkoutUploadDialogState createState() => _WorkoutUploadDialogState();
}

class _WorkoutUploadDialogState extends State<WorkoutUploadDialog> {
  late TextEditingController setsController;
  late TextEditingController repsController;
  late TextEditingController weightController;
  String? selectedIntensity;

  @override
  void initState() {
    super.initState();
    setsController = TextEditingController(text: '${widget.sets}');
    repsController = TextEditingController(text: '${widget.reps}');
    weightController = TextEditingController(); // Optional field, initially empty
  }

  @override
  void dispose() {
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    super.dispose();
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
                  borderRadius: BorderRadius.circular(16),
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
              // Workout identifier
              const Text('Workout', style: TextStyle(fontWeight: FontWeight.w600)),
              // Wrap the workout name in a TextField and make it read-only with glowing orange border
              TextField(
                readOnly: true,
                controller: TextEditingController(text: widget.workout),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Adjust padding as needed
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
                          height: 50, // Set the height to 50
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
                          height: 50, // Set the height to 50
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
                  )
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
                          height: 50, // Set the height to 50
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
                          child: DropdownButtonFormField<String>(
                            value: selectedIntensity,
                            hint: const Text(
                              'Select Intensity',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedIntensity = newValue!;
                              });
                            },
                            items: List.generate(10, (index) => (index + 1).toString())
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(color: Colors.black)),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Handle workout upload logic here
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
          ),
        ),
      ),
    );
  }
}

