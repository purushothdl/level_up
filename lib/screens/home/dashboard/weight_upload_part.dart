import 'package:flutter/material.dart';
// Import the dialog from the other file
import './dashboard_widgets/weight_upload_widget.dart'; // Adjust this path to your actual file

class WeightTrackerWidget extends StatefulWidget {
  const WeightTrackerWidget({Key? key}) : super(key: key);

  @override
  State<WeightTrackerWidget> createState() => _WeightTrackerWidgetState();
}

class _WeightTrackerWidgetState extends State<WeightTrackerWidget> {
  double _currentValue = 50;
  double _startDragX = 0;
  double _lastDragValue = 50;

  void _onTap(double dx) {
    final totalWidth = MediaQuery.of(context).size.width - 32;
    final tapPosition = dx - 16;
    final percentage = (tapPosition / totalWidth).clamp(0.0, 1.0);
    final newValue = percentage * 100;
    setState(() {
      _currentValue = newValue;
    });
  }

  // Function to show the dialog
  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WeightHeightUploadDialog(); // Display the dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16,top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container holding the weight info and the progress bar
          Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Current Weight" label with white opacity background applied only to the label's background
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // "Current Weight" label with a white background and opacity
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Apply opacity to the background of the container
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Current Weight',
                        style: TextStyle(
                          color: Colors.white, // Keep the text color white
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // The number and unit (kg) remain unchanged
                    Row(
                      children: [
                        Text(
                          '${_currentValue.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'kg',
                          style: TextStyle(
                            color: Color(0xff04fc04),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16), // Space between weight info and progress bar
                
                // The progress bar container, restricting clickable area to just the bar itself
                GestureDetector(
                  onHorizontalDragStart: (details) {
                    _startDragX = details.localPosition.dx;
                    _lastDragValue = _currentValue;
                  },
                  onHorizontalDragUpdate: (details) {
                    final dragDistance = details.localPosition.dx - _startDragX;
                    setState(() {
                      _currentValue = (_lastDragValue + dragDistance / 2)
                          .clamp(1.0, 100.0);
                    });
                  },
                  onTapUp: (details) {
                    _onTap(details.localPosition.dx);
                  },
                  onTap: _showUploadDialog, // Trigger the dialog when tapped
                  child: Container(
                    height: 30, // Height for the progress bar area
                    color: Colors.transparent, // Make the area directly on the progress bar clickable
                    child: Stack(
                      children: [
                        Row(
                          children: List.generate(50, (index) {
                            final segmentValue = (index + 1) * 2;
                            final isActive = segmentValue <= _currentValue;
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                height: 30,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
