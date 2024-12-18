import 'package:flutter/material.dart';
import './menu_card_widget.dart';
import './utils/get_image_paths.dart';

class MenuPlanWidget extends StatefulWidget {
  final Map<String, dynamic> timings;

  const MenuPlanWidget({super.key, required this.timings});

  @override
  _MenuPlanWidgetState createState() => _MenuPlanWidgetState();
}

class _MenuPlanWidgetState extends State<MenuPlanWidget> {
  String selectedPeriod = 'morning';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 237, 237),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color.fromARGB(255, 183, 182, 182),
                width: 0.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(child: _buildToggleButton('Morning', 'morning')),
                Flexible(child: _buildToggleButton('Afternoon', 'afternoon')),
                Flexible(child: _buildToggleButton('Evening', 'evening')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildFilteredMenu(),
      ],
    );
  }

  Widget _buildToggleButton(String label, String period) {
    bool isSelected = selectedPeriod == period;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.black
                : const Color.fromARGB(255, 128, 128, 128),
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredMenu() {
    Map<String, dynamic> filteredTimings = {};
    widget.timings.forEach((time, details) {
      if (_isTimeInPeriod(time, selectedPeriod)) {
        filteredTimings[time] = details;
      }
    });

    return Column(
      children: filteredTimings.keys.map((time) {
        return MenuCard(
          time: time,
          details: filteredTimings[time],
          imagePaths: getImagePathsForTiming(time, selectedPeriod),
        );
      }).toList(),
    );
  }

  bool _isTimeInPeriod(String time, String period) {
    int hour = int.parse(time.split(':')[0]);
    if (time.contains('PM') && hour != 12) hour += 12;

    switch (period) {
      case 'morning':
        return hour >= 6 && hour < 12;
      case 'afternoon':
        return hour >= 12 && hour < 18;
      case 'evening':
        return hour >= 18 || hour < 6;
      default:
        return false;
    }
  }
}
