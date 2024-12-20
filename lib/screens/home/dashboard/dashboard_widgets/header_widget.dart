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
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          if (caption != null)
            Text(
              caption!,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
