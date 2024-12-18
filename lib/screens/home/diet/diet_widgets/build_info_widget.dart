import 'package:flutter/material.dart';

Widget buildInfoItem(String title, String value, String goal, BuildContext context) {
  // Get the screen width
  final double screenWidth = MediaQuery.of(context).size.width;

  // Set responsive font sizes
  final double titleFontSize = screenWidth < 400 ? 16 : 18;
  final double valueFontSize = screenWidth < 400 ? 22 : 26;
  final double unitFontSize = screenWidth < 400 ? 12 : 14;
  final double goalFontSize = screenWidth < 400 ? 12 : 14;

  // Safely split the value into number and unit
  List<String> valueParts = value.split(' ');
  String numberPart = valueParts.isNotEmpty ? valueParts[0] : 'N/A';
  String unitPart = valueParts.length > 1 ? valueParts[1] : '';

  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 211, 211, 211)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 77, 76, 76),
          ),
        ),
        SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              numberPart,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            if (unitPart.isNotEmpty) ...[
              SizedBox(width: 4),
              Text(
                unitPart,
                style: TextStyle(
                  fontSize: unitFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 233, 132, 23),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4),
        Text(
          goal,
          style: TextStyle(
            fontSize: goalFontSize,
            color: const Color.fromARGB(179, 121, 118, 118),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
