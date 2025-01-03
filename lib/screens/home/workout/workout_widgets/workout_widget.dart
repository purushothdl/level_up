import 'package:flutter/material.dart';
import 'number_info_widget.dart'; // Adjust the import path as necessary
import 'workout_upload_widget.dart';
import '../../diet/diet_widgets/utils/capitalize_words.dart';

class WorkoutWidget extends StatelessWidget {
  final String workout;
  final String level;
  final int sets;
  final int reps;
  final int calories;
  final String type;
  final String workoutImage; // URL of the workout image

  const WorkoutWidget({
    super.key,
    required this.workout,
    required this.level,
    required this.sets,
    required this.reps,
    required this.calories,
    required this.type,
    required this.workoutImage, // Add workoutImage parameter
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
        return const Color.fromARGB(255, 213, 197, 50);
      case 'strength':
        return Colors.blue;
      case 'core':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showWorkoutDialog(context, workoutImage),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Workout Image (NetworkImage or AssetImage)
                Image(
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  image: workoutImage.isNotEmpty
                      ? NetworkImage(workoutImage) // Use NetworkImage if URL is provided
                      : const AssetImage('assets/images/workouts/Deadlift.gif') as ImageProvider, // Fallback to local asset
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/workouts/Deadlift.gif', // Fallback to local asset if NetworkImage fails
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        capitalizeWords(workout),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getLevelColor(level).withOpacity(0.2),
                              border: Border.all(color: _getLevelColor(level)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              capitalizeWords(level),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: _getLevelColor(level),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12), // Add spacing between level and type
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getTypeColor(type).withOpacity(0.2),
                              border: Border.all(color: _getTypeColor(type)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              capitalizeWords(type),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: _getTypeColor(type),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(top: 5), // Padding for the content
              child: Column(
                children: [
                  // Shortened top border with constant distance from both sides
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust horizontal padding to control the distance
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromARGB(255, 203, 203, 203),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5), // Spacing between the border and the InfoContainer row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InfoContainer(number: '$sets', unit: 'Sets'),
                      InfoContainer(number: '$reps', unit: 'Reps'),
                      InfoContainer(number: '$calories', unit: 'Kcal'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WorkoutUploadDialog(
          workout: workout, // Pass workout name
          setsAssigned: sets, // Pass sets assigned
          repsAssigned: reps, // Pass reps assigned
          imagePath: imagePath, // Pass workout image path
        );
      },
    );
  }
}