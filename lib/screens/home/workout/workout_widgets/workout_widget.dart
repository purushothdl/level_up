import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'number_info_widget.dart'; // Adjust the import path as necessary
import 'workout_upload_widget.dart';
import '../../diet/diet_widgets/utils/capitalize_words.dart';

class WorkoutWidget extends StatelessWidget {
  final String workout;
  final String level;
  final int sets;
  final int reps;
  final String type;

  const WorkoutWidget({
    super.key,
    required this.workout,
    required this.level,
    required this.sets,
    required this.reps,
    required this.type,
  });

  Color _getLevelColor(String level) {
    switch (level) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'bodyweight':
        return Colors.blue;
      case 'strength':
        return Colors.lime.shade900;
      case 'core':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Future<String> _getImagePath(String workout) async {
    String imagePath = 'assets/images/workouts/$workout.gif';
    bool exists = await _assetExists(imagePath);
    return exists ? imagePath : 'assets/images/workouts/Deadlift.gif'; // Default GIF path
  }

  Future<bool> _assetExists(String path) async {
    try {
      final ByteData data = await rootBundle.load(path);
      return data.buffer.asUint8List().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getImagePath(workout),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return GestureDetector(
          onTap: () => _showWorkoutDialog(context, snapshot.data!),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(snapshot.data!, width: 70, height: 60),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeWords(workout),
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Medium',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getLevelColor(level).withOpacity(0.2),
                              border: Border.all(color: _getLevelColor(level)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              capitalizeWords(level),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _getLevelColor(level),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(type),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        capitalizeWords(type),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color.fromARGB(255, 185, 185, 185),
                        width: 0.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoContainer(number: '$sets', unit: 'Sets'),
                      InfoContainer(number: '$reps', unit: 'Reps'),
                      const InfoContainer(number: '200', unit: 'Kcal'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWorkoutDialog(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WorkoutUploadDialog(
        workout: workout,
        sets: sets,
        reps: reps,
        imagePath: 'assets/images/workouts/$workout.gif',
      );
    },
  );
}
}

//   void _showWorkoutDialog(BuildContext context, String imagePath) {
//     TextEditingController setsController = TextEditingController(text: '$sets');
//     TextEditingController repsController = TextEditingController(text: '$reps');
//     TextEditingController weightController = TextEditingController();
//     String? selectedIntensity;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               contentPadding: const EdgeInsets.all(16),
//               title: Container(
//                 height: 40,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         child: const Text(
//                           'Workout Upload',
//                           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: 0,
//                       child: Container(
//                         height: 30,
//                         width: 30,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.red.withOpacity(0.2),
//                         ),
//                         child: IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           icon: const Icon(Icons.close, color: Colors.red),
//                           iconSize: 15,
//                           padding: const EdgeInsets.all(4),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               content: Container(
//                 width: 500,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.asset(
//                             imagePath,
//                             width: 200,
//                             height: 200,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 5),
//                       // Workout identifier
//                       const Text('Workout', style: TextStyle(fontWeight: FontWeight.w600)),
//                       // Wrap the workout name in a TextField and make it read-only with glowing orange border
//                       TextField(
//                         readOnly: true,
//                         controller: TextEditingController(text: workout),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: 'Workout name',
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.orange, width: 2.0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.orange.withOpacity(0.6), width: 1.5),
//                           ),
//                           border: const OutlineInputBorder(),
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Adjust padding as needed
//                         ),
//                       ),  

//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Sets', style: TextStyle(fontWeight: FontWeight.w600)),
//                                 TextField(
//                                   controller: setsController,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter sets',
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Reps', style: TextStyle(fontWeight: FontWeight.w600)),
//                                 TextField(
//                                   controller: repsController,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter reps',
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Weight (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
//                                 TextField(
//                                   controller: weightController,
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter weight',
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
//                                     ),
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Intensity', style: TextStyle(fontWeight: FontWeight.w600)),
//                                 DropdownButtonFormField<String>(
//                                   value: selectedIntensity,
//                                   hint: const Text('1', style: TextStyle(fontSize: 16)),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       selectedIntensity = newValue!;
//                                     });
//                                   },
//                                   items: List.generate(10, (index) => '${index + 1}')
//                                       .map<DropdownMenuItem<String>>((String value) {
//                                     return DropdownMenuItem<String>(
//                                       value: value,
//                                       child: Text(value, style: const TextStyle(color: Colors.black)),
//                                     );
//                                   }).toList(),
//                                   decoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                       borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(4.0),
//                                       borderSide: BorderSide(color: Colors.blue.withOpacity(0.6), width: 1.5),
//                                     ),
//                                   ),
//                                   dropdownColor: Colors.white,
//                                   style: const TextStyle(fontSize: 14, color: Colors.black),
//                                   icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
//                                   isExpanded: true,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Center(
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           style: TextButton.styleFrom(
//                             side: const BorderSide(color: Colors.green),
//                             backgroundColor: Colors.green.withOpacity(0.2),
//                             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           child: const Text(
//                             'Upload',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
