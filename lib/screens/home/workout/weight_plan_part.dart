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
      margin: EdgeInsets.only(left: 8, right: 8),
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
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Plan name with dynamic width constraint
                Positioned(
                  top: 16,
                  left: 16,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth - 32, // leave some space for padding
                        ),
                        child: Text(
                          planName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                          softWrap: false, // Prevent wrapping
                        ),
                      );
                    },
                  ),
                ),
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
                        Expanded(
                          child: _buildInfoBox(currentWeightHeader, currentWeight, currentWeightUnits, context),
                        ),
                        Container(
                          width: 2,
                          height: 50,
                          color: Colors.white,
                        ),
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
    final double numberFontSize = screenWidth < 400 ? 20 : 22;
    final double unitFontSize = screenWidth < 400 ? 12 : 16;

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
              overflow: TextOverflow.ellipsis,
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
