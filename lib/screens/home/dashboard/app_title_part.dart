import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Function(int)? updateIndex;  // Add this parameter

  const AppTitle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.updateIndex,  // Add this to constructor
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
          child: GestureDetector(
            onTap: () {
              if (updateIndex != null) {
                updateIndex!(3);  // Navigate to UserScreen (index 3)
              }
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}