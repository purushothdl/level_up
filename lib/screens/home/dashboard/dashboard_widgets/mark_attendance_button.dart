import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

const double gymLatitude = 13.60278;
const double gymLongitude = 79.41583;
const double attendanceRange = 3000;

class AttendanceButton extends StatefulWidget {
  const AttendanceButton({Key? key}) : super(key: key);

  @override
  _AttendanceButtonState createState() => _AttendanceButtonState();
}

class _AttendanceButtonState extends State<AttendanceButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<bool> isUserNearGym(double gymLat, double gymLng, double thresholdInMeters) async {
  try {
    print("\n=== LOCATION CHECK STARTED ===");
    print("Target Gym Location: ");
    print("Latitude: $gymLat°");
    print("Longitude: $gymLng°");
    print("Allowed Range: $thresholdInMeters meters");

    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      print("❌ Permission check failed");
      print("=== LOCATION CHECK ENDED ===\n");
      return false;
    }
    print("✅ Location permission granted");

    print("📍 Getting current position...");
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 5),
    );

    print("\nCurrent Position Details:");
    print("Latitude: ${position.latitude}°");
    print("Longitude: ${position.longitude}°");
    print("Accuracy: ±${position.accuracy} meters");
    print("Altitude: ${position.altitude} meters");
    print("Speed: ${position.speed} m/s");
    print("Timestamp: ${position.timestamp}");

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      gymLat,
      gymLng,
    );

    print("\nDistance Calculation:");
    print("Calculated distance to gym: ${distance.toStringAsFixed(2)} meters");
    print("Maximum allowed distance: $thresholdInMeters meters");
    
    bool isNear = distance <= thresholdInMeters;
    print(isNear ? "✅ Within range!" : "❌ Out of range!");
    print("=== LOCATION CHECK ENDED ===\n");

    return isNear;
  } catch (e, stackTrace) {
    print("\n❌ ERROR IN LOCATION CHECK:");
    print("Error type: ${e.runtimeType}");
    print("Error message: $e");
    print("Stack trace:");
    print(stackTrace);
    print("=== LOCATION CHECK ENDED WITH ERROR ===\n");

    _showMessageDialog(
      "Error",
      "Failed to get location. Error: $e",
      Colors.red,
      false,
    );
    return false;
  }
}

Future<bool> checkLocationPermission() async {
  print("\n--- Checking Location Permissions ---");
  try {
    // Check if location services are enabled
    print("1. Checking if location services are enabled...");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print(serviceEnabled ? "✅ Location services are enabled" : "❌ Location services are disabled");

    if (!serviceEnabled) {
      print("❌ Location services need to be enabled in device settings");
      _showMessageDialog(
        "Error",
        "Location services are disabled. Please enable them in your settings.",
        Colors.red,
        false,
      );
      return false;
    }

    // Check current permission status
    print("\n2. Checking current permission status...");
    LocationPermission permission = await Geolocator.checkPermission();
    print("Current permission status: $permission");

    if (permission == LocationPermission.denied) {
      print("Permission denied, requesting permission...");
      permission = await Geolocator.requestPermission();
      print("New permission status after request: $permission");

      if (permission == LocationPermission.denied) {
        print("❌ Permission denied by user");
        _showMessageDialog(
          "Error",
          "Location permissions are denied. Please enable them to mark attendance.",
          Colors.red,
          false,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌ Permission permanently denied");
      _showMessageDialog(
        "Error",
        "Location permissions are permanently denied. Please enable them in your settings.",
        Colors.red,
        false,
      );
      return false;
    }

    print("✅ All permission checks passed");
    return true;

  } catch (e, stackTrace) {
    print("\n❌ ERROR CHECKING PERMISSIONS:");
    print("Error type: ${e.runtimeType}");
    print("Error message: $e");
    print("Stack trace:");
    print(stackTrace);
    return false;
  }
}

  Future<void> _markAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool isNearGym = await isUserNearGym(gymLatitude, gymLongitude, attendanceRange);

      if (!isNearGym) {
        _showMessageDialog(
          "Error",
          "You need to be within ${attendanceRange} meters of the gym to mark attendance.",
          Colors.red,
          false,
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token not found in shared preferences");
      }

      final response = await http.post(
        Uri.parse('https://level-up-backend-9hpz.onrender.com/api/mark-attendance'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        _showMessageDialog(
          "Success",
          "Attendance marked successfully!",
          Colors.green,
          true,
        );
      } else {
        _showMessageDialog(
          "Error",
          "Attendance already marked for today! Try again tomorrow.",
          Colors.red,
          false,
        );
      }
    } catch (error) {
      _showMessageDialog(
        "Error",
        "An error occurred while marking attendance.",
        Colors.red,
        false,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessageDialog(String title, String message, Color color, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: color)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isLoading) {
          _markAttendance();
        }
      },
      onTapDown: (_) {
        if (!_isLoading) {
          setState(() {
            _isPressed = true;
          });
          _controller.forward();
        }
      },
      onTapUp: (_) {
        if (!_isLoading) {
          setState(() {
            _isPressed = false;
          });
          _controller.reverse();
        }
      },
      onTapCancel: () {
        if (!_isLoading) {
          setState(() {
            _isPressed = false;
          });
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedOpacity(
              opacity: _isPressed ? 0.5 : 0.9,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: Container(
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey.withOpacity(0.5) : Colors.white.withOpacity(_isPressed ? 0.5 : 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Mark Attendance',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}