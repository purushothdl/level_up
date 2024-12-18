import 'package:flutter/material.dart';

class WeightPlanWidget extends StatelessWidget {
  final String planName;
  final String currentWeightHeader;
  final int currentWeight;
  final String currentWeightUnits;
  final String goalWeightHeader;
  final int goalWeight;
  final String goalWeightUnits;

  const WeightPlanWidget({
    super.key,
    required this.planName,
    required this.currentWeightHeader,
    required this.currentWeight,
    required this.currentWeightUnits,
    required this.goalWeightHeader,
    required this.goalWeight,
    required this.goalWeightUnits,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left:8, right: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Wrap the Stack with a SizedBox to give it finite constraints
          SizedBox(
            width: double.infinity,  // Ensures it takes the full width
            height: 180,  // Assign a fixed height to the Stack
            child: Stack(
              children: [
                // Image section as the background with black overlay
                Positioned.fill( // Ensures the background container fills the stack
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image.png'), // Replace with your image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Black overlay
                Positioned.fill( // Ensures the overlay container also fills the stack
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Plan name on top-left
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      planName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // Info boxes as overlays with a vertical divider between them
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Info box for current weight
                        Expanded(
                          child: _buildInfoBox(currentWeightHeader, currentWeight, currentWeightUnits, context),
                        ),
                        // White vertical divider
                        Container(
                          width: 2,
                          height: 50,
                          color: Colors.white,
                        ),
                        // Info box for goal weight
                        Expanded(
                          child: _buildInfoBox(goalWeightHeader, goalWeight, goalWeightUnits, context),
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

  Widget _buildInfoBox(String header, int number, String unit, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerFontSize = screenWidth < 400 ? 8 : 12;
    final double numberFontSize = screenWidth < 400 ? 20 : 26;
    final double unitFontSize = screenWidth < 400 ? 12 : 18;

    return Container(
      height: 70,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 184, 182, 182).withOpacity(0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              header,
              style: TextStyle(
                fontSize: headerFontSize,
                color: const Color.fromARGB(255, 181, 181, 181),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Prevent overflow
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: numberFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  // color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: unitFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
