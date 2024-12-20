import 'package:flutter/material.dart';
import 'workout_widgets/navbar_widget.dart';
import 'workout_widgets/workout_widget.dart';

class WorkOutPart extends StatefulWidget {
  final Map<String, dynamic> workoutData;

  const WorkOutPart({super.key, required this.workoutData});

  @override
  State<WorkOutPart> createState() => _WorkOutPartState();
}

class _WorkOutPartState extends State<WorkOutPart> {
  int _selectedIndex = 0;
  final List<Weekday> daysOfWeek = Weekday.values;

  @override
  Widget build(BuildContext context) {
    String selectedDay = daysOfWeek[_selectedIndex].toFullString();

    List<dynamic> exercises = (widget.workoutData[selectedDay] ?? [])
        .where((exercise) => exercise != null)
        .toList();

    return Column(
      children: [
        const SizedBox(height: 10),
        NavbarWidget(
          values: daysOfWeek.map((e) => e.toString().split('.').last).toList(),
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        const SizedBox(height: 10),
        // Use PageStorageKey to preserve scroll position for each tab
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          key: PageStorageKey<int>(_selectedIndex),  // This ensures the scroll position is saved per tab
          children: exercises.isNotEmpty
              ? exercises.map((exercise) {
                  return WorkoutWidget(
                    workout: exercise['name'] ?? 'Unnamed Workout',
                    level: exercise['level'] ?? 'Unknown Level',
                    sets: exercise['sets'] ?? 0,
                    reps: exercise['reps'] ?? 0,
                    type: exercise['type'] ?? 'Unknown Type',
                  );
                }).toList()
              : [
                  SizedBox(height: 80),
                  const Center(
                    child: Text(
                      'No exercises available for this day.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
        ),
      ],
    );
  }
}



// Weekday enum and extension
enum Weekday { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

extension WeekdayExtension on Weekday {
  String toFullString() {
    switch (this) {
      case Weekday.Mon:
        return 'Monday';
      case Weekday.Tue:
        return 'Tuesday';
      case Weekday.Wed:
        return 'Wednesday';
      case Weekday.Thu:
        return 'Thursday';
      case Weekday.Fri:
        return 'Friday';
      case Weekday.Sat:
        return 'Saturday';
      case Weekday.Sun:
        return 'Sunday';
    }
  }
}
