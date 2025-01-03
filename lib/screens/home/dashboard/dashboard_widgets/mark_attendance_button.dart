import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import './mark_attendance_widgets/mark_attendance_button_widgets.dart'; // Import the new file

// Constants
const double attendanceRange = 50; // Allowed range for attendance in meters

// // Gym Model
// class Gym {
//   final String name;
//   final double latitude;
//   final double longitude;
//   final String imagePath;

//   Gym({
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     required this.imagePath,
//   });
// }

// home: 13.602945052265659, 79.41596142264298

// List of Gyms
final List<Gym> gyms = [
  Gym(
    name: "Air Bypass Road Branch",
    latitude: 13.622703635970185,
    longitude: 79.41386342472839,
    imagePath: "assets/images/gym_images/level_up_bypass.jpg",
  ),
  Gym(
    name: "Bairagi Patteda Branch",
    latitude: 13.619934282133901,
    longitude: 79.42187772016833,
    imagePath: "assets/images/gym_images/level_up_bairagi_patteda.jpg",
  ),
];

// AttendanceButton Widget
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
  StreamSubscription<Position>? _positionStream;
  double _currentDistance = double.infinity;

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
    _positionStream?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // Get Current Location
  Future<Position?> _getCurrentLocation() async {
    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      return position;
    } catch (e) {
      print("❌ Error getting current location: $e");
      return null;
    }
  }

  // Check Location Permissions
  Future<bool> checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessageDialog(
          "Error",
          "Location services are disabled. Please enable them in your settings.",
          Colors.red,
          false,
        );
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
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
        _showMessageDialog(
          "Error",
          "Location permissions are permanently denied. Please enable them in your settings.",
          Colors.red,
          false,
        );
        return false;
      }

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

  // Find Nearest Gym
  Future<Gym?> _getNearestGym(Position userPosition) async {
    Gym? nearestGym;
    double nearestDistance = double.infinity;

    for (var gym in gyms) {
      double distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        gym.latitude,
        gym.longitude,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestGym = gym;
      }
    }

    return nearestGym;
  }

  // Mark Attendance
  Future<void> _markAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position? position = await _getCurrentLocation();
      if (position == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Gym? nearestGym = await _getNearestGym(position);
      if (nearestGym == null) {
        _showMessageDialog(
          "Error",
          "No gym found nearby.",
          Colors.red,
          false,
        );
        return;
      }

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        nearestGym.latitude,
        nearestGym.longitude,
      );

      setState(() {
        _currentDistance = distance;
      });

      if (distance > attendanceRange) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OutOfRangeDialog(
              context: context,
              gyms: gyms,
              userPosition: position!, // Pass the user's position
            );
          },
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
        // ignore: use_build_context_synchronously
        _showSuccessDialog(context, nearestGym);
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

  // Show Success Dialog
  void _showSuccessDialog(BuildContext context, Gym gym) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
          context: context,
          gym: gym,
          currentDistance: _currentDistance.toInt(),
        );
      },
    );
  }

  // Show Message Dialog
  void _showMessageDialog(String title, String message, Color color, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
          title: title,
          message: message,
          color: color,
          isSuccess: isSuccess,
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