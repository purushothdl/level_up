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
    // Get the screen size
    Size screenSize = MediaQuery.of(context).size;

    // Calculate responsive sizes
    double containerWidth = screenSize.width * 0.25; // 25% of screen width
    double containerHeight = 80; // 10% of screen height
    double headerFontSize = screenSize.width < 400 ? 10 : 12; // Smaller font for smaller screens
    double numberFontSize = screenSize.width < 400 ? 18 : 30; // Adjust font size for number
    double unitFontSize = screenSize.width < 400 ? 12 : 14; // Adjust font size for unit

    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (header != null && header!.isNotEmpty) ...[
            Text(
              header!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: headerFontSize,
                color: const Color.fromARGB(255, 128, 128, 128),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: numberFontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 237, 237),
                    border: Border.all(color: const Color.fromARGB(255, 236, 236, 236)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: unitFontSize,
                        color: Colors.orange,
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
