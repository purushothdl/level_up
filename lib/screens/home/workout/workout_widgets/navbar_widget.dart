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
    final Size screenSize = MediaQuery.of(context).size;

    // Responsive sizes
    final double containerHeight = screenSize.height < 600 ? 40 : 46;
    final double fontSize = screenSize.height < 600 ? 14 : 16;

    return Container(
      height: containerHeight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 237, 237),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 183, 182, 182),
          width: 0.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.values.map((value) {
          int index = widget.values.indexOf(value);

          bool isSelected = widget.selectedIndex == index;

          return Flexible(
            child: GestureDetector(
              onTap: () {
                widget.onTap(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: isSelected
                      ? Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 2,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.black
                        : const Color.fromARGB(255, 128, 128, 128),
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
