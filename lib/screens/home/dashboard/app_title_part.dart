import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String title;           // Title text
  final String subtitle;        // Subtitle text
  final String imagePath;       // Image path
  final Color borderColor;      // Border color

  const AppTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.borderColor = const Color.fromARGB(255, 219, 219, 219), // Default border color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Jersey20-Regular',
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Jersey20-Regular',
            color: Colors.orange,
            fontSize: 40,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 60, // Adjust as needed
            height: 60, // Adjust as needed
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 3), // Custom border color
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath, // Use the passed image path
                fit: BoxFit.cover, // Ensure the image covers the circular area
              ),
            ),
          ),
        ),
      ],
    );
  }
}
