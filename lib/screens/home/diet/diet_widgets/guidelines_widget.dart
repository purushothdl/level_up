import 'package:flutter/material.dart';

List<Widget> buildGuidelines(List<dynamic> guidelines) {
  return [
    Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 168, 229, 111),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: guidelines.asMap().map((index, guideline) {
          // Add numbering with different color and align the number to the top
          return MapEntry(
            index,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero, // Remove default padding
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align children at the top
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${index + 1}. ', // Number
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 109, 108, 108), // Different color for the number
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          guideline, // Guideline text
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).values.toList(),
      ),
    ),
  ];
}
