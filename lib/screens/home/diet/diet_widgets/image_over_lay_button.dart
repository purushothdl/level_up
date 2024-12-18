// lib/widgets/image_overlay_button.dart

import 'package:flutter/material.dart';

class ImageOverlayButton extends StatelessWidget {
  final String imagePath;
  final String buttonLabel;
  final Widget targetScreen;

  const ImageOverlayButton({
    super.key,
    required this.imagePath,
    required this.buttonLabel,
    required this.targetScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      width: double.infinity,
      height: 200.0,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 9,
            left: 9,
            child: SizedBox(
              width: 85,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetScreen),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  backgroundColor: const Color.fromARGB(255, 86, 160, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    // side: const BorderSide(color: Colors.grey),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
