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
    // Get the screen dimensions using MediaQuery
    final Size screenSize = MediaQuery.of(context).size;

    // Set responsive sizes based on screen height
    final double containerHeight = screenSize.height < 600 ? 40 : 46; // Navbar height
    final double fontSize = screenSize.height < 600 ? 14 : 16; // Font size based on screen height

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
          return Flexible(
            child: GestureDetector(
              onTap: () {
                widget.onTap(index);
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 0), // Shorter padding for blue background
                decoration: BoxDecoration(
                  color: widget.selectedIndex == index
                      ? Colors.blue
                      : const Color.fromARGB(255, 240, 240, 240),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
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
