import 'package:flutter/material.dart';
import './diet_widgets/build_info_widget.dart';

Widget buildWeightGainDetails(BuildContext context, Map<String, dynamic> dietData) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildInfoItem(
                "BMI",
                dietData['bmi'] ?? 'N/A', // Provide 'N/A' if null
                'Current BMI',
                context,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: buildInfoItem(
                "Desired Weight",
                dietData['desired_weight'] ?? 'N/A',
                'Goal ${dietData['desired_weight'] ?? 'N/A'}',
                context,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: buildInfoItem(
                "Desired Calories",
                dietData['desired_calories'] ?? 'N/A',
                'Goal ${dietData['desired_calories'] ?? 'N/A'}',
                context,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: buildInfoItem(
                "Desired Protein",
                dietData['desired_proteins'] ?? 'N/A',
                'Goal ${dietData['desired_proteins'] ?? 'N/A'}',
                context,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
