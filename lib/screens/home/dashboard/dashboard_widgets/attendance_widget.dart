import 'package:flutter/material.dart';
import 'dart:math';

class AttendanceBar extends StatefulWidget {
  final int totalDays;
  final int presentDays;

  const AttendanceBar({
    super.key,
    required this.totalDays,
    required this.presentDays,
  });

  @override
  _AttendanceBarState createState() => _AttendanceBarState();
}

class _AttendanceBarState extends State<AttendanceBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (widget.presentDays / widget.totalDays) * 100;

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set responsive size for the circle
    double circleSize = min(screenWidth, screenHeight) * 0.25; // 40% of the smaller dimension

    double fontSize = circleSize < 150 ? 22 : 24; // Adjust font size based on circle size

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: CircularGlowPainter(_controller.value, percentage),
                child: SizedBox(
                  height: circleSize,
                  width: circleSize,
                ),
              ),
              CustomPaint(
                painter: WavyExpandingGlowPainter(_controller.value),
                child: SizedBox(
                  height: circleSize,
                  width: circleSize,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: circleSize * 0.8, // Set max width for the text
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontFamily: 'flatley',
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class CircularGlowPainter extends CustomPainter {
  final double animationValue;
  final double percentage;

  CircularGlowPainter(this.animationValue, this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double center = size.width / 2;

    // Draw background fill arc
    Paint backgroundPaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      0,
      2 * pi,
      false,
      backgroundPaint,
    );

    // Draw constant percentage progress arc
    Paint progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class WavyExpandingGlowPainter extends CustomPainter {
  final double animationValue;

  WavyExpandingGlowPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double center = size.width / 2;

    // Draw expanding wavy glow effect
    Paint glowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.15 * (1 - animationValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 + (20 * animationValue);

    Path wavyPath = Path();
    int waveCount = 10;
    for (int i = 0; i < waveCount; i++) {
      double currentRadius = radius + (8 * animationValue) + (i.isEven ? 6 : 12);
      wavyPath.addArc(
        Rect.fromCircle(center: Offset(center, center), radius: currentRadius),
        0,
        2 * pi,
      );
    }

    canvas.drawPath(wavyPath, glowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
