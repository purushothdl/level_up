import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';

class StyledWeightGraph extends StatefulWidget {
  const StyledWeightGraph({super.key});

  @override
  _StyledWeightGraphState createState() => _StyledWeightGraphState();
}

class _StyledWeightGraphState extends State<StyledWeightGraph> {
  final String jsonData = '''
  {
    "weight_tracking": {
      "sep1": "76 Kg",
      "sep8": "78 Kg",
      "sep16": "74.6 Kg",
      "sep22": "73.8 Kg",
      "sep29": "73 Kg",
      "oct6": "77.5 Kg",
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
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    sliderValue = 0.0; // Start slider at the beginning
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            sliderValue = (sliderValue + details.delta.dx / 20).clamp(0.0, weightData.length - 1.0);
          });
        },
        onTapDown: (TapDownDetails details) {
          setState(() {
            double position = details.localPosition.dx;
            double chartWidth = MediaQuery.of(context).size.width - 32; // Adjust for padding
            double value = (position / chartWidth) * (weightData.length - 1);
            sliderValue = value.clamp(0.0, weightData.length - 1.0);
          });
        },
        child: Center(
          child: Container(
            height: 230,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  margin: EdgeInsets.zero,
                  series: <ChartSeries>[
                    SplineAreaSeries<WeightData, String>(
                      dataSource: weightData,
                      xValueMapper: (WeightData data, _) => data.date,
                      yValueMapper: (WeightData data, _) => data.weight,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.6),
                          Colors.blue.withOpacity(0.25),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      splineType: SplineType.natural,
                      borderColor: Colors.blue,
                      borderWidth: 3,
                    ),
                    SplineSeries<WeightData, String>(
                      dataSource: [weightData[sliderValue.toInt()]],
                      xValueMapper: (WeightData data, _) => data.date,
                      yValueMapper: (WeightData data, _) => data.weight,
                      color: Colors.transparent,
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        color: Colors.white,
                        borderColor: Colors.blue,
                        borderWidth: 4,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ],
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),
                  ),
                ),
                // Weight value at the top-right
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${weightData[sliderValue.toInt()].weight} Kg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeightData {
  final String date;
  final double weight;

  WeightData(this.date, this.weight);
}
