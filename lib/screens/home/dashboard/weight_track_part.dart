import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './utils/dashboard_utils.dart';

class StyledWeightGraph extends StatefulWidget {
  const StyledWeightGraph({super.key});

  @override
  _StyledWeightGraphState createState() => _StyledWeightGraphState();
}

class _StyledWeightGraphState extends State<StyledWeightGraph> {
  List<WeightData> weightData = [];  // Initialize with an empty list
  double sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchWeightData(); // Fetch weight data when the widget is initialized
  }

  Future<void> _fetchWeightData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('user_id');  // Assuming 'user_id' is stored in SharedPreferences

    if (userId != null) {
      try {
        // Replace this URL with your actual API endpoint
        final response = await http.get(Uri.parse('https://level-up-backend-9hpz.onrender.com/api/user/get_weight_details/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          // Parse the response
          Map<String, dynamic> data = json.decode(response.body);
          print(data);
          List<dynamic> weightTracking = data['weight_tracking'];

          // Process the weight tracking data
          weightData = weightTracking
              .where((entry) => entry['weight'] != null)
              .map((entry) {
                // Extract date and weight and create WeightData objects
                return WeightData(
                  formatWeightDate(entry['date']),
                  double.parse(entry['weight'].toString()),  // Make sure the weight is a valid number
                );
              }).toList();

          // Rebuild the widget with the fetched data
          setState(() {
            sliderValue = 0.0;  // Reset slider value
          });
        } else {
          throw Exception('Failed to load weight data');
        }
      } catch (e) {
        print("Error fetching weight data: $e");
        // Handle the error, maybe show a Snackbar or a Toast here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: weightData.isEmpty
          ? Center(child: CircularProgressIndicator())  // Show loading spinner if data is empty
          : GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  sliderValue = (sliderValue + details.delta.dx / 20)
                      .clamp(0.0, weightData.length - 1.0);
                });
              },
              onTapDown: (TapDownDetails details) {
                setState(() {
                  double position = details.localPosition.dx;
                  double chartWidth = MediaQuery.of(context).size.width - 32;
                  double value = (position / chartWidth) * (weightData.length - 1);
                  sliderValue = value.clamp(0.0, weightData.length - 1.0);
                });
              },
              child: Center(
                child: Container(
                  height: 230,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.only(bottom: 2),
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
                      // Add the image under the chart
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/diet/detox/detox_overlay.gif', // Replace with your image path
                          width: double.infinity,
                          height: 230,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.zero,
                        series: <ChartSeries>[
                          SplineAreaSeries<WeightData, String>(
                            dataSource: weightData,
                            xValueMapper: (WeightData data, _) => data.date,
                            yValueMapper: (WeightData data, _) => data.weight,
                            color: Colors.transparent, // Make the area transparent to show the image
                            splineType: SplineType.natural,
                            borderColor: Colors.orange,
                            borderWidth: 3,
                          ),
                          SplineSeries<WeightData, String>(
                            dataSource: [weightData[sliderValue.toInt()]],
                            xValueMapper: (WeightData data, _) => data.date,
                            yValueMapper: (WeightData data, _) => data.weight,
                            color: Colors.transparent,
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              color: Colors.orange,
                              borderColor: Colors.orange,
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
                      Positioned(
                        right: 22,
                        top: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                weightData[sliderValue.toInt()].date,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.white
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${weightData[sliderValue.toInt()].weight} Kg',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Rubik-BoldItalic',
                                  fontSize: 18,
                                ),
                              ),
                            ],
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
