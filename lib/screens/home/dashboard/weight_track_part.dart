import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

class WeightGraph extends StatefulWidget {
  const WeightGraph({super.key});

  @override
  _WeightGraphState createState() => _WeightGraphState();
}

class _WeightGraphState extends State<WeightGraph> {
  final String jsonData = '''
  {
    "weight_tracking": {
      "sep1": "76 Kg",
      "sep8": "74 Kg",
      "sep16": "74.6 Kg",
      "sep22": "73.8 Kg",
      "sep29": "73 Kg",
      "oct6": "72.5 Kg",
      "oct13": "73 Kg",
      "oct20": "71.2 Kg",
      "oct27": "70.6 Kg",
      "nov3": "70.6 Kg",
      "nov10": "71.0 Kg",
      "nov17": "71.5 Kg",
      "nov24": "72.0 Kg"
    }
  }
  ''';

  late List<WeightData> weightData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    Map<String, dynamic> data = json.decode(jsonData);
    Map<String, dynamic> weightDataMap = data['weight_tracking'];

    weightData = weightDataMap.entries.map((entry) {
      return WeightData(entry.key, double.parse((entry.value as String).replaceAll(' Kg', '')));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Split the data at the 8th point
    int splitIndex = 8; // Index of the 8th point

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SfCartesianChart(
                    borderWidth: 0,
                    primaryXAxis: CategoryAxis(
                      axisLine: AxisLine(width: 0),
                      majorGridLines: MajorGridLines(width: 0),
                      majorTickLines: MajorTickLines(width: 0),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.transparent,
                      ),
                      labelPlacement: LabelPlacement.onTicks,
                      labelIntersectAction: AxisLabelIntersectAction.none,
                      isVisible: true,
                      interval: 3,
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: AxisLine(width: 0),
                      isVisible: false,
                      interval: 3,
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      format: 'point.x: point.y Kg',
                    ),
                    margin: const EdgeInsets.all(0),
                    series: <ChartSeries>[
                      SplineAreaSeries<WeightData, String>(
                        name: "Past Weights",
                        dataSource: weightData.sublist(0, splitIndex + 1),
                        xValueMapper: (WeightData data, _) => data.date,
                        yValueMapper: (WeightData data, _) => data.weight,
                        splineType: SplineType.natural,
                        color: Colors.blue.withOpacity(0.2),
                        borderColor: Colors.blue,
                        borderWidth: 3,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          width: 8,
                          height: 8,
                          color: Colors.blue,
                        ),
                      ),
                      SplineAreaSeries<WeightData, String>(
                        name: "Predicted Weights",
                        dataSource: weightData.sublist(splitIndex),
                        xValueMapper: (WeightData data, _) => data.date,
                        yValueMapper: (WeightData data, _) => data.weight,
                        splineType: SplineType.natural,
                        color: Colors.orange.withOpacity(0.2),
                        borderColor: Colors.orange,
                        borderWidth: 3,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          width: 8,
                          height: 8,
                          color: Colors.orange,
                        ),
                      ),
                      SplineSeries<WeightData, String>(
                        name: 'Current Weight',
                        dataSource: [weightData[splitIndex]],
                        xValueMapper: (WeightData data, _) => data.date,
                        yValueMapper: (WeightData data, _) => data.weight,
                        splineType: SplineType.natural,
                        color: Colors.transparent,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          width: 10,
                          height: 10,
                          color: Colors.blue,
                          borderColor: Colors.grey[800],
                          borderWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 18,
                  child: _buildOverlayLabel(context, 'Past', Colors.blue.withOpacity(0.9)),
                ),
                Positioned(
                  bottom: 20,
                  right: 18,
                  child: _buildOverlayLabel(context, 'Predicted', Colors.orange.withOpacity(0.9)),
                ),
              ],
            ),
            // Add month labels below the graph
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMonthLabel(context, 'Sep'),
                  _buildMonthLabel(context, 'Oct'),
                  _buildMonthLabel(context, 'Nov'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthLabel(BuildContext context, String month) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        month,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth < 400 ? 10 : 13,
        ),
      ),
    );
  }

  Widget _buildOverlayLabel(BuildContext context, String text, Color backgroundColor) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.2;
    final double containerHeight = 25;

    return Container(
      margin: EdgeInsets.all(screenWidth * 0.04),
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth < 400 ? 10 : 12,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
