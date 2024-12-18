import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final String? header;
  final String number;
  final String unit;

  const InfoContainer({
    super.key,
    this.header, // Make header optional
    required this.number,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    // Set responsive sizes
    final double containerWidth = screenWidth * 0.25; // 30% of screen width
    final double containerHeight = 55; // Fixed height
    final double headerFontSize = screenWidth < 400 ? 10 : 12; // Responsive header font size
    final double numberFontSize = screenWidth < 400 ? 22 : 24; // Responsive number font size
    final double unitFontSize = screenWidth < 400 ? 10 : 12; // Responsive unit font size

    return Container(
      width: containerWidth, // Responsive width
      height: containerHeight, // Fixed height
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
        children: [
          if (header != null && header!.isNotEmpty) ...[ // Check if header is not null and not empty
            Text(
              header!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: headerFontSize, // Responsive font size
                color: Colors.black, // Header text color
              ),
              textAlign: TextAlign.center, // Center the header text
            ),
            const SizedBox(height: 4), // Space between header and number/unit
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the row's children
            children: [
              Text(
                number,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: numberFontSize, // Responsive font size
                  fontWeight: FontWeight.w700,
                  color: Colors.black, // Black color
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 5), // Space between number and unit
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Padding around the text
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 237, 237), // Grey background
                    border: Border.all(color: const Color.fromARGB(255, 236, 236, 236)), // Grey border
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Center( // Center the unit text
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: unitFontSize, // Responsive font size
                        color: Colors.orange, // Orange color
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
