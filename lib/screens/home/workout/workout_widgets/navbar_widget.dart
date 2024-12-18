import 'dart:math'; // Import the math library for sqrt
import 'package:flutter/material.dart';

class NavbarWidget extends StatefulWidget {
  final List<String> values;
  final Function(int) onTap;
  final int selectedIndex;

  const NavbarWidget({
    super.key,
    required this.values,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  _NavbarWidgetState createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate diagonal size in inches (for better scaling)
    final double diagonalSize = sqrt(screenSize.width * screenSize.width +
                                      screenSize.height * screenSize.height) / 160; // 160 pixels per inch (PPI)

    // Set responsive sizes based on diagonal size
    final double containerHeight = diagonalSize < 6 ? 40 : 45; // Height based on diagonal size
    final double fontSize = diagonalSize < 6 ? 14 : 16; // Font size based on diagonal size

    return Container(
      height: containerHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: widget.values.map((value) {
          int index = widget.values.indexOf(value);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTap(index);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: widget.selectedIndex == index
                      ? Colors.blue
                      : const Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize, // Responsive font size
                    fontWeight: FontWeight.w500,
                    color: widget.selectedIndex == index
                        ? Colors.white
                        : const Color.fromARGB(255, 23, 23, 23),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
