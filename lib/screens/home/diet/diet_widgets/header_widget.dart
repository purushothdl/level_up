import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String heading;
  final String? caption;

  const HeaderWidget({
    super.key,
    required this.heading,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headingFontSize = screenWidth < 400 ? 20 : 22; // Responsive font size for heading
    final double captionFontSize = screenWidth < 400 ? 10 : 13; // Responsive font size for caption

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: headingFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          if (caption != null)
            Text(
              caption!,
              style: TextStyle(
                fontSize: captionFontSize,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
