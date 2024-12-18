// lib/widgets/guidelines_widget.dart

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
        children: guidelines.map((guideline) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListTile(
                title: Text(
                  guideline,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  ];
}
